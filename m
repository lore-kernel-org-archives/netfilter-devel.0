From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 v5] libnftnl: Implement new buffer of TLV objects
Date: Mon, 21 Mar 2016 23:10:18 +0100
Message-ID: <20160321221018.GA2059@salvia>
References: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37696 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbcCUWKi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2016 18:10:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B0A9DC1262
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:10:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9D1A1DA8FB
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:10:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94C8EDA384
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:10:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 09:28:04PM +0100, Carlos Falgueras Garc=EDa wro=
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
u> 	nftnl_udata_free(buf);
> 	```
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/Makefile.am          |   1 +
>  include/libnftnl/Makefile.am |   1 +
>  include/libnftnl/udata.h     |  49 ++++++++++++++++
>  include/udata.h              |  40 +++++++++++++
>  src/Makefile.am              |   1 +
>  src/libnftnl.map             |  32 +++++++++++
>  src/udata.c                  | 133 +++++++++++++++++++++++++++++++++=
++++++++++
>  7 files changed, 257 insertions(+)
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
> index 0000000..f65a1dc
> --- /dev/null
> +++ b/include/libnftnl/udata.h
> @@ -0,0 +1,49 @@
> +#ifndef _LIBNFTNL_UDATA_H_
> +#define _LIBNFTNL_UDATA_H_
> +
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +
> +/*
> + * nftnl user data attributes API
> + */
> +struct nftnl_udata;
> +struct nftnl_udata_buf;
> +
> +/* nftnl_udata_buf */
> +struct nftnl_udata_buf *nftnl_udata_alloc(uint32_t data_size);
> +void nftnl_udata_free(struct nftnl_udata_buf *buf);

If nftnl_udata_alloc() returns struct nftnl_udata_buf, then it's
better to call this:

        nftnl_udata_buf_alloc()

instead.

> +uint32_t nftnl_udata_len(const struct nftnl_udata_buf *buf);
> +uint32_t nftnl_udata_size(const struct nftnl_udata_buf *buf);
> +void *nftnl_udata_data(const struct nftnl_udata_buf *buf);

Same thing for these functions: nftnl_udata_buf_*().

> +void nftnl_udata_copy_data(struct nftnl_udata_buf *buf, const void *=
data,
> +			   uint32_t len);

Please, rename this to:

        nftnl_udata_buf_put()

> +struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *=
buf);
> +struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *bu=
f);
> +
> +/* putters */
> +bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint=
32_t len,
> +		     const void *value);
> +bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
> +			  const char *strz);
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
> index 0000000..407a3b9
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
> +	uint8_t		type;
> +	uint8_t		len;
> +	unsigned char	value[];
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
> +	uint32_t	size;
> +	char		*end;
> +	char		data[];
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
> index 2e193b7..329caca 100644
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

These above, you can remove them...

>    nftnl_set_list_alloc;
>    nftnl_set_list_free;
>    nftnl_set_list_add;
> @@ -512,4 +528,20 @@ LIBNFTNL_4.1 {
>  	nftnl_trace_get_data;
> =20
>  	nftnl_trace_nlmsg_parse;
> +
> +	nftnl_udata_alloc;
> +	nftnl_udata_free;
> +	nftnl_udata_len;
> +	nftnl_udata_size;
> +	nftnl_udata_data;
> +	nftnl_udata_copy_data;
> +	nftnl_udata_start;
> +	nftnl_udata_end;
> +	nftnl_udata_put;
> +	nftnl_udata_put_strz;
> +	nftnl_udata_attr_type;
> +	nftnl_udata_attr_len;
> +	nftnl_udata_attr_value;
> +	nftnl_udata_attr_next;
> +	nftnl_udata_parse;

=2E.. Since now you have placed them here in the right place, which is
the list of new symbols available under LIBNFTNL_4.1 :)

>  } LIBNFTNL_4;
> diff --git a/src/udata.c b/src/udata.c
> new file mode 100644
> index 0000000..61ee6c9
> --- /dev/null
> +++ b/src/udata.c
> @@ -0,0 +1,133 @@
> +#include <libnftnl/udata.h>
> +#include <udata.h>
> +#include <utils.h>
> +
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +
> +struct nftnl_udata_buf *nftnl_udata_alloc(uint32_t data_size)
> +{
> +	struct nftnl_udata_buf *buf;
> +
> +	buf =3D malloc(sizeof(struct nftnl_udata_buf) + data_size);
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

No need to set this to zero and NULL given that we're just releasing
this object.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
