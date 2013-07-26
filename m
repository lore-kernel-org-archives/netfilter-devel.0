From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] set: XML parse
Date: Fri, 26 Jul 2013 12:35:01 +0200
Message-ID: <20130726103501.GA4397@localhost>
References: <20130726094451.951.8098.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56980 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573Ab3GZKfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:35:10 -0400
Content-Disposition: inline
In-Reply-To: <20130726094451.951.8098.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 26, 2013 at 11:47:09AM +0200, Arturo Borrero Gonzalez wrote=
:
> Sets are now parsed, following this previous snprintf pattern:
>=20
> <set name=3D"xx" table=3D"xx" version=3D"xx">
> 	<set_flags>uint32_t</set_flags>
> 	<key_type>uint32_t</key_type>
> 	<key_len>size_t</key_len>
> 	<data_type>uint32_t</data_type>
> 	<data_len>size_t</data_len>
> 	<set_elem>
> 		<set_elem_flags>uint32_t</set_elem_flags>
> 		<set_elem_key>
> 			<data_reg type=3D"value">
> 				<len></len>
> 				<dataN></dataN>
> 			</data_reg>
> 		</set_elem_key>
> 		<set_elem_data>
> 			<data_reg type=3D"xx">
> 				[...]
> 			</data_reg>
> 		</set_elem_data>
> 	</set_elem>
> </set>
>=20
>=20
> Signed-off-by: Arturo Borrero Gonz=E1lez <arturo.borrero.glez@gmail.c=
om>
> ---
> v1: initial version.
> v2: - let helper version set errno.
>     - Move set_elem parsing to a helper function.
>     - <set_elem_data> is now optional.
>     - realistic testsfiles, also with IPv6 data.
>=20
>  tests/nft-parsing-test.c  |   10 ++++++++++
>  tests/xmlfiles/73-set.xml |   36 +++++++++++++++++++++++++++++++++++=
+
>  tests/xmlfiles/74-set.xml |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+)
>  create mode 100644 tests/xmlfiles/73-set.xml
>  create mode 100644 tests/xmlfiles/74-set.xml
>=20
> diff --git a/include/libnftables/set.h b/include/libnftables/set.h
> index 6023d50..4fc3a8d 100644
> --- a/include/libnftables/set.h
> +++ b/include/libnftables/set.h
> @@ -52,6 +52,14 @@ struct nft_set *nft_set_list_iter_cur(struct nft_s=
et_list_iter *iter);
>  struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *ite=
r);
>  void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
> =20
> +enum nft_set_parse_type {
> +	NFT_SET_PARSE_NONE	=3D 0,
> +	NFT_SET_PARSE_XML,
> +	NFT_SET_PARSE_MAX,
> +};
> +
> +int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, c=
har *data);
> +
>  /*
>   * Set elements
>   */
> @@ -94,6 +102,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsg=
hdr *nlh, struct nft_set_elem
> =20
>  int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_=
set_elem *s);
> =20
> +int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_ty=
pe type, char *data);
>  int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_ele=
m *s, uint32_t type, uint32_t flags);
> =20
>  int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set=
_elem *e, void *data), void *data);
> diff --git a/src/internal.h b/src/internal.h
> index 47cd635..1970c9c 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -36,6 +36,7 @@ union nft_data_reg;
>  int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name=
, union nft_data_reg *data_reg);
>  int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, uin=
t32_t mxml_flags, int base, void *number, enum nft_type type);
>  const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_n=
ame, uint32_t mxml_flags);
> +struct nft_set_elem *nft_mxml_set_elem_parse(mxml_node_t *node);
>  #endif
> =20
>  #ifdef JSON_PARSING
> diff --git a/src/libnftables.map b/src/libnftables.map
> index f2084d9..614c705 100644
> --- a/src/libnftables.map
> +++ b/src/libnftables.map
> @@ -120,6 +120,7 @@ global:
>    nft_set_nlmsg_build_hdr;
>    nft_set_nlmsg_build_payload;
>    nft_set_nlmsg_parse;
> +  nft_set_parse;
>    nft_set_snprintf;
> =20
>    nft_set_list_alloc;
> @@ -149,6 +150,7 @@ global:
>    nft_set_elem_nlmsg_build_hdr;
>    nft_set_elem_nlmsg_build_payload;
>    nft_set_elem_nlmsg_parse;
> +  nft_set_elem_parse;
>    nft_set_elem_snprintf;
> =20
>    nft_set_elems_nlmsg_build_payload;
> diff --git a/src/mxml.c b/src/mxml.c
> index f812bf6..84514da 100644
> --- a/src/mxml.c
> +++ b/src/mxml.c
> @@ -17,6 +17,7 @@
>  #include <linux/netfilter/nf_tables.h>
>  #include <libnftables/rule.h>
>  #include <libnftables/expr.h>
> +#include <libnftables/set.h>
> =20
>  #ifdef XML_PARSING
>  struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node)
> @@ -165,4 +166,49 @@ const char *nft_mxml_str_parse(mxml_node_t *tree=
, const char *node_name,
>  	return strdup(node->child->value.opaque);
>  }
> =20
> +struct nft_set_elem *nft_mxml_set_elem_parse(mxml_node_t *node)
> +{
> +	mxml_node_t *save;
> +	char *set_elem_str;
> +	struct nft_set_elem *elem;
> +
> +	if (node =3D=3D NULL)
> +		goto einval;
> +
> +	if (strcmp(node->value.opaque, "set_elem") !=3D 0)
> +		goto einval;
> +
> +	elem =3D nft_set_elem_alloc();
> +	if (elem =3D=3D NULL)
> +		goto enomem;
> +
> +	/* This is a hack for mxml to print just the current node */
> +	save =3D node->next;
> +	node->next =3D NULL;
> +
> +	set_elem_str =3D mxmlSaveAllocString(node, MXML_NO_CALLBACK);
> +	node->next =3D save;
> +
> +	if (set_elem_str =3D=3D NULL) {
> +		free(elem);
> +		goto enomem;
> +	}
> +
> +	if (nft_set_elem_parse(elem, NFT_SET_PARSE_XML,
> +			       set_elem_str) !=3D 0) {
> +		free(set_elem_str);
> +		free(elem);
> +		return NULL;
> +	}
> +
> +	free(set_elem_str);
> +
> +	return elem;
> +einval:
> +	errno =3D EINVAL;
> +	return NULL;
> +enomem:
> +	errno =3D ENOMEM;
> +	return NULL;
> +}
>  #endif
> diff --git a/src/set.c b/src/set.c
> index ef15527..891bd08 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -16,6 +16,8 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <netinet/in.h>
> +#include <limits.h>
> +#include <errno.h>
> =20
>  #include <libmnl/libmnl.h>
>  #include <linux/netfilter/nfnetlink.h>
> @@ -301,6 +303,141 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nft_set *s)
>  }
>  EXPORT_SYMBOL(nft_set_nlmsg_parse);
> =20
> +static int nft_set_xml_parse(struct nft_set *s, char *xml)
> +{
> +#ifdef XML_PARSING
> +	mxml_node_t *tree;
> +	mxml_node_t *node =3D NULL;
> +	struct nft_set_elem *elem;
> +	int version;
> +	int family;
> +	char *family_str;
> +
> +	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
> +	if (tree =3D=3D NULL) {
> +		errno =3D EINVAL;
> +		return -1;
> +	}
> +
> +	if (strcmp(tree->value.opaque, "set") !=3D 0)
> +		goto err;
> +
> +	if (mxmlElementGetAttr(tree, "version") =3D=3D NULL)
> +		goto err;
> +
> +	if (nft_strtoi(mxmlElementGetAttr(tree, "version"), 10, &version,
> +		       NFT_TYPE_U64) !=3D 0)

I noticed that we cannot use nft_mxml_num_parse here because it's an
attribute.

My proposal is:

1) make patch to convert XML attributes to XML nodes in sets.
2) make a patch to add the XML parsing for sets, now using the existing
   helper functions that we have.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
