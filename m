From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 v4] libnftnl: Implement new buffer of TLV objects
Date: Sat, 12 Mar 2016 12:09:47 +0100
Message-ID: <20160312110947.GA1764@salvia>
References: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45506 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbcCLLJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 06:09:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7CECE4B9E5
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6CFCCDA8F8
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E93CADA8F8
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:09:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Carlos,

Almost there, just a bit more small incremental changes.

On Thu, Mar 10, 2016 at 10:37:13PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> These functions allow to create a buffer (nftnl_udata_buf) of TLV obj=
ects
> (nftnl_udata). It is inspired by libmnl/src/attr.c. It can be used to=
 store
> several variable length user data into an object.
>=20
> Example usage:
> 	```
> 	struct nftnl_udata_buf *buf;
> 	struct nftnl_udata *attr;
> 	const char str[] =3D "Hello World!";
>=20
> 	buf =3D nftnl_udata_alloc(UDATA_SIZE);
> 	if (!buf) {
> 		perror("OOM");
> 		exit(EXIT_FAILURE);
> 	}
>=20
> 	if (!nftnl_udata_put_strz(buf, MY_TYPE, str)) {
> 		perror("Can't put attribute \"%s\"", str);
> 		exit(EXIT_FAILURE);
> 	}
>=20
> 	nftnl_udata_for_each(buf, attr) {
> 		printf("%s\n", (char *)nftnl_udata_attr_value(attr));
> 	}
>=20
> 	nftnl_udata_free(buf);
> 	```
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/Makefile.am          |   1 +
>  include/libnftnl/Makefile.am |   1 +
>  include/libnftnl/udata.h     |  48 ++++++++++++++++
>  include/udata.h              |  40 +++++++++++++
>  src/Makefile.am              |   1 +
>  src/libnftnl.map             |  16 ++++++
>  src/udata.c                  | 134 +++++++++++++++++++++++++++++++++=
++++++++++
>  7 files changed, 241 insertions(+)
>  create mode 100644 include/libnftnl/udata.h
>  create mode 100644 include/udata.h
>  create mode 100644 src/udata.c
>=20
> diff --git a/include/Makefile.am b/include/Makefile.am
> index be9eb9b..9f55737 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -12,4 +12,5 @@ noinst_HEADERS =3D internal.h	\
>  		 expr.h		\
>  		 json.h		\
>  		 set_elem.h	\
> +		 udata.h	\
>  		 utils.h
> diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile=
=2Eam
> index 84f01b6..457ec95 100644
> --- a/include/libnftnl/Makefile.am
> +++ b/include/libnftnl/Makefile.am
> @@ -7,4 +7,5 @@ pkginclude_HEADERS =3D batch.h		\
>  		     set.h		\
>  		     ruleset.h		\
>  		     common.h		\
> +		     udata.h		\
>  		     gen.h
> diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
> new file mode 100644
> index 0000000..a74e54c
> --- /dev/null
> +++ b/include/libnftnl/udata.h
> @@ -0,0 +1,48 @@
> +#ifndef _LIBNFTNL_UDATA_H_
> +#define _LIBNFTNL_UDATA_H_
> +
> +#include <stdio.h>
> +#include <stdint.h>
> +
> +/*
> + * nftnl user data attributes API
> + */
> +struct nftnl_udata;
> +struct nftnl_udata_buf;
> +
> +/* nftnl_udata_buf */
> +struct nftnl_udata_buf *nftnl_udata_alloc(size_t data_size);
> +void nftnl_udata_free(struct nftnl_udata_buf *buf);
> +size_t nftnl_udata_len(const struct nftnl_udata_buf *buf);
> +size_t nftnl_udata_size(const struct nftnl_udata_buf *buf);
> +void *nftnl_udata_data(const struct nftnl_udata_buf *buf);
> +void nftnl_udata_copy_data(struct nftnl_udata_buf *buf, const void *=
data,
> +			   size_t len);
> +struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *=
buf);
> +struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *bu=
f);
> +
> +/* putters */
> +struct nftnl_udata *nftnl_udata_put(struct nftnl_udata_buf *buf, uin=
t8_t type,
> +				    size_t len, const void *value);
> +struct nftnl_udata *nftnl_udata_put_strz(struct nftnl_udata_buf *buf=
,
> +					 uint8_t type, const char *strz);
> +
> +/* nftnl_udata_attr */
> +uint8_t nftnl_udata_attr_type(const struct nftnl_udata *attr);
> +uint8_t nftnl_udata_attr_len(const struct nftnl_udata *attr);
> +void *nftnl_udata_attr_value(const struct nftnl_udata *attr);
> +
> +/* iterator */
> +struct nftnl_udata *nftnl_udata_attr_next(const struct nftnl_udata *=
attr);
> +
> +#define nftnl_udata_for_each(buf, attr)                       \
> +	for ((attr) =3D nftnl_udata_start(buf);                 \
> +	     (char *)(nftnl_udata_end(buf)) > (char *)(attr); \
> +	     (attr) =3D nftnl_udata_attr_next(attr))
> +
> +typedef int (*nftnl_udata_cb_t)(const struct nftnl_udata *attr,
> +				void *data);
> +int nftnl_udata_parse(const struct nftnl_udata_buf *buf, nftnl_udata=
_cb_t cb,
> +		      void *data);
> +
> +#endif /* _LIBNFTNL_UDATA_H_ */
> diff --git a/include/udata.h b/include/udata.h
> new file mode 100644
> index 0000000..271ee50
> --- /dev/null
> +++ b/include/udata.h
> @@ -0,0 +1,40 @@
> +#ifndef _LIBNFTNL_UDATA_INTERNAL_H_
> +#define _LIBNFTNL_UDATA_INTERNAL_H_
> +
> +#include <stdint.h>
> +#include <stddef.h>
> +
> +/*
> + * TLV structures:
> + * nftnl_udata
> + *  <-------- HEADER --------> <------ PAYLOAD ------>
> + * +------------+-------------+- - - - - - - - - - - -+
> + * |    type    |     len     |         value         |
> + * |  (1 byte)  |   (1 byte)  |                       |
> + * +--------------------------+- - - - - - - - - - - -+
> + *  <-- sizeof(nftnl_udata) -> <-- nftnl_udata->len -->
> + */
> +struct nftnl_udata {
> +	uint8_t type;
> +	uint8_t len;
> +	unsigned char value[];
> +} __attribute__((__packed__));
> +
> +/*
> + *              +---------------------------------++
> + *              | data[]                          ||
> + *              |   ||                            ||
> + *              |   \/                            \/
> + *  +-------+-------+-------+-------+ ... +-------+- - - - - - -+
> + *  | size  |  end  |  TLV  |  TLV  |     |  TLV  |    Empty    |
> + *  +-------+-------+-------+-------+ ... +-------+- - - - - - -+
> + *                  |<---- nftnl_udata_len() ---->|
> + *                  |<----------- nftnl_udata_size() ---------->|
> + */
> +struct nftnl_udata_buf {
> +	size_t size;
> +	char  *end;
> +	char   data[];
> +};
> +
> +#endif /* _LIBNFTNL_UDATA_INTERNAL_H_ */
> diff --git a/src/Makefile.am b/src/Makefile.am
> index a27e292..7e580e4 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -19,6 +19,7 @@ libnftnl_la_SOURCES =3D utils.c		\
>  		      ruleset.c		\
>  		      mxml.c		\
>  		      jansson.c		\
> +		      udata.c		\
>  		      expr.c		\
>  		      expr_ops.c	\
>  		      expr/bitwise.c	\
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index 2e193b7..d6cd2a7 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -336,6 +336,22 @@ global:
>    nftnl_set_snprintf;
>    nftnl_set_fprintf;
> =20
> +  nftnl_udata_alloc;
> +  nftnl_udata_free;
> +  nftnl_udata_len;
> +  nftnl_udata_size;
> +  nftnl_udata_data;
> +  nftnl_udata_copy_data;
> +  nftnl_udata_start;
> +  nftnl_udata_end;
> +  nftnl_udata_put;
> +  nftnl_udata_put_strz;
> +  nftnl_udata_attr_type;
> +  nftnl_udata_attr_len;
> +  nftnl_udata_attr_value;
> +  nftnl_udata_attr_next;
> +  nftnl_udata_parse;

Please, add these new symbols to LIBNFTNL_4.1.

>    nftnl_set_list_alloc;
>    nftnl_set_list_free;
>    nftnl_set_list_add;
> diff --git a/src/udata.c b/src/udata.c
> new file mode 100644
> index 0000000..0503ca3
> --- /dev/null
> +++ b/src/udata.c
> @@ -0,0 +1,134 @@
> +#include <libnftnl/udata.h>
> +#include <udata.h>
> +#include <utils.h>
> +
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +
> +struct nftnl_udata_buf *nftnl_udata_alloc(size_t data_size)
> +{
> +	struct nftnl_udata_buf *buf;
> +
> +	buf =3D (struct nftnl_udata_buf *)
> +		malloc(sizeof(struct nftnl_udata_buf) + data_size);

No need for casting, ie.

	buf =3D malloc(sizeof(struct nftnl_udata_buf) + data_size);

> +	if (!buf)
> +		return NULL;
> +	buf->size =3D data_size;
> +	buf->end =3D buf->data;
> +
> +	return buf;
> +}
> +EXPORT_SYMBOL(nftnl_udata_alloc);
> +
> +void nftnl_udata_free(struct nftnl_udata_buf *buf)
> +{
> +	buf->size =3D 0;
> +	buf->end =3D NULL;
> +	free((void *)buf);
             ^^^^^^^^
No need for cast this either here.

> +}
> +EXPORT_SYMBOL(nftnl_udata_free);
> +
> +size_t nftnl_udata_len(const struct nftnl_udata_buf *buf)

Better use uint32_t instead of size_t. This type depends on the arch
so in 32 bit will be u32 and in 64 bit will be u64.

And uint32_t should be sufficient for this, same thing here and
everywhere else.

> +{
> +	return (size_t)(buf->end - buf->data);
> +}
> +EXPORT_SYMBOL(nftnl_udata_len);
> +
> +size_t nftnl_udata_size(const struct nftnl_udata_buf *buf)

Same thing here.

> +{
> +	return buf->size;
> +}
> +EXPORT_SYMBOL(nftnl_udata_size);
> +
> +void *nftnl_udata_data(const struct nftnl_udata_buf *buf)
> +{
> +	return (void *)buf->data;
> +}
> +EXPORT_SYMBOL(nftnl_udata_data);
> +
> +void nftnl_udata_copy_data(struct nftnl_udata_buf *buf,
> +			   const void *data, size_t len)
> +{
> +	memcpy(buf->data, data, len <=3D buf->size ? len : buf->size);
> +	buf->end =3D buf->data + len;
> +}
> +EXPORT_SYMBOL(nftnl_udata_copy_data);
> +
> +struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *=
buf)
> +{
> +	return (struct nftnl_udata *)buf->data;
> +}
> +EXPORT_SYMBOL(nftnl_udata_start);
> +
> +struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *bu=
f)
> +{
> +	return (struct nftnl_udata *)buf->end;
> +}
> +EXPORT_SYMBOL(nftnl_udata_end);
> +
> +struct nftnl_udata *nftnl_udata_put(struct nftnl_udata_buf *buf,
> +				    uint8_t type, size_t len, const void *value)
> +{
> +	struct nftnl_udata *attr =3D NULL;
> +
> +	/* Check if there is enough space */

Remove this comment.

> +	if (buf->size >=3D len + sizeof(struct nftnl_udata)) {
> +		attr =3D (struct nftnl_udata *)buf->end;
> +		attr->len  =3D len;
> +		attr->type =3D type;
> +		memcpy(attr->value, value, len);
> +
> +		buf->end =3D (char *)nftnl_udata_attr_next(attr);
> +	}
> +
> +	return attr;

Why return the nftnl_udata? You can just return a boolean instead.
Same thing in nftnl_udata_put_strz().
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
