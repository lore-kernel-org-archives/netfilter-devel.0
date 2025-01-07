Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779031F4E29;
	Tue,  7 Jan 2025 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736278014; cv=none; b=oV6EjwWi1rSCcwRIu1DdtkLNULQ3qZ9HQ9AjO9GAihnVLNHtsAwLhlgKCEoN3KiL/aeqybD8pYXRJuKoK3O75rYAWRyIK0use4GW9feLw7po9rS0sQ3hEi75CFbzAQuhvzI06xhut/U2q4HpNBRgGSsQJgJo1UjHyM1D14WaG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736278014; c=relaxed/simple;
	bh=XemCswVLp9RBpcQkxBxvnXxtPIlCbtxKHu3dvYgsXSg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iC2iGE6+2ivZ1nOVhZwV5il8P/bRwkRcfZ2F0GFYiOEWfUpPrJzfQhUUXmWWWnzN8sVvfn2VS6PWhGY1RQUXCv4W0PPbG6eoZGPPsTa7PROA25RuzEVTmEBxyWhfxDz0Xp2Mg2ec5+Ky2U5HRzO1J2adIg62UxnQMvo3PO0smEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 7980D19201E9;
	Tue,  7 Jan 2025 20:26:49 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Tu0yFIAFenvF; Tue,  7 Jan 2025 20:26:47 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-13.pool.digikabel.hu [80.95.82.13])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 6C5F819201E3;
	Tue,  7 Jan 2025 20:26:47 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 4A2C2142729; Tue,  7 Jan 2025 20:26:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 474B71421D7;
	Tue,  7 Jan 2025 20:26:47 +0100 (CET)
Date: Tue, 7 Jan 2025 20:26:47 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/10] netfilter: iptables: Merge ipt_ECN.h to
 ipt_ecn.h
In-Reply-To: <20250107024120.98288-6-egyszeregy@freemail.hu>
Message-ID: <eb46258b-0fb2-c0be-f1aa-79497f3dc536@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-6-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1974386103-1736278007=:220661"
X-deepspam: 20ham 10%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1974386103-1736278007=:220661
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>=20
> Merge ipt_ECN.h to ipt_ecn.h header file.
>=20
> Signed-off-by: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> ---
>  include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 +--------------------
>  include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
>  2 files changed, 27 insertions(+), 28 deletions(-)
>=20
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi=
/linux/netfilter_ipv4/ipt_ECN.h
> index e3630fd045b8..6727f5a44512 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> @@ -1,34 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* Header file for iptables ipt_ECN target
> - *
> - * (C) 2002 by Harald Welte <laforge@gnumonks.org>
> - *
> - * This software is distributed under GNU GPL v2, 1991
> - *=20
> - * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
> -*/
>  #ifndef _IPT_ECN_TARGET_H
>  #define _IPT_ECN_TARGET_H
> =20
> -#include <linux/types.h>
> -#include <linux/netfilter/xt_DSCP.h>
> -
> -#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)

The definition above is removed from here but not added to ipt_ecn.h, so=20
it's missing now. Please fix it in the next round of the patchset.

> -#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
> -#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
> -#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
> -
> -#define IPT_ECN_OP_MASK		0xce
> -
> -struct ipt_ECN_info {
> -	__u8 operation;	/* bitset of operations */
> -	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
> -	union {
> -		struct {
> -			__u8 ece:1, cwr:1; /* TCP ECT bits */
> -		} tcp;
> -	} proto;
> -};
> +#include <linux/netfilter_ipv4/ipt_ecn.h>
> =20
>  #endif /* _IPT_ECN_TARGET_H */
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi=
/linux/netfilter_ipv4/ipt_ecn.h
> index 8121bec47026..a6d479aece21 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> @@ -1,10 +1,26 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Header file for iptables ipt_ECN target and match
> + *
> + * (C) 2002 by Harald Welte <laforge@gnumonks.org>
> + *
> + * This software is distributed under GNU GPL v2, 1991
> + *
> + * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
> + */
>  #ifndef _IPT_ECN_H
>  #define _IPT_ECN_H
> =20
> +#include <linux/types.h>
> +#include <linux/netfilter/xt_dscp.h>
>  #include <linux/netfilter/xt_ecn.h>
> +
>  #define ipt_ecn_info xt_ecn_info
> =20
> +#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
> +#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
> +#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
> +#define IPT_ECN_OP_MASK		0xce
> +
>  enum {
>  	IPT_ECN_IP_MASK       =3D XT_ECN_IP_MASK,
>  	IPT_ECN_OP_MATCH_IP   =3D XT_ECN_OP_MATCH_IP,
> @@ -13,4 +29,14 @@ enum {
>  	IPT_ECN_OP_MATCH_MASK =3D XT_ECN_OP_MATCH_MASK,
>  };
> =20
> +struct ipt_ECN_info {
> +	__u8 operation;	/* bitset of operations */
> +	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
> +	union {
> +		struct {
> +			__u8 ece:1, cwr:1; /* TCP ECT bits */
> +		} tcp;
> +	} proto;
> +};
> +
>  #endif /* IPT_ECN_H */
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
--8323329-1974386103-1736278007=:220661--
