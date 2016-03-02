From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 v2] libnftnl: Implement new buffer of TLV objects.
Date: Wed, 2 Mar 2016 19:32:07 +0100
Message-ID: <20160302183207.GA1351@salvia>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37311 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbcCBScT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 13:32:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 08F07A7E7E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 19:32:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E4D9F11540D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 19:32:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0D171203FA
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 19:32:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 29, 2016 at 05:25:38PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> These functions allow to create a buffer (nftnl_attrbuf) of TLV objec=
ts
> (nftnl_attr). It is inspired by libmnl/src/attr.c. It can be used to =
store
> several variable length user data into an object.
>=20
> Example usage:
> 	```
> 	struct nftnl_attrbuf *attrbuf;
> 	struct nftnl_attr *attr;
> 	const char str[] =3D "Hello World!";
>=20
> 	attrbuf =3D nftnl_attrbuf_alloc(ATTRBUF_SIZE);
> 	if (!nftnl_attr_put_check(attrbuf, NFTNL_ATTR_TYPE_COMMENT,
> 				  strlen(str), str)
> 	) {

Please, mind your coding style.

    if (!nftnl_attr_put(attrbuf, NFTNL_ATTR_TYPE_COMMENT, strlen(str), =
str) {

BTW, NFTNL_ATTR_TYPE_COMMENT doesn't exist in this tree.

> 		fprintf(stderr, "Can't put attribute \"%s\"", str);

On this snippet, on error you should:

                perror("Can't put attribute \"%s\"", str);
                exit(EXIT_FAILURE);

> 	}
>=20
> 	nftnl_attr_for_each(attr, attrbuf) {
> 		printf("%s\n", (char *)nftnl_attr_get_value(attr));
> 	}
>=20
> 	nftnl_attr_free(attrbuf);
> 	```
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/Makefile.am          |   1 +
>  include/attr.h               |  40 +++++++++++++
>  include/libnftnl/Makefile.am |   1 +
>  include/libnftnl/attr.h      |  53 +++++++++++++++++
>  src/Makefile.am              |   1 +
>  src/attr.c                   | 132 +++++++++++++++++++++++++++++++++=
++++++++++
>  src/libnftnl.map             |  16 ++++++
>  7 files changed, 244 insertions(+)
>  create mode 100644 include/attr.h
>  create mode 100644 include/libnftnl/attr.h
>  create mode 100644 src/attr.c
>=20
> diff --git a/include/Makefile.am b/include/Makefile.am
> index be9eb9b..785ec15 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -12,4 +12,5 @@ noinst_HEADERS =3D internal.h	\
>  		 expr.h		\
>  		 json.h		\
>  		 set_elem.h	\
> +		 attr.h		\
>  		 utils.h
> diff --git a/include/attr.h b/include/attr.h
> new file mode 100644
> index 0000000..2a29fa0
> --- /dev/null
> +++ b/include/attr.h
> @@ -0,0 +1,40 @@
> +#ifndef _LIBNFTNL_ATTR_INTERNAL_H_
> +#define _LIBNFTNL_ATTR_INTERNAL_H_
> +
> +#include <stdint.h>
> +#include <stddef.h>
> +
> +/*
> + * TLV structures:
> + * nftnl_attr
> + *  <-------- HEADER --------> <------ PAYLOAD ------>
> + * +------------+-------------+- - - - - - - - - - - -+
> + * |    type    |     len     |         value         |
> + * |  (1 byte)  |   (1 byte)  |                       |
> + * +--------------------------+- - - - - - - - - - - -+
> + *  <-- sizeof(nftnl_attr) --> <-- nftnl_attr->len -->
> + */
> +struct __attribute__((__packed__)) nftnl_attr {
> +	uint8_t type;
> +	uint8_t len;
> +	unsigned char value[];
> +};

struct nftnl_attr {
      ...
} __attribute__((__packed__));

> +/*
> + *              +-------------------------------------------++
> + *              |           data[]                          ||
> + *              |             ||                            ||
> + *              |             \/                            \/
> + *  +-------+-------+- - - - -+-------+-------+ ... +-------+- - - -=
 - - -+
> + *  | size  |  end  | padding |  TLV  |  TLV  |     |  TLV  |    Emp=
ty    |
> + *  +-------+-------+- - - - -+-------+-------+ ... +-------+- - - -=
 - - -+
> + *                            |<- nftnl_attrbuf_get_len() ->|
> + *                            |<-------- nftnl_attrbuf_get_size() --=
----->|
> + */
> +struct nftnl_attrbuf {
> +	size_t size;
> +	char  *end;
> +	char   data[] __attribute__((aligned(64)));

No need for this aligned for a control structure.

> +};
> +
> +#endif
> diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile=
=2Eam
> index 84f01b6..a3a6fb3 100644
> --- a/include/libnftnl/Makefile.am
> +++ b/include/libnftnl/Makefile.am
> @@ -7,4 +7,5 @@ pkginclude_HEADERS =3D batch.h		\
>  		     set.h		\
>  		     ruleset.h		\
>  		     common.h		\
> +		     attr.h		\
>  		     gen.h
> diff --git a/include/libnftnl/attr.h b/include/libnftnl/attr.h
> new file mode 100644
> index 0000000..cc3689e
> --- /dev/null
> +++ b/include/libnftnl/attr.h
> @@ -0,0 +1,53 @@
> +#ifndef _LIBNFTNL_ATTR_H_
> +#define _LIBNFTNL_ATTR_H_
> +
> +#include <stdio.h>
> +#include <stdint.h>
> +
> +/*
> + * nftnl attributes API
> + */
> +struct nftnl_attr;

Could you rename this to:

        struct nftnl_udata;

since this will be used for rule and set udata areas.

> +struct nftnl_attrbuf;

struct nftnl_udata_buf;

> +/* nftnl_attrbuf */
> +struct nftnl_attrbuf *nftnl_attrbuf_alloc(size_t data_size);
> +void nftnl_attrbuf_free(struct nftnl_attrbuf *attrbuf);
> +size_t nftnl_attrbuf_get_len(const struct nftnl_attrbuf *attrbuf);
> +size_t nftnl_attrbuf_get_size(const struct nftnl_attrbuf *attrbuf);
> +void *nftnl_attrbuf_get_data(const struct nftnl_attrbuf *attrbuf);
> +void nftnl_attrbuf_copy_data(struct nftnl_attrbuf *attrbuf,
> +			     const void *data, size_t len);
> +struct nftnl_attr *nftnl_attrbuf_get_start(const struct nftnl_attrbu=
f *attrbuf);
> +struct nftnl_attr *nftnl_attrbuf_get_end(const struct nftnl_attrbuf =
*attrbuf);
> +
> +/* TLV attribute getters */
> +uint8_t nftnl_attr_get_type(const struct nftnl_attr *attr);
> +uint8_t nftnl_attr_get_len(const struct nftnl_attr *attr);
> +void *nftnl_attr_get_value(const struct nftnl_attr *attr);
> +
> +/* TLV attribute putters */
> +struct nftnl_attr *nftnl_attr_put(struct nftnl_attrbuf *attrbuf,
> +				  uint8_t type, uint8_t len, const void *value);

Please, remove tis nftnl_attr_put() and rename nftnl_attr_put_check to
become nftnl_attr_put().

> +struct nftnl_attr *nftnl_attr_put_check(struct nftnl_attrbuf *attrbu=
f,
> +					uint8_t type, size_t len,
> +					const void *value);
> +
> +/* TLV iterators */
> +struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr);
> +
> +#define nftnl_attr_for_each(attr, attrbuf)                          =
    \
> +	for ((attr) =3D nftnl_attrbuf_get_start(attrbuf);                 \
> +	     (char *)(nftnl_attrbuf_get_end(attrbuf)) > (char *)(attr); \
> +	     (attr) =3D nftnl_attr_next(attr))
> +
> +/* TLV callback-based attribute parsers */
> +#define NFTNL_CB_ERROR	-1
> +#define NFTNL_CB_STOP	 0
> +#define NFTNL_CB_OK	 1
> +
> +typedef int (*nftnl_attr_cb_t)(const struct nftnl_attr *attr, void *=
data);
> +int nftnl_attr_parse(const struct nftnl_attrbuf *attrbuf, nftnl_attr=
_cb_t cb,
> +		     void *data);
> +
> +#endif /* _LIBNFTNL_ATTR_H_ */
> diff --git a/src/Makefile.am b/src/Makefile.am
> index a27e292..621dd69 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -19,6 +19,7 @@ libnftnl_la_SOURCES =3D utils.c		\
>  		      ruleset.c		\
>  		      mxml.c		\
>  		      jansson.c		\
> +		      attr.c		\
>  		      expr.c		\
>  		      expr_ops.c	\
>  		      expr/bitwise.c	\
> diff --git a/src/attr.c b/src/attr.c
> new file mode 100644
> index 0000000..82c63aa
> --- /dev/null
> +++ b/src/attr.c
> @@ -0,0 +1,132 @@
> +#include <libnftnl/attr.h>
> +#include <attr.h>
> +#include <utils.h>
> +
> +#include <stdlib.h>
> +#include <stdint.h>
> +
> +
> +struct nftnl_attrbuf *nftnl_attrbuf_alloc(size_t data_size)
> +{
> +	struct nftnl_attrbuf *attrbuf;
> +
> +	attrbuf =3D (struct nftnl_attrbuf *)
> +		malloc(sizeof(struct nftnl_attrbuf) + data_size);
> +	attrbuf->size =3D data_size;
> +	attrbuf->end =3D attrbuf->data;
> +
> +	return attrbuf;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_alloc);
> +
> +void nftnl_attrbuf_free(struct nftnl_attrbuf *attrbuf)
> +{
> +	attrbuf->size =3D 0;
> +	attrbuf->end =3D NULL;
> +	free((void *)attrbuf);
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_free);
> +
> +size_t nftnl_attrbuf_get_len(const struct nftnl_attrbuf *attrbuf)
> +{
> +	return (size_t)(attrbuf->end - attrbuf->data);
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_get_len);
> +
> +size_t nftnl_attrbuf_get_size(const struct nftnl_attrbuf *attrbuf)
> +{
> +	return attrbuf->size;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_get_size);
> +
> +struct nftnl_attr *nftnl_attrbuf_get_start(const struct nftnl_attrbu=
f *attrbuf)
> +{
> +	return (struct nftnl_attr *)attrbuf->data;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_get_start);
> +
> +struct nftnl_attr *nftnl_attrbuf_get_end(const struct nftnl_attrbuf =
*attrbuf)
> +{
> +	return (struct nftnl_attr *)attrbuf->end;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_get_end);
> +
> +void *nftnl_attrbuf_get_data(const struct nftnl_attrbuf *attrbuf)
> +{
> +	return (void *)attrbuf->data;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_get_data);
> +
> +void nftnl_attrbuf_copy_data(struct nftnl_attrbuf *attrbuf,
> +			    const void *data, size_t len)
> +{
> +	memcpy(attrbuf->data, data, len <=3D attrbuf->size ? len : attrbuf-=
>size);
> +	attrbuf->end =3D attrbuf->data + len;
> +}
> +EXPORT_SYMBOL(nftnl_attrbuf_copy_data);
> +
> +uint8_t nftnl_attr_get_type(const struct nftnl_attr *attr)
> +{
> +	return attr->type;
> +}
> +EXPORT_SYMBOL(nftnl_attr_get_type);
> +
> +uint8_t nftnl_attr_get_len(const struct nftnl_attr *attr)
> +{
> +	return attr->len;
> +}
> +EXPORT_SYMBOL(nftnl_attr_get_len);
> +
> +void *nftnl_attr_get_value(const struct nftnl_attr *attr)
> +{
> +	return (void *)attr->value;
> +}
> +EXPORT_SYMBOL(nftnl_attr_get_value);
> +
> +struct nftnl_attr *nftnl_attr_put(struct nftnl_attrbuf *attrbuf,
> +				  uint8_t type, uint8_t len, const void *value)
> +{
> +	struct nftnl_attr *attr =3D (struct nftnl_attr *)attrbuf->end;
> +
> +	attr->len  =3D len;
> +	attr->type =3D type;
> +	memcpy(attr->value, value, len);
> +
> +	attrbuf->end =3D (char *)nftnl_attr_next(attr);
> +
> +	return attr;
> +}
> +EXPORT_SYMBOL(nftnl_attr_put);
> +
> +struct nftnl_attr *nftnl_attr_put_check(struct nftnl_attrbuf *attrbu=
f,
> +					uint8_t type, size_t len,
> +					const void *value)
> +{
> +	/* Check if there is enough space */
> +	if (attrbuf->size < len + sizeof(struct nftnl_attr))
> +		return NULL;
> +
> +	return nftnl_attr_put(attrbuf, type, len, value);
> +}
> +EXPORT_SYMBOL(nftnl_attr_put_check);
> +
> +struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr)
> +{
> +	return (struct nftnl_attr *)&attr->value[attr->len];
> +}
> +EXPORT_SYMBOL(nftnl_attr_next);
> +
> +int nftnl_attr_parse(const struct nftnl_attrbuf *attrbuf, nftnl_attr=
_cb_t cb,
> +		     void *data)
> +{
> +	int ret =3D NFTNL_CB_OK;
> +	const struct nftnl_attr *attr;
> +
> +	nftnl_attr_for_each(attr, attrbuf) {
> +		ret =3D cb(attr, data);
> +		if (ret <=3D NFTNL_CB_STOP)
> +			return ret;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(nftnl_attr_parse);
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index 2e193b7..65bd37e 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -336,6 +336,22 @@ global:
>    nftnl_set_snprintf;
>    nftnl_set_fprintf;
> =20
> +  nftnl_attrbuf_alloc;
> +  nftnl_attrbuf_free;
> +  nftnl_attrbuf_get_len;
> +  nftnl_attrbuf_get_size;
> +  nftnl_attrbuf_get_data;
> +  nftnl_attrbuf_copy_data;
> +  nftnl_attrbuf_get_start;
> +  nftnl_attrbuf_get_end;
> +  nftnl_attr_get_type;
> +  nftnl_attr_get_len;
> +  nftnl_attr_get_value;
> +  nftnl_attr_put;
> +  nftnl_attr_put_check;
> +  nftnl_attr_next;
> +  nftnl_attr_parse;

Are you sure we need to export all these? Please only export those
functions that we really need at this stage for nft.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
