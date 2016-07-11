From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: add missing macro
Date: Mon, 11 Jul 2016 12:41:10 +0200
Message-ID: <20160711104110.GA1540@salvia>
References: <20160708162911.18756-1-eric.engestrom@imgtec.com>
 <20160708162911.18756-2-eric.engestrom@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, Eric Engestrom <eric@engestrom.ch>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Eric Engestrom <eric.engestrom@imgtec.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54211 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbcGKKlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:41:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BEBDC17DB6D
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:41:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A7389FAB54
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:41:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7DE769EBD8
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:41:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160708162911.18756-2-eric.engestrom@imgtec.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 08, 2016 at 05:29:11PM +0100, Eric Engestrom wrote:
> Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
> ---
>=20
> This can't compile without this macro=E2=80=A6 Is this header really =
used by anyone?
> Should it be removed, to avoid bit-rot?

Probably better to define something like:

#define SCTP_BITMAP_LEN         (256 / sizeof (u_int32_t))

and use it consistently all around the code, so we can get rid of
these ARRAY_SIZE() from the uapi header.

> ---
>  include/uapi/linux/netfilter/xt_sctp.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/uapi/linux/netfilter/xt_sctp.h b/include/uapi/li=
nux/netfilter/xt_sctp.h
> index 58ffcfb..e4410db 100644
> --- a/include/uapi/linux/netfilter/xt_sctp.h
> +++ b/include/uapi/linux/netfilter/xt_sctp.h
> @@ -3,6 +3,8 @@
> =20
>  #include <linux/types.h>
> =20
> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr)[0])
> +
>  #define XT_SCTP_SRC_PORTS	        0x01
>  #define XT_SCTP_DEST_PORTS	        0x02
>  #define XT_SCTP_CHUNK_TYPES		0x04
> --=20
> 2.9.0
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
