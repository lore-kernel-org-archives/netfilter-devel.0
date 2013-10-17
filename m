From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: add fprintf functions
Date: Thu, 17 Oct 2013 12:11:01 +0200
Message-ID: <20131017101101.GA10727@localhost>
References: <20131016171437.27537.1477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33005 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3JQKLH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:11:07 -0400
Content-Disposition: inline
In-Reply-To: <20131016171437.27537.1477.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Wed, Oct 16, 2013 at 07:14:38PM +0200, Arturo Borrero Gonzalez wrote:
> Now it's possible to print directly from libnftables to a file or other stream.
> 
> In order to don't force any format, the caller must print '\n'.
> 
> Signed-off-by: Arturo Borrero Gonzale <arturo.borrero.glez@gmail.com>
> ---
>  include/libnftables/chain.h   |    1 +
>  include/libnftables/rule.h    |    1 +
>  include/libnftables/ruleset.h |    1 +
>  include/libnftables/set.h     |    2 ++
>  include/libnftables/table.h   |    1 +
>  src/chain.c                   |   27 +++++++++++++++++++++++++++
>  src/internal.h                |    2 ++
>  src/libnftables.map           |    6 ++++++
>  src/rule.c                    |   27 +++++++++++++++++++++++++++
>  src/ruleset.c                 |   28 ++++++++++++++++++++++++++++
>  src/set.c                     |   27 +++++++++++++++++++++++++++
>  src/set_elem.c                |   27 +++++++++++++++++++++++++++
>  src/table.c                   |   27 +++++++++++++++++++++++++++
>  13 files changed, 177 insertions(+)
> 
> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
> index d3086ea..4b58f16 100644
> --- a/include/libnftables/chain.h
> +++ b/include/libnftables/chain.h
> @@ -58,6 +58,7 @@ enum nft_chain_parse_type {
>  
>  int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type, const char *data);
>  int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
> +int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
>  
>  struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
>  int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *t);
> diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
> index 9fba9c8..a35b700 100644
> --- a/include/libnftables/rule.h
> +++ b/include/libnftables/rule.h
> @@ -57,6 +57,7 @@ enum nft_rule_parse_type {
>  
>  int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, const char *data);
>  int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
> +int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
>  
>  struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
>  int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *t);
> diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
> index a4a1279..980276d 100644
> --- a/include/libnftables/ruleset.h
> +++ b/include/libnftables/ruleset.h
> @@ -37,6 +37,7 @@ enum nft_ruleset_parse_type {
>  
>  int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse_type type, const char *data);
>  int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
> +int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/include/libnftables/set.h b/include/libnftables/set.h
> index e377826..2bddda4 100644
> --- a/include/libnftables/set.h
> +++ b/include/libnftables/set.h
> @@ -36,6 +36,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
>  int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
>  
>  int nft_set_snprintf(char *buf, size_t size, struct nft_set *s, uint32_t type, uint32_t flags);
> +int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type, uint32_t flags);
>  
>  struct nft_set_list;
>  
> @@ -106,6 +107,7 @@ int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s)
>  
>  int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type type, const char *data);
>  int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
> +int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
>  
>  int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
>  
> diff --git a/include/libnftables/table.h b/include/libnftables/table.h
> index 66574cf..c412c43 100644
> --- a/include/libnftables/table.h
> +++ b/include/libnftables/table.h
> @@ -46,6 +46,7 @@ enum nft_table_parse_type {
>  
>  int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type, const char *data);
>  int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
> +int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
>  
>  struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
>  int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t);
> diff --git a/src/chain.c b/src/chain.c
> index f831479..b92b22f 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -851,6 +851,33 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
>  }
>  EXPORT_SYMBOL(nft_chain_snprintf);
>  
> +int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type,
> +		      uint32_t flags)
> +{
> +	char _buf[NFT_SNPRINTF_BUFSIZ];
> +	char *buf = _buf;
> +	size_t bufsiz = sizeof(_buf);
> +	int ret;
> +
> +	ret = nft_chain_snprintf(buf, bufsiz, c, type, flags);
> +	if (ret > NFT_SNPRINTF_BUFSIZ) {
> +		buf = calloc(1, ret);
> +		if (buf == NULL)
> +			return -1;
> +
> +		bufsiz = ret;
> +		ret = nft_chain_snprintf(buf, bufsiz, c, type, flags);
> +	}
> +
> +	ret = fprintf(fp, "%s", buf);
> +
> +	if (buf != _buf)
> +		xfree(buf);
> +
> +	return ret;
> +}

Most of this code looks very similar, I think you can refactorize it
by adding some internal function:

int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
                size_t (*snprintf_cb)(char *but, size_t bufsiz, void *obj,
                                      uint32_t type, uint32_t flags))
{
        ...

        ret = snprintf_cb(...);
        if (...) {
                ...
                ret = snprintf_cb(...);
        }
        ...
}

Thus, nft_chain_fprintf looks like:

int nft_chain_fprintf(...)
{
        return nft_fprintf(..., nft_chain_snprintf);
}

One more comment below.

> +EXPORT_SYMBOL(nft_chain_fprintf);
> +
>  struct nft_chain_list {
>  	struct list_head list;
>  };
> diff --git a/src/internal.h b/src/internal.h
> index b29288a..e0f17ec 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -17,6 +17,8 @@
>  #define BASE_DEC 10
>  #define BASE_HEX 16
>  
> +#define NFT_SNPRINTF_BUFSIZ 4096
> +
>  enum nft_type {
>  	NFT_TYPE_U8,
>  	NFT_TYPE_U16,
> diff --git a/src/libnftables.map b/src/libnftables.map
> index 1223403..aa47714 100644
> --- a/src/libnftables.map
> +++ b/src/libnftables.map
> @@ -12,6 +12,7 @@ global:
>    nft_table_attr_get_str;
>    nft_table_parse;
>    nft_table_snprintf;
> +  nft_table_fprintf;
>    nft_table_nlmsg_build_hdr;
>    nft_table_nlmsg_build_payload;
>    nft_table_nlmsg_parse;
> @@ -42,6 +43,7 @@ global:
>    nft_chain_attr_get_str;
>    nft_chain_parse;
>    nft_chain_snprintf;
> +  nft_chain_fprintf;
>    nft_chain_nlmsg_build_hdr;
>    nft_chain_nlmsg_build_payload;
>    nft_chain_nlmsg_parse;
> @@ -71,6 +73,7 @@ global:
>    nft_rule_attr_get_str;
>    nft_rule_parse;
>    nft_rule_snprintf;
> +  nft_rule_fprintf;
>    nft_rule_nlmsg_build_hdr;
>    nft_rule_nlmsg_build_payload;
>    nft_rule_nlmsg_parse;
> @@ -126,6 +129,7 @@ global:
>    nft_set_nlmsg_parse;
>    nft_set_parse;
>    nft_set_snprintf;
> +  nft_set_fprintf;
>  
>    nft_set_list_alloc;
>    nft_set_list_free;
> @@ -157,6 +161,7 @@ global:
>    nft_set_elem_nlmsg_parse;
>    nft_set_elem_parse;
>    nft_set_elem_snprintf;
> +  nft_set_elem_fprinf;
>  
>    nft_set_elems_nlmsg_build_payload;
>    nft_set_elems_nlmsg_parse;
> @@ -176,6 +181,7 @@ global:
>    nft_ruleset_attr_get;
>    nft_ruleset_parse;
>    nft_ruleset_snprintf;
> +  nft_ruleset_fprintf;
>  
>  local: *;
>  };
> diff --git a/src/rule.c b/src/rule.c
> index 7f2bce6..68e733b 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -843,6 +843,33 @@ int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
>  }
>  EXPORT_SYMBOL(nft_rule_snprintf);
>  
> +int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type,
> +		     uint32_t flags)
> +{
> +	char _buf[NFT_SNPRINTF_BUFSIZ];
> +	char *buf = _buf;
> +	size_t bufsiz = sizeof(_buf);
> +	int ret;
> +
> +	ret = nft_rule_snprintf(buf, bufsiz, r, type, flags);
> +	if (ret > NFT_SNPRINTF_BUFSIZ) {
> +		buf = calloc(1, ret);
> +		if (buf == NULL)
> +			return -1;
> +
> +		bufsiz = ret;
> +		ret = nft_rule_snprintf(buf, bufsiz, r, type, flags);
> +	}
> +
> +	ret = fprintf(fp, "%s", buf);
> +
> +	if (buf != _buf)
> +		xfree(buf);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(nft_rule_fprintf);
> +
>  int nft_rule_expr_foreach(struct nft_rule *r,
>                            int (*cb)(struct nft_rule_expr *e, void *data),
>                            void *data)
> diff --git a/src/ruleset.c b/src/ruleset.c
> index a7fbc33..54c3fc1 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -811,3 +811,31 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
>  	return -1;
>  }
>  EXPORT_SYMBOL(nft_ruleset_snprintf);
> +
> +int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
> +			uint32_t flags)
> +{
> +	char _buf[NFT_SNPRINTF_BUFSIZ];
> +	char *buf = _buf;
> +	size_t bufsiz = sizeof(_buf);
> +	int ret;
> +
> +	ret = nft_ruleset_snprintf(buf, bufsiz, rs, type, flags);
> +	if (ret > NFT_SNPRINTF_BUFSIZ) {

For set and ruleset objects, this branch is very likely to happen,
since it is very likely that the buffer will be too small. To avoid
this, I think it's better to provide an optimized version for this
function that iterates over the list of objects and print them.

> +		buf = calloc(1, ret);
> +		if (buf == NULL)
> +			return -1;
> +
> +		bufsiz = ret;
> +		ret = nft_ruleset_snprintf(buf, bufsiz, rs, type, flags);
> +	}
> +
> +	ret = fprintf(fp, "%s", buf);
> +
> +	if (buf != _buf)
> +		xfree(buf);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(nft_ruleset_fprintf);
