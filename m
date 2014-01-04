From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] parsing: add interface to parse from file
Date: Sat, 4 Jan 2014 02:13:33 +0100
Message-ID: <20140104011333.GA5250@localhost>
References: <20140103123145.27058.77216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Alvaro Neira <alvaroneay@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaADBNj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:13:39 -0500
Content-Disposition: inline
In-Reply-To: <20140103123145.27058.77216.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 03, 2014 at 01:33:51PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds API interfaces to parse nft objects from a given stream.
> 
> I found this useful in `nft', where I'm trying to parse XML/JSON from a file.
> 
> about the implementation:
>  * a small selector is added in src/internal.h to avoid duplicating so
>    much code.

This needs to go in a separated patch.

Firstly, patches series with small cleanups/polishing to prepare the
feature, then, the last patch should be the new feature itself. That
helps the reviewer and it's good for the git history as we stick to
"one commit - one logical change".

>  * The ifdef/endif logic in internal.h is reworked, looking for a cleaner
>    file, and also allowing us to use without fear XML/JSON internal datatypes.

It's good if we simplify that ifdef burden that we have. Please,
rework this in an initial cleanup patch.

In this case, I'd like to see something like a changeset composed of
three patches.

> Examples will be updated in a separated patch, but the test infraestructure is
> updated, using this new file-parsing approach.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v1: initial release, using a filename/path as input.
> v2: rework the patch and use a FILE *stream as input. Implement the
>     struct parse_ops and update nft-parsing-test to include tests for this
>     new API.
> 
>  include/libnftables/chain.h   |    1 +
>  include/libnftables/rule.h    |    1 +
>  include/libnftables/ruleset.h |    1 +
>  include/libnftables/set.h     |    2 +
>  include/libnftables/table.h   |    1 +
>  src/chain.c                   |   30 ++++++++++++----
>  src/internal.h                |   45 ++++++++++++++++++++++--
>  src/jansson.c                 |   25 +++++++++++++
>  src/libnftables.map           |    6 +++
>  src/mxml.c                    |   31 ++++++++++++++++
>  src/rule.c                    |   28 +++++++++++----
>  src/ruleset.c                 |   30 ++++++++++++----
>  src/set.c                     |   29 +++++++++++----
>  src/set_elem.c                |   46 ++++++++++++++++++++++--
>  src/table.c                   |   31 ++++++++++++----
>  tests/jsonfiles/01-table.json |    1 -
>  tests/nft-parsing-test.c      |   78 ++++++++++++++++++++++++-----------------
>  17 files changed, 301 insertions(+), 85 deletions(-)
>  delete mode 100644 tests/jsonfiles/01-table.json
> 
> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
> index 8b4eab9..2cffd35 100644
> --- a/include/libnftables/chain.h
> +++ b/include/libnftables/chain.h
> @@ -52,6 +52,7 @@ struct nlmsghdr;
>  void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
>  
>  int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data);
> +int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, FILE *fp);

perhaps you can call all this function _parse_file(...) instead.

>  int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
>  int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
> diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
> index 86dbc17..5f2fa5e 100644
> --- a/include/libnftables/rule.h
> +++ b/include/libnftables/rule.h
> @@ -48,6 +48,7 @@ struct nlmsghdr;
>  void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
>  
>  int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const char *data);
> +int nft_rule_fparse(struct nft_rule *r, enum nft_parse_type type, FILE *fp);
>  int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
>  int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
>  
> diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
> index 1ec3059..1501fc2 100644
> --- a/include/libnftables/ruleset.h
> +++ b/include/libnftables/ruleset.h
> @@ -31,6 +31,7 @@ void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
>  const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
>  
>  int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type, const char *data);
> +int nft_ruleset_fparse(struct nft_ruleset *rs, enum nft_parse_type type, FILE *fp);
>  int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
>  int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
>  
> diff --git a/include/libnftables/set.h b/include/libnftables/set.h
> index 13ac857..ec12769 100644
> --- a/include/libnftables/set.h
> +++ b/include/libnftables/set.h
> @@ -61,6 +61,7 @@ struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter);
>  void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
>  
>  int nft_set_parse(struct nft_set *s, enum nft_parse_type type, const char *data);
> +int nft_set_fparse(struct nft_set *s, enum nft_parse_type type, FILE *fp);
>  
>  /*
>   * Set elements
> @@ -99,6 +100,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem
>  int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
>  
>  int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type, const char *data);
> +int nft_set_elem_fparse(struct nft_set_elem *e, enum nft_parse_type type, FILE *fp);
>  int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
>  int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
>  
> diff --git a/include/libnftables/table.h b/include/libnftables/table.h
> index 1d2be07..8758289 100644
> --- a/include/libnftables/table.h
> +++ b/include/libnftables/table.h
> @@ -41,6 +41,7 @@ struct nlmsghdr;
>  void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t);
>  
>  int nft_table_parse(struct nft_table *t, enum nft_parse_type type, const char *data);
> +int nft_table_fparse(struct nft_table *t, enum nft_parse_type type, FILE *fp);
>  int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
>  int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
>  
> diff --git a/src/chain.c b/src/chain.c
> index a0004b5..45af8db 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -587,13 +587,14 @@ err:
>  }
>  #endif
>  
> -static int nft_chain_json_parse(struct nft_chain *c, const char *json)
> +static int nft_chain_json_buildparse(struct nft_chain *c, const char *json,
> +				     const struct parse_ops *ops)
>  {
>  #ifdef JSON_PARSING
>  	json_t *tree;
>  	json_error_t error;
>  
> -	tree = nft_jansson_create_root(json, &error);
> +	tree = ops->jsonbuilder(json, &error);
>  	if (tree == NULL)
>  		return -1;
>  
> @@ -702,11 +703,12 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c)
>  }
>  #endif
>  
> -static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
> +static int nft_chain_xml_buildparse(struct nft_chain *c, const char *xml,
> +				    const struct parse_ops *ops)
>  {
>  #ifdef XML_PARSING
>  	int ret;
> -	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain");
> +	mxml_node_t *tree = ops->xmlbuilder(xml, "chain");
>  	if (tree == NULL)
>  		return -1;
>  
> @@ -719,17 +721,17 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
>  #endif
>  }
>  
> -int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
> -		    const char *data)
> +static int nft_chain_do_parse(struct nft_chain *c, enum nft_parse_type type,
> +			      const void *data, const struct parse_ops *ops)
>  {
>  	int ret;
>  
>  	switch (type) {
>  	case NFT_PARSE_XML:
> -		ret = nft_chain_xml_parse(c, data);
> +		ret = nft_chain_xml_buildparse(c, data, ops);
>  		break;
>  	case NFT_PARSE_JSON:
> -		ret = nft_chain_json_parse(c, data);
> +		ret = nft_chain_json_buildparse(c, data, ops);
>  		break;
>  	default:
>  		ret = -1;
> @@ -739,8 +741,20 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
>  
>  	return ret;
>  }
> +
> +int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data)
> +{
> +	return nft_chain_do_parse(c, type, data, &parse_string_ops);
> +}
>  EXPORT_SYMBOL(nft_chain_parse);
>  
> +int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, FILE *fp)
> +{
> +	return nft_chain_do_parse(c, type, fp, &parse_stream_ops);
> +}
> +EXPORT_SYMBOL(nft_chain_fparse);
> +
> +
>  static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
>  {
>  	int ret, len = size, offset = 0;
> diff --git a/src/internal.h b/src/internal.h
> index a10d874..e0b9761 100644
> --- a/src/internal.h
> +++ b/src/internal.h

Alvaro's patch is also changing the internal.h file. You need to
coordinate since you're working on the parsing infrastructure at the
same time to avoid clashing on this, otherwise the patch coming later
won't apply and one of you will have to rework it.
