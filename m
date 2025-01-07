Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8331F2C48;
	Tue,  7 Jan 2025 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736277813; cv=none; b=qO20anmeaAHweKNFpsReqYmTv8lvN4Zf2sDP+k/VI8ST5cWUdBifSYirrtnZV7Ch8m02TQEsHHOsVl5J7rr8dV/1WPVGmI2D7Cg9DbiEYor/hMpdfHppG0zcB+kG89vETHxLtvk6tt+bMPqYfGJ6AgyzBOsKS6f76l0IlIop5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736277813; c=relaxed/simple;
	bh=ane7/hXXGI723khzflcT3QJcN5jch4qoK3p/q2wsqR8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CM+D80g4a4Ae9rjWGxpVRawtQA2aXKpUf0R7gKwHVBDgHeydX0rpvKTTPtq2mDQMhZTfF+/zmJvd6RusslrfKm6Mmw8Fwy6ev8bwz76Dd7hSSWDExZjpdiKtbdwdrxVoaHUtrIUmSA4SwYr9hPp3YUjjg7BNyWGikn1Gwa6yjbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 9DA9119201E1;
	Tue,  7 Jan 2025 20:23:21 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id YVE-75tA8fU3; Tue,  7 Jan 2025 20:23:19 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-13.pool.digikabel.hu [80.95.82.13])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id C816A19201D6;
	Tue,  7 Jan 2025 20:23:18 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 8A53F142729; Tue,  7 Jan 2025 20:23:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 865961421D7;
	Tue,  7 Jan 2025 20:23:18 +0100 (CET)
Date: Tue, 7 Jan 2025 20:23:18 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to
 xt_dscp.h
In-Reply-To: <20250107024120.98288-2-egyszeregy@freemail.hu>
Message-ID: <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-2-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-43118583-1736277535=:220661"
Content-ID: <c98d35af-3ee9-ba58-d5c4-7cb70e66806b@blackhole.kfki.hu>
X-deepspam: maybeham 2%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-43118583-1736277535=:220661
Content-Type: text/plain; charset=UTF-8
Content-ID: <b40b19eb-0a24-e24a-eac8-5de37c6f6214@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>=20
> Merge xt_DSCP.h to xt_dscp.h header file.

I think it'd be better worded as "Merge xt_DSCP.h into the xt_dscp.h=20
header file." (and in the other patches as well).
=20
> Signed-off-by: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> ---
>  include/uapi/linux/netfilter/xt_DSCP.h | 22 +---------------------
>  include/uapi/linux/netfilter/xt_dscp.h | 20 ++++++++++++++++----
>  2 files changed, 17 insertions(+), 25 deletions(-)
>=20
> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linu=
x/netfilter/xt_DSCP.h
> index 223d635e8b6f..fcff72347256 100644
> --- a/include/uapi/linux/netfilter/xt_DSCP.h
> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
> @@ -1,27 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* x_tables module for setting the IPv4/IPv6 DSCP field
> - *
> - * (C) 2002 Harald Welte <laforge@gnumonks.org>
> - * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com=
>
> - * This software is distributed under GNU GPL v2, 1991
> - *
> - * See RFC2474 for a description of the DSCP field within the IP Heade=
r.
> - *
> - * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
> -*/
>  #ifndef _XT_DSCP_TARGET_H
>  #define _XT_DSCP_TARGET_H
> -#include <linux/netfilter/xt_dscp.h>
> -#include <linux/types.h>
> -
> -/* target info */
> -struct xt_DSCP_info {
> -	__u8 dscp;
> -};
> =20
> -struct xt_tos_target_info {
> -	__u8 tos_value;
> -	__u8 tos_mask;
> -};
> +#include <linux/netfilter/xt_dscp.h>
> =20
>  #endif /* _XT_DSCP_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linu=
x/netfilter/xt_dscp.h
> index 7594e4df8587..bcfe4afa6351 100644
> --- a/include/uapi/linux/netfilter/xt_dscp.h
> +++ b/include/uapi/linux/netfilter/xt_dscp.h
> @@ -1,15 +1,17 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* x_tables module for matching the IPv4/IPv6 DSCP field
> +/* x_tables module for matching/modifying the IPv4/IPv6 DSCP field
>   *
>   * (C) 2002 Harald Welte <laforge@gnumonks.org>
> + * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com=
>
>   * This software is distributed under GNU GPL v2, 1991
>   *
>   * See RFC2474 for a description of the DSCP field within the IP Heade=
r.
>   *
> + * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>   * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
>  */

For the sake of history it'd worth to prepend the last two lines with=20
something like: "Original version informations before merging the content=
s=20
of the files:"

> -#ifndef _XT_DSCP_H
> -#define _XT_DSCP_H
> +#ifndef _UAPI_XT_DSCP_H
> +#define _UAPI_XT_DSCP_H

In the first four patches you added the _UAPI_ prefix to the header=20
guards while in the next three ones you kept the original ones. Please=20
use one style consistently.

>  #include <linux/types.h>
> =20
> @@ -29,4 +31,14 @@ struct xt_tos_match_info {
>  	__u8 invert;
>  };
> =20
> -#endif /* _XT_DSCP_H */
> +/* target info */
> +struct xt_DSCP_info {
> +	__u8 dscp;
> +};
> +
> +struct xt_tos_target_info {
> +	__u8 tos_value;
> +	__u8 tos_mask;
> +};
> +
> +#endif /* _UAPI_XT_DSCP_H */
> --=20
> 2.43.5
>=20
>=20

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-43118583-1736277535=:220661--
