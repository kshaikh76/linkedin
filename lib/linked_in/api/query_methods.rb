module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end

      def group_memberships(options = {})
        path = "#{person_path(options)}/group-memberships"
        simple_query(path, options)
      end
      
      def shares(options={})
        path = "#{person_path(options)}/network/updates?type=SHAR&scope=self"
        simple_query(path, options)
      end


      def share_comments(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      def share_likes(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end

      # Get company updates. 
      # For parameters and output format see here - http://developer.linkedin.com/reading-company-updates
      def company_updates(options={})
        start = options[:start] ? options[:start] : 0
        limit = options[:limit] ? options[:limit] : 10
        path = "/companies/#{options[:id]}/updates?event-type=#{options[:event_type]}&start=#{start}&limit=#{limit}"
        simple_query(path, options)
      end

      # Do a company search.
      # For more details check this - http://developer.linkedin.com/documents/company-search
      def company_search(options={})
        path = "/company-search?"
        params = {"keywords" => "keywords", "hq-only" => "hq_only", 
                "facet" => "facet", "facets" => "facets", "sort" => "sort"}
        params.each do |k, v|
          if options[v.to_sym]
            path +=  "#{k}=" + URI::encode(options[v.to_sym]) + '&' 
          end    
        end
        path += pagination_params(options)
        simple_query(path)
      end

      # Get a list of companies following
      # More details can be found here - http://developer.linkedin.com/documents/company-follow-and-suggestions
      def companies_following()
        path = "/people/~/following/companies"
        simple_query(path)
      end

      # Get a list of suggested companies to follow
      # More details can be found here - http://developer.linkedin.com/documents/company-follow-and-suggestions
      def suggested_companies()
        path = "/people/~/suggestions/to-follow/companies"
        simple_query(path)
      end

      # Get a list of company products 
      # More details can be found here - http://developer.linkedin.com/documents/company-products-and-recommendations
      def company_products(options={})
        path = "/companies/#{options[:id]}/products?" + pagination_params(options) 
        simple_query(path)
      end


      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || LinkedIn.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          Mash.from_json(get(path, headers))
        end

        def person_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
        end

        def company_path(options)
          path = "/companies/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          elsif name = options.delete(:name)
            path += "universal-name=#{CGI.escape(name)}"
          elsif domain = options.delete(:domain)
            path += "email-domain=#{CGI.escape(domain)}"
          else
            path += "~"
          end
        end

        def pagination_params(options)
          start = options[:start] ? options[:start] : 0
          count = options[:count] ? options[:count] : 10
          return "start=#{start}&count=#{count}&"
        end

    end

  end
end
