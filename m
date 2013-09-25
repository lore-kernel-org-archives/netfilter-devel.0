From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2 2/2] This patch adds a ruleset object API
 to libnftables.
Date: Wed, 25 Sep 2013 22:38:01 +0200
Message-ID: <20130925203801.GA13683@localhost>
References: <20130924125410.18650.33470.stgit@Ph0enix>
 <20130924125421.18650.8806.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab3IYUiJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:38:09 -0400
Content-Disposition: inline
In-Reply-To: <20130924125421.18650.8806.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

@Arturo, could you resolve the following issues in Alvaro's patch and
send a new version? Thanks.

On Tue, Sep 24, 2013 at 02:54:21PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/libnftables/Makefile.am |    3=20
>  include/libnftables/ruleset.h   |   45 ++
>  src/Makefile.am                 |    1=20
>  src/chain.c                     |    2=20
>  src/internal.h                  |    8=20
>  src/libnftables.map             |    9=20
>  src/rule.c                      |    2=20
>  src/ruleset.c                   |  759 +++++++++++++++++++++++++++++=
++++++++++
>  src/set.c                       |    2=20
>  src/table.c                     |    2=20
>  tests/jsonfiles/64-ruleset.json |    2=20
>  tests/nft-parsing-test.c        |   40 ++
>  tests/xmlfiles/75-ruleset.xml   |    1=20
>  13 files changed, 871 insertions(+), 5 deletions(-)
>  create mode 100644 include/libnftables/ruleset.h
>  create mode 100644 src/ruleset.c
>  create mode 100644 tests/jsonfiles/64-ruleset.json
>  create mode 100644 tests/xmlfiles/75-ruleset.xml
>=20
> diff --git a/include/libnftables/Makefile.am b/include/libnftables/Ma=
kefile.am
> index b052992..e243f32 100644
> --- a/include/libnftables/Makefile.am
> +++ b/include/libnftables/Makefile.am
> @@ -2,4 +2,5 @@ pkginclude_HEADERS =3D table.h		\
>  		     chain.h		\
>  		     rule.h		\
>  		     expr.h		\
> -		     set.h
> +		     set.h		\
> +		     ruleset.h
> diff --git a/include/libnftables/ruleset.h b/include/libnftables/rule=
set.h
> new file mode 100644
> index 0000000..a4a1279
> --- /dev/null
> +++ b/include/libnftables/ruleset.h
> @@ -0,0 +1,45 @@
> +#ifndef _RULESET_H_
> +#define _RULESET_H_
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +struct nft_ruleset;
> +
> +struct nft_ruleset *nft_ruleset_alloc(void);
> +void nft_ruleset_free(struct nft_ruleset *r);
> +
> +enum {
> +	NFT_RULESET_ATTR_TABLELIST =3D 0,
> +	NFT_RULESET_ATTR_CHAINLIST,
> +	NFT_RULESET_ATTR_SETLIST,
> +	NFT_RULESET_ATTR_RULELIST,
> +};
> +
> +bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t a=
ttr);
> +void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
> +void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void=
 *data);
> +const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16=
_t attr);
> +
> +enum {
> +	NFT_RULESET_O_DEFAULT	=3D 0,
> +	NFT_RULESET_O_XML,
> +	NFT_RULESET_O_JSON,
> +};
> +
> +enum nft_ruleset_parse_type {
> +	NFT_RULESET_PARSE_NONE	=3D 0,
> +	NFT_RULESET_PARSE_XML,
> +	NFT_RULESET_PARSE_JSON,
> +	NFT_RULESET_PARSE_MAX,
> +};
> +
> +int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse=
_type type, const char *data);
> +int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ru=
leset *rs, uint32_t type, uint32_t flags);
> +
> +#ifdef __cplusplus
> +} /* extern "C" */
> +#endif
> +
> +#endif /* _RULESET_H_ */
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 51b40a2..474dbf0 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -10,6 +10,7 @@ libnftables_la_SOURCES =3D utils.c		\
>  			 rule.c			\
>  			 set.c			\
>  			 set_elem.c		\
> +			 ruleset.c		\
>  			 mxml.c			\
>  			 jansson.c		\
>  			 expr.c			\
> diff --git a/src/chain.c b/src/chain.c
> index 8c0d804..e3f70e0 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -506,7 +506,7 @@ static inline int nft_str2hooknum(int family, con=
st char *hook)
>  }
> =20
>  #ifdef JSON_PARSING
> -static int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree=
)
> +int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree)
>  {
>  	json_t *root;
>  	uint64_t uval64;
> diff --git a/src/internal.h b/src/internal.h
> index df64dd8..b29288a 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -71,6 +71,14 @@ int nft_jansson_data_reg_parse(json_t *root, const=
 char *tag,
>  			       union nft_data_reg *data_reg);
>  struct nft_set_elem;
>  int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root);
> +struct nft_table;
> +int nft_jansson_parse_table(struct nft_table *t, json_t *tree);
> +struct nft_chain;
> +int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree);
> +struct nft_rule;
> +int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree);
> +struct nft_set;
> +int nft_jansson_parse_set(struct nft_set *s, json_t *tree);
>  #endif
> =20
>  const char *nft_family2str(uint32_t family);
> diff --git a/src/libnftables.map b/src/libnftables.map
> index 963c03e..1223403 100644
> --- a/src/libnftables.map
> +++ b/src/libnftables.map
> @@ -168,5 +168,14 @@ global:
>    nft_set_elems_iter_next;
>    nft_set_elems_iter_destroy;
> =20
> +  nft_ruleset_alloc;
> +  nft_ruleset_free;
> +  nft_ruleset_attr_is_set;
> +  nft_ruleset_attr_unset;
> +  nft_ruleset_attr_set;
> +  nft_ruleset_attr_get;
> +  nft_ruleset_parse;
> +  nft_ruleset_snprintf;
> +
>  local: *;
>  };
> diff --git a/src/rule.c b/src/rule.c
> index e593109..c8e1b99 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -470,7 +470,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nft_rule *r)
>  EXPORT_SYMBOL(nft_rule_nlmsg_parse);
> =20
>  #ifdef JSON_PARSING
> -static int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
> +int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
>  {
>  	json_t *root, *array;
>  	struct nft_rule_expr *e;
> diff --git a/src/ruleset.c b/src/ruleset.c
> new file mode 100644
> index 0000000..2c30a56
> --- /dev/null
> +++ b/src/ruleset.c
> @@ -0,0 +1,759 @@
> +/*
> + * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
> + * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
> + * (C) 2013 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation; either version 2 of the License,=
 or
> + * (at your option) any later version.
> + *
> + * This code has been sponsored by Sophos Astaro <http://www.sophos.=
com>
> + */
> +
> +#include <errno.h>
> +
> +#include "internal.h"
> +
> +#include <libmnl/libmnl.h>
> +#include <libnftables/ruleset.h>
> +#include <libnftables/table.h>
> +#include <libnftables/chain.h>
> +#include <libnftables/set.h>
> +#include <libnftables/rule.h>
> +
> +struct nft_ruleset {
> +	struct nft_table_list	*table_list;
> +	struct nft_chain_list	*chain_list;
> +	struct nft_set_list	*set_list;
> +	struct nft_rule_list	*rule_list;
> +
> +	uint16_t		flags;
> +};
> +
> +struct nft_ruleset *nft_ruleset_alloc(void)
> +{
> +	return calloc(1, sizeof(struct nft_ruleset));
> +}
> +EXPORT_SYMBOL(nft_ruleset_alloc);
> +
> +void nft_ruleset_free(struct nft_ruleset *r)
> +{
> +	if (r->flags & (1 << NFT_RULESET_ATTR_TABLELIST))
> +		nft_table_list_free(r->table_list);
> +

You can remove these empty lines.

> +	if (r->flags & (1 << NFT_RULESET_ATTR_CHAINLIST))
> +		nft_chain_list_free(r->chain_list);
> +
> +	if (r->flags & (1 << NFT_RULESET_ATTR_SETLIST))
> +		nft_set_list_free(r->set_list);
> +
> +	if (r->flags & (1 << NFT_RULESET_ATTR_RULELIST))
> +		nft_rule_list_free(r->rule_list);
> +
> +	xfree(r);
> +}
> +EXPORT_SYMBOL(nft_ruleset_free);
> +
> +bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t a=
ttr)
> +{
> +	return r->flags & (1 << attr);
> +}
> +EXPORT_SYMBOL(nft_ruleset_attr_is_set);
> +
> +void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr)
> +{
> +	if (!(r->flags & (1 << attr)))
> +		return;
> +
> +	switch (attr) {
> +	case NFT_RULESET_ATTR_TABLELIST:
> +		nft_table_list_free(r->table_list);
> +		r->table_list =3D NULL;
> +		break;
> +	case NFT_RULESET_ATTR_CHAINLIST:
> +		nft_chain_list_free(r->chain_list);
> +		r->chain_list =3D NULL;
> +		break;
> +	case NFT_RULESET_ATTR_SETLIST:
> +		nft_set_list_free(r->set_list);
> +		r->set_list =3D NULL;
> +		break;
> +	case NFT_RULESET_ATTR_RULELIST:
> +		nft_rule_list_free(r->rule_list);
> +		r->rule_list =3D NULL;
> +		break;
> +	}
> +	r->flags &=3D ~(1 << attr);
> +}
> +EXPORT_SYMBOL(nft_ruleset_attr_unset);
> +
> +void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void=
 *data)
> +{
> +	switch (attr) {
> +	case NFT_RULESET_ATTR_TABLELIST:
> +		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_TABLELIST);
> +		r->table_list =3D data;
> +		break;
> +	case NFT_RULESET_ATTR_CHAINLIST:
> +		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_CHAINLIST);
> +		r->chain_list =3D data;
> +		break;
> +	case NFT_RULESET_ATTR_SETLIST:
> +		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_SETLIST);
> +		r->set_list =3D data;
> +		break;
> +	case NFT_RULESET_ATTR_RULELIST:
> +		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_RULELIST);
> +		r->rule_list =3D data;
> +		break;
> +	default:
> +		return;
> +	}
> +	r->flags |=3D (1 << attr);
> +}
> +EXPORT_SYMBOL(nft_ruleset_attr_set);
> +
> +const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16=
_t attr)
> +{
> +	if (!(r->flags & (1 << attr)))
> +		return NULL;
> +
> +	switch (attr) {
> +	case NFT_RULESET_ATTR_TABLELIST:
> +		return r->table_list;
> +	case NFT_RULESET_ATTR_CHAINLIST:
> +		return r->chain_list;
> +	case NFT_RULESET_ATTR_SETLIST:
> +		return r->set_list;
> +	case NFT_RULESET_ATTR_RULELIST:
> +		return r->rule_list;
> +	default:
> +		return NULL;
> +	}
> +}
> +EXPORT_SYMBOL(nft_ruleset_attr_get);
> +
> +#ifdef JSON_PARSING
> +static int nft_ruleset_json_parse_table(struct nft_table_list *table=
_list,
> +					json_t *root)
> +{
> +	struct nft_table *t;
> +
> +	t =3D nft_table_alloc();
> +	if (t =3D=3D NULL)
> +		goto err;
> +
> +	if (nft_jansson_parse_table(t, root) < 0)
> +		goto err;
> +
> +	nft_table_list_add_tail(t, table_list);
> +
> +	return 0;
> +err:
> +	nft_table_free(t);
> +	return -1;
> +}
> +
> +static int nft_ruleset_json_parse_chain(struct nft_chain_list *chain=
_list,
> +					json_t *root)
> +{
> +	struct nft_chain *c;
> +
> +	c =3D nft_chain_alloc();
> +	if (c =3D=3D NULL)
> +		goto err;
> +
> +	if (nft_jansson_parse_chain(c, root) < 0)
> +		goto err;
> +
> +	nft_chain_list_add_tail(c, chain_list);
> +
> +	return 0;
> +err:
> +	nft_chain_free(c);
> +	return -1;
> +}
> +
> +static int nft_ruleset_json_parse_rule(struct nft_rule_list *rule_li=
st,
> +				       json_t *root)
> +{
> +	struct nft_rule *r;
> +
> +	r =3D nft_rule_alloc();
> +	if (r =3D=3D NULL)
> +		goto err;
> +
> +	if (nft_jansson_parse_rule(r, root) < 0)
> +		goto err;
> +
> +	nft_rule_list_add_tail(r, rule_list);
> +
> +	return 0;
> +err:
> +	nft_rule_free(r);
> +	return -1;
> +}
> +
> +static int nft_ruleset_json_parse_set(struct nft_set_list *set_list,
> +				      json_t *root)
> +{
> +	struct nft_set *s;
> +
> +	s =3D nft_set_alloc();
> +	if (s =3D=3D NULL)
> +		goto err;
> +
> +	if (nft_jansson_parse_set(s, root) < 0)
> +		goto err;
> +
> +	nft_set_list_add_tail(s, set_list);
> +
> +	return 0;
> +err:
> +	nft_set_free(s);
> +	return -1;
> +}
> +
> +static int nft_jansson_parse_ruleset(struct nft_ruleset *rs, json_t =
*tree)
> +{
> +	json_t *node, *array;
> +	int i;
> +	struct nft_table_list *table_list =3D nft_table_list_alloc();
> +	struct nft_chain_list *chain_list =3D nft_chain_list_alloc();
> +	struct nft_set_list *set_list =3D nft_set_list_alloc();
> +	struct nft_rule_list *rule_list =3D nft_rule_list_alloc();
> +
> +	if (table_list =3D=3D NULL || chain_list =3D=3D NULL || set_list =3D=
=3D NULL ||
> +	    rule_list =3D=3D NULL) {
> +		errno =3D ENOMEM;
> +		goto err;
> +	}
> +
> +	array =3D nft_jansson_get_node(tree, "nftables");
> +	if (array =3D=3D NULL)
> +		return -1;
> +
> +	for (i =3D 0; i < json_array_size(array); ++i) {
> +		node =3D json_array_get(array, i);
> +		if (nft_jansson_node_exist(node, "table"))
> +			if (nft_ruleset_json_parse_table(table_list, node) < 0)

Better use:
                if (x && y < 0)
                        goto err;

> +				goto err;
> +		if (nft_jansson_node_exist(node, "chain"))
> +			if (nft_ruleset_json_parse_chain(chain_list, node) < 0)
> +				goto err;
> +		if (nft_jansson_node_exist(node, "rule"))
> +			if (nft_ruleset_json_parse_rule(rule_list, node) < 0)
> +				goto err;
> +		if (nft_jansson_node_exist(node, "set"))
> +			if (nft_ruleset_json_parse_set(set_list, node) < 0)
> +				goto err;
> +	}
> +
> +	if (nft_table_list_is_empty(table_list)
> +	    && nft_chain_list_is_empty(chain_list)
> +	    && nft_set_list_is_empty(set_list)
> +	    && nft_rule_list_is_empty(rule_list)) {
> +		errno =3D EINVAL;
> +		goto err;
> +	}

I don't think we should return an error in this case, remove these
lines above. Same thing in the XML parsing.

BTW, coding style is:

if (aaaaaaaa &&
    bbbbbbbb) {
        ...
}

The ampersand always at the end.

> +	if (!nft_table_list_is_empty(table_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
> +				     table_list);
> +	else
> +		nft_table_list_free(table_list);
> +
> +	if (!nft_chain_list_is_empty(chain_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
> +				     chain_list);
> +	else
> +		nft_chain_list_free(chain_list);
> +
> +	if (!nft_set_list_is_empty(set_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
> +	else
> +		nft_set_list_free(set_list);
> +
> +	if (!nft_rule_list_is_empty(rule_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
> +	else
> +		nft_rule_list_free(rule_list);
> +
> +	nft_jansson_free_root(tree);
> +	return 0;
> +
> +err:

I don't like this error handling, it's sloppy, better add tags for
each step, so we can remove the if checking, ie.

err:
        ...
err_table:
        ...
err_chain:
        ...
err_set:
        ...

> +	if (table_list)
> +		nft_table_list_free(table_list);
> +	if (chain_list)
> +		nft_chain_list_free(chain_list);
> +	if (set_list)
> +		nft_set_list_free(set_list);
> +	if (rule_list)
> +		nft_rule_list_free(rule_list);
> +
> +	nft_jansson_free_root(tree);
> +	return -1;
> +}
> +#endif
> +
> +static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char=
 *json)
> +{
> +#ifdef JSON_PARSING
> +	json_t *tree;
> +	json_error_t error;
> +
> +	tree =3D nft_jansson_create_root(json, &error);
> +	if (tree =3D=3D NULL)
> +		return -1;
> +
> +	return nft_jansson_parse_ruleset(rs, tree);
> +#else
> +	errno =3D EOPNOTSUPP;
> +	return -1;
> +#endif
> +}
> +
> +#ifdef XML_PARSING
> +static int
> +nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tr=
ee)
> +{
> +	mxml_node_t *node;
> +	struct nft_table *t;
> +	struct nft_table_list *table_list =3D nft_table_list_alloc();
> +	if (table_list =3D=3D NULL) {
> +		errno =3D ENOMEM;
> +		return -1;
> +	}
> +
> +	for (node =3D mxmlFindElement(tree, tree, "table", NULL, NULL,
> +				    MXML_DESCEND_FIRST);
> +	     node !=3D NULL;
> +	     node =3D mxmlFindElement(node, tree, "table", NULL, NULL,
> +				    MXML_NO_DESCEND)) {
> +		t =3D nft_table_alloc();
> +		if (t =3D=3D NULL)
> +			goto err_free;
> +
> +		if (nft_mxml_table_parse(node, t) !=3D 0) {
> +			nft_table_free(t);
> +			goto err_free;
> +		}
> +
> +		nft_table_list_add_tail(t, table_list);
> +	}
> +
> +	if (!nft_table_list_is_empty(table_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
> +				     table_list);
> +	else
> +		nft_table_list_free(table_list);
> +
> +	return 0;
> +err_free:
> +	nft_table_list_free(table_list);
> +	return -1;
> +}
> +
> +static int
> +nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tr=
ee)
> +{
> +	mxml_node_t *node;
> +	struct nft_chain *c;
> +	struct nft_chain_list *chain_list =3D nft_chain_list_alloc();
> +	if (chain_list =3D=3D NULL) {
> +		errno =3D ENOMEM;
> +		return -1;
> +	}
> +
> +	for (node =3D mxmlFindElement(tree, tree, "chain", NULL, NULL,
> +				    MXML_DESCEND_FIRST);
> +	     node !=3D NULL;
> +	     node =3D mxmlFindElement(node, tree, "chain", NULL, NULL,
> +				    MXML_NO_DESCEND)) {
> +		c =3D nft_chain_alloc();
> +		if (c =3D=3D NULL)
> +			goto err_free;
> +
> +		if (nft_mxml_chain_parse(node, c) !=3D 0) {
> +			nft_chain_free(c);
> +			goto err_free;
> +		}
> +
> +		nft_chain_list_add_tail(c, chain_list);
> +	}
> +
> +	if (!nft_chain_list_is_empty(chain_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
> +				     chain_list);
> +	else
> +		nft_chain_list_free(chain_list);
> +
> +	return 0;
> +err_free:
> +	nft_chain_list_free(chain_list);
> +	return -1;
> +}
> +
> +static int
> +nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tre=
e)
> +{
> +	mxml_node_t *node;
> +	struct nft_rule *r;
> +	struct nft_rule_list *rule_list =3D nft_rule_list_alloc();
> +	if (rule_list =3D=3D NULL) {
> +		errno =3D ENOMEM;
> +		return -1;
> +	}
> +
> +	for (node =3D mxmlFindElement(tree, tree, "rule", NULL, NULL,
> +				    MXML_DESCEND_FIRST);
> +	     node !=3D NULL;
> +	     node =3D mxmlFindElement(node, tree, "rule", NULL, NULL,
> +				    MXML_NO_DESCEND)) {
> +		r =3D nft_rule_alloc();
> +		if (r =3D=3D NULL)
> +			goto err_free;
> +
> +		if (nft_mxml_rule_parse(node, r) !=3D 0) {
> +			nft_rule_free(r);
> +			goto err_free;
> +		}
> +
> +		nft_rule_list_add_tail(r, rule_list);
> +	}
> +
> +	if (!nft_rule_list_is_empty(rule_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
> +	else
> +		nft_rule_list_free(rule_list);
> +
> +	return 0;
> +err_free:
> +	nft_rule_list_free(rule_list);
> +	return -1;
> +}
> +
> +static int
> +nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree=
)
> +{
> +	mxml_node_t *node;
> +	struct nft_set *s;
> +	struct nft_set_list *set_list =3D nft_set_list_alloc();
> +	if (set_list =3D=3D NULL) {
> +		errno =3D ENOMEM;
> +		return -1;
> +	}
> +
> +	for (node =3D mxmlFindElement(tree, tree, "set", NULL, NULL,
> +				    MXML_DESCEND_FIRST);
> +	     node !=3D NULL;
> +	     node =3D mxmlFindElement(node, tree, "set", NULL, NULL,
> +				    MXML_NO_DESCEND)) {
> +		s =3D nft_set_alloc();
> +		if (s =3D=3D NULL)
> +			goto err_free;
> +
> +		if (nft_mxml_set_parse(node, s) !=3D 0) {
> +			nft_set_free(s);
> +			goto err_free;
> +		}
> +
> +		nft_set_list_add_tail(s, set_list);
> +	}
> +
> +	if (!nft_set_list_is_empty(set_list))
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
> +	else
> +		nft_set_list_free(set_list);
> +
> +	return 0;
> +err_free:
> +	nft_set_list_free(set_list);
> +	return -1;
> +}
> +#endif
> +
> +static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char =
*xml)
> +{
> +#ifdef XML_PARSING
> +	mxml_node_t *tree;
> +
> +	tree =3D nft_mxml_build_tree(xml, "nftables");
> +	if (tree =3D=3D NULL)
> +		return -1;
> +
> +	if (nft_ruleset_xml_parse_tables(rs, tree) !=3D 0)
> +		goto err;
> +
> +	if (nft_ruleset_xml_parse_chains(rs, tree) !=3D 0)
> +		goto err;
> +
> +	if (nft_ruleset_xml_parse_sets(rs, tree) !=3D 0)
> +		goto err;
> +
> +	if (nft_ruleset_xml_parse_rules(rs, tree) !=3D 0)
> +		goto err;
> +
> +	mxmlDelete(tree);
> +
> +	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST))
> +		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST))
> +		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST))
> +		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST))) {
> +		errno =3D EINVAL;
> +		return -1;
> +	}
> +
> +	return 0;
> +err:
> +	mxmlDelete(tree);
> +	return -1;
> +#else
> +	errno =3D EOPNOTSUPP;
> +	return -1;
> +#endif
> +}
> +
> +int nft_ruleset_parse(struct nft_ruleset *r, enum nft_ruleset_parse_=
type type,
> +		      const char *data)
> +{
> +	int ret;
> +
> +	switch (type) {
> +	case NFT_RULESET_PARSE_XML:
> +		ret =3D nft_ruleset_xml_parse(r, data);
> +		break;
> +	case NFT_RULESET_PARSE_JSON:
> +		ret =3D nft_ruleset_json_parse(r, data);
> +		break;
> +	default:
> +		ret =3D -1;
> +		errno =3D EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(nft_ruleset_parse);
> +
> +static int separator_snprintf(char *buf, size_t size, void *obj, uin=
t32_t type)
> +{
> +	if (obj =3D=3D NULL)
> +		return 0;
> +
> +	if (type =3D=3D NFT_RULESET_O_JSON)
> +		return snprintf(buf, size, ",");
> +
> +	if (type =3D=3D NFT_RULESET_O_DEFAULT)
> +		return snprintf(buf, size, "\n");

Use switch here instead?

> +	return 0;
> +}
> +
> +static int
> +list_separator_snprintf(char *buf, size_t size, void *prev, void *ne=
xt,
> +			uint32_t type)
> +{
> +	if (prev =3D=3D NULL || next =3D=3D NULL)
> +		return 0;
> +
> +	return separator_snprintf(buf, size, prev, type);
> +}
> +
> +static int
> +nft_ruleset_snprintf_table(char *buf, size_t size,
> +			   const struct nft_ruleset *rs, uint32_t type,
> +			   uint32_t flags)
> +{
> +	struct nft_table *t;
> +	struct nft_table_list_iter *ti;
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ti =3D nft_table_list_iter_create(rs->table_list);
> +	if (ti =3D=3D NULL)
> +		return 0;
> +
> +	t =3D nft_table_list_iter_next(ti);
> +	while (t !=3D NULL) {
> +		ret =3D nft_table_snprintf(buf+offset, size, t, type, flags);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +		t =3D nft_table_list_iter_next(ti);
> +		ret =3D separator_snprintf(buf+offset, size, t, type);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	nft_table_list_iter_destroy(ti);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_snprintf_chain(char *buf, size_t size,
> +			   const struct nft_ruleset *rs, uint32_t type,
> +			   uint32_t flags)
> +{
> +	struct nft_chain *c;
> +	struct nft_chain_list_iter *ci;
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ci =3D nft_chain_list_iter_create(rs->chain_list);
> +	if (ci =3D=3D NULL)
> +		return 0;
> +
> +	c =3D nft_chain_list_iter_next(ci);
> +	while (c !=3D NULL) {
> +		ret =3D nft_chain_snprintf(buf+offset, size, c, type, flags);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +		c =3D nft_chain_list_iter_next(ci);
> +		ret =3D separator_snprintf(buf+offset, size, c, type);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	nft_chain_list_iter_destroy(ci);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_snprintf_set(char *buf, size_t size,
> +			 const struct nft_ruleset *rs, uint32_t type,
> +			 uint32_t flags)
> +{
> +	struct nft_set *s;
> +	struct nft_set_list_iter *si;
> +	int ret, len =3D size, offset =3D 0;
> +
> +	si =3D nft_set_list_iter_create(rs->set_list);
> +	if (si =3D=3D NULL)
> +		return 0;
> +
> +	s =3D nft_set_list_iter_next(si);
> +	while (s !=3D NULL) {
> +		ret =3D nft_set_snprintf(buf+offset, size, s, type, flags);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +		s =3D nft_set_list_iter_next(si);
> +		ret =3D separator_snprintf(buf+offset, size, s, type);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	nft_set_list_iter_destroy(si);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_snprintf_rule(char *buf, size_t size,
> +			  const struct nft_ruleset *rs, uint32_t type,
> +			  uint32_t flags)
> +{
> +	struct nft_rule *r;
> +	struct nft_rule_list_iter *ri;
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ri =3D nft_rule_list_iter_create(rs->rule_list);
> +	if (ri =3D=3D NULL)
> +		return 0;
> +
> +	r =3D nft_rule_list_iter_next(ri);
> +	while (r !=3D NULL) {
> +		ret =3D nft_rule_snprintf(buf+offset, size, r, type, flags);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +		r =3D nft_rule_list_iter_next(ri);
> +		ret =3D separator_snprintf(buf+offset, size, r, type);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	nft_rule_list_iter_destroy(ri);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_rul=
eset *rs,
> +			uint32_t type, uint32_t flags)
> +{
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ret =3D nft_ruleset_snprintf_table(buf+offset, size, rs, type, flag=
s);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D list_separator_snprintf(buf+offset, size,
> +				      rs->table_list, rs->chain_list, type);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D nft_ruleset_snprintf_chain(buf+offset, size, rs, type, flag=
s);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D list_separator_snprintf(buf+offset, size,
> +				      rs->chain_list, rs->set_list, type);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D nft_ruleset_snprintf_set(buf+offset, size, rs, type, flags)=
;
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D list_separator_snprintf(buf+offset, size,
> +				      rs->set_list, rs->rule_list, type);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D nft_ruleset_snprintf_rule(buf+offset, size, rs, type, flags=
);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_snprintf_xml(char *buf, size_t size, const struct nft_ru=
leset *rs,
> +			 uint32_t flags)
> +{
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ret =3D snprintf(buf, size, "<nftables>");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D nft_ruleset_do_snprintf(buf+offset, size, rs, NFT_RULESET_O=
_XML,
> +				      flags);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D snprintf(buf+offset, size, "</nftables>");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_ruleset_snprintf_json(char *buf, size_t size, const struct nft_r=
uleset *rs,
> +			  uint32_t flags)
> +{
> +	int ret, len =3D size, offset =3D 0;
> +
> +	ret =3D snprintf(buf, size, "{ \"nftables\": [");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D nft_ruleset_do_snprintf(buf+offset, size, rs, NFT_RULESET_O=
_JSON,
> +				      flags);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret =3D snprintf(buf+offset, size, "]}\n");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	return offset;
> +}
> +
> +int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ru=
leset *r,
> +			 uint32_t type, uint32_t flags)
> +{
> +	switch (type) {
> +	case NFT_RULESET_O_DEFAULT:
> +		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
> +	case NFT_RULESET_O_XML:
> +		return nft_ruleset_snprintf_xml(buf, size, r, flags);
> +	case NFT_RULESET_O_JSON:
> +		return nft_ruleset_snprintf_json(buf, size, r, flags);
> +	default:
> +		break;
> +	}
> +	return -1;
> +}
> +EXPORT_SYMBOL(nft_ruleset_snprintf);
> diff --git a/src/set.c b/src/set.c
> index 530776d..586fae1 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -304,7 +304,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_set *s)
>  EXPORT_SYMBOL(nft_set_nlmsg_parse);
> =20
>  #ifdef JSON_PARSING
> -static int nft_jansson_parse_set(struct nft_set *s, json_t *tree)
> +int nft_jansson_parse_set(struct nft_set *s, json_t *tree)
>  {
>  	json_t *root, *array, *json_elem;
>  	uint32_t uval32;
> diff --git a/src/table.c b/src/table.c
> index c095053..7f14b32 100644
> --- a/src/table.c
> +++ b/src/table.c
> @@ -272,7 +272,7 @@ static int nft_table_xml_parse(struct nft_table *=
t, const char *xml)
>  }
> =20
>  #ifdef JSON_PARSING
> -static int nft_jansson_parse_table(struct nft_table *t, json_t *tree=
)
> +int nft_jansson_parse_table(struct nft_table *t, json_t *tree)
>  {
>  	json_t *root;
>  	uint32_t flags;
> diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-rul=
eset.json
> new file mode 100644
> index 0000000..39b700c
> --- /dev/null
> +++ b/tests/jsonfiles/64-ruleset.json
> @@ -0,0 +1,2 @@
> +{ "nftables": [{"table" : {"name" : "filter","family" : "ip","flags"=
 : 0}},{"table" : {"name" : "filter2","family" : "ip6","flags" : 0}},{ =
"chain": {"name": "input","handle": 1,"bytes": 10681449,"packets": 1621=
6,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum":=
 "input","prio": 0,"policy": "accept"}},{ "chain": {"name": "forward","=
handle": 2,"bytes": 0,"packets": 0,"family": "ip","table": "filter","us=
e": 0,"type": "filter","hooknum": "forward","prio": 0,"policy": "accept=
"}},{ "chain": {"name": "output","handle": 3,"bytes": 2375830,"packets"=
: 15184,"family": "ip","table": "filter","use": 0,"type": "filter","hoo=
knum": "output","prio": 0,"policy": "accept"}},{ "chain": {"name": "cha=
in1","handle": 4,"bytes": 0,"packets": 0,"family": "ip","table": "filte=
r","use": 0}},{ "set": { "name": "set0","table": "filter","flags": 3,"f=
amily": "ip","key_type": 12,"key_len": 2}},{ "rule": { "family" : "ip",=
 "table" : "filter", "chain"  : "output", "handle" : 6,"flags" : 0, "ex=
pr" : [ { "type" : "payload", "dreg" : 1, "offset" : 16, "len" : 4, "ba=
se" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {=
"data_reg": { "type" : "value", "len" : 4, "data0" : "0x0100a8c0"}}}, {=
 "type" : "counter", "pkts" : 0, "bytes" : 0}, { "type" : "immediate", =
"dreg" : 0, "immediatedata" : {"data_reg": {"type" : "verdict", "verdic=
t" : "drop"}}}]}},{ "rule": { "family" : "ip", "table" : "filter", "cha=
in"  : "output", "handle" : 9,"flags" : 0, "expr" : [ { "type" : "paylo=
ad", "dreg" : 1, "offset" : 9, "len" : 1, "base" : "link"}, { "type" : =
"cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "va=
lue", "len" : 1, "data0" : "0x00000006"}}}, { "type" : "payload", "dreg=
" : 1, "offset" : 2, "len" : 2, "base" : "link"}, { "type" : "cmp", "sr=
eg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len=
" : 2, "data0" : "0x00001600"}}}, { "type" : "counter", "pkts" : 0, "by=
tes" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", "chain"  =
: "output", "handle" : 10,"flags" : 0, "expr" : [ { "type" : "payload",=
 "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cm=
p", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value=
", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" :=
 0, "bytes" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", "c=
hain"  : "output", "handle" : 11,"flags" : 0, "expr" : [ { "type" : "pa=
yload", "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type=
" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" :=
 "value", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "=
pkts" : 0, "bytes" : 0}, { "type" : "immediate", "dreg" : 0, "immediate=
data" : {"data_reg": {"type" : "verdict", "verdict" : "drop"}}}]}},{ "r=
ule": { "family" : "ip", "table" : "filter", "chain"  : "output", "hand=
le" : 13,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "off=
set" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "o=
p" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1, "dat=
a0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" : 2, =
"len" : 2, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq",=
 "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x0=
0001600"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}]}
> +
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index ecde0e2..bf95205 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -6,6 +6,7 @@
>  #include <errno.h>
> =20
>  #include <libmnl/libmnl.h> /*nlmsghdr*/
> +#include <libnftables/ruleset.h>
>  #include <libnftables/table.h>
>  #include <libnftables/chain.h>
>  #include <libnftables/rule.h>
> @@ -24,10 +25,12 @@ enum {
>  	TEST_XML_CHAIN,
>  	TEST_XML_RULE,
>  	TEST_XML_SET,
> +	TEST_XML_RULESET,
>  	TEST_JSON_TABLE,
>  	TEST_JSON_CHAIN,
>  	TEST_JSON_RULE,
>  	TEST_JSON_SET,
> +	TEST_JSON_RULESET,
>  };
> =20
>  #if defined(XML_PARSING) || defined(JSON_PARSING)
> @@ -76,6 +79,7 @@ static int compare_test(uint32_t type, void *input,=
 const char *filename)
>  	struct nft_chain *c =3D NULL;
>  	struct nft_rule *r =3D NULL;
>  	struct nft_set *s =3D NULL;
> +	struct nft_ruleset *rs =3D NULL;
>  	char orig[4096];
>  	char out[4096];
>  	FILE *fp;
> @@ -97,6 +101,10 @@ static int compare_test(uint32_t type, void *inpu=
t, const char *filename)
>  	case TEST_JSON_SET:
>  		s =3D (struct nft_set *)input;
>  		break;
> +	case TEST_XML_RULESET:
> +	case TEST_JSON_RULESET:
> +		rs =3D (struct nft_ruleset *)input;
> +		break;
>  	default:
>  		errno =3D EINVAL;
>  		return -1;
> @@ -127,6 +135,14 @@ static int compare_test(uint32_t type, void *inp=
ut, const char *filename)
>  	case TEST_JSON_SET:
>  		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_JSON, 0);
>  		break;
> +	case TEST_XML_RULESET:
> +		nft_ruleset_snprintf(out, sizeof(out), rs,
> +				     NFT_RULESET_O_XML, 0);
> +		break;
> +	case TEST_JSON_RULESET:
> +		nft_ruleset_snprintf(out, sizeof(out), rs,
> +				     NFT_RULESET_O_JSON, 0);
> +		break;
>  	default:
>  		errno =3D EINVAL;
>  		return -1;
> @@ -159,6 +175,7 @@ static int test_json(const char *filename)
>  	struct nft_chain *c;
>  	struct nft_rule *r;
>  	struct nft_set *s;
> +	struct nft_ruleset *rs;
>  	json_t *root;
>  	json_error_t error;
>  	char *json;
> @@ -211,6 +228,16 @@ static int test_json(const char *filename)
> =20
>  			nft_set_free(s);
>  			}
> +	} else if (json_object_get(root, "nftables") !=3D NULL) {
> +		rs =3D nft_ruleset_alloc();
> +		if (rs !=3D NULL) {
> +			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_JSON, json) =3D=3D 0)
> +				ret =3D compare_test(TEST_JSON_RULESET, rs, filename);
> +			else
> +				goto failparsing;
> +
> +			nft_ruleset_free(rs);
> +			}
>  	}
> =20
>  	free(json);
> @@ -237,6 +264,7 @@ static int test_xml(const char *filename)
>  	struct nft_chain *c;
>  	struct nft_rule *r;
>  	struct nft_set *s;
> +	struct nft_ruleset *rs;
>  	FILE *fp;
>  	mxml_node_t *tree;
>  	char *xml;
> @@ -293,6 +321,18 @@ static int test_xml(const char *filename)
> =20
>  			nft_set_free(s);
>  		}
> +	} else if (strcmp(tree->value.opaque, "nftables") =3D=3D 0) {
> +		rs =3D nft_ruleset_alloc();
> +		if (rs !=3D NULL) {
> +			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_XML,
> +					      xml) =3D=3D 0)
> +				ret =3D compare_test(TEST_XML_RULESET, rs,
> +						   filename);
> +			else
> +				goto failparsing;
> +
> +			nft_ruleset_free(rs);
> +		}
>  	}
> =20
>  	return ret;
> diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-rulese=
t.xml
> new file mode 100644
> index 0000000..21bb9be
> --- /dev/null
> +++ b/tests/xmlfiles/75-ruleset.xml
> @@ -0,0 +1 @@
> +<nftables><table><name>filter</name><family>ip</family><flags>0</fla=
gs></table><table><name>nat</name><family>ip</family><flags>0</flags></=
table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packe=
ts>0</packets><table>filter</table><family>ip</family></chain><chain><n=
ame>pre</name><handle>1</handle><bytes>0</bytes><packets>0</packets><ta=
ble>nat</table><family>ip</family></chain><set><family>ip</family><tabl=
e>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type=
><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set=
_elem><flags>0</flags><key><data_reg type=3D"value"><len>2</len><data0>=
0x000001bb</data0></data_reg></key></set_elem><set_elem><flags>0</flags=
><key><data_reg type=3D"value"><len>2</len><data0>0x00000019</data0></d=
ata_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type=3D=
"value"><len>2</len><data0>0x00000016</data0></data_reg></key></set_ele=
m></set><set><family>ip</family><table>nat</table><name>set0</name><fla=
gs
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
