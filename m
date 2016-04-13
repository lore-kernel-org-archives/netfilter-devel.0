From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 v6] libnftnl: Implement new buffer of TLV objects
Date: Thu, 14 Apr 2016 01:13:22 +0200
Message-ID: <20160413231322.GA4253@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbcDMXNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 19:13:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6247673F2
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:13:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 53B4FA862
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:13:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4068CA79D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:13:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 08:46:24PM +0100, Carlos Falgueras Garc=EDa wro=
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
> 	buf =3D nftnl_udata_buf_alloc(UDATA_SIZE);
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
> 	nftnl_udata_buf_free(buf);
> 	```
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/Makefile.am          |   1 +
>  include/libnftnl/Makefile.am |   1 +
>  include/libnftnl/udata.h     |  54 ++++++++++++++++++
>  include/udata.h              |  40 +++++++++++++
>  src/Makefile.am              |   1 +
>  src/libnftnl.map             |  16 ++++++
>  src/udata.c                  | 131 +++++++++++++++++++++++++++++++++=
++++++++++
>  7 files changed, 244 insertions(+)
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
> index 0000000..166bb06
> --- /dev/null
> +++ b/include/libnftnl/udata.h
> @@ -0,0 +1,54 @@
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
> +struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size);
> +void nftnl_udata_buf_free(struct nftnl_udata_buf *buf);
> +uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf);
> +uint32_t nftnl_udata_buf_size(const struct nftnl_udata_buf *buf);

Do we need nftnl_udata_buf_size? If not, please remove this.

We should only expose the interfaces that are strictly necessary.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
