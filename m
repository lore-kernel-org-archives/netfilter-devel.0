Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E088618C03D;
	Tue,  7 Jan 2025 19:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736278806; cv=none; b=MYqekL56lkRGC22nFVFeAB4/vDntQ+POWhqlMsNOcwPI6+goOnX3Tz5Qo1J0/y6OkJGLRzyrLZ9nGEpirn7avBeDNy/gF4qNuyVGqyOQNd/opwJRqSr81LJ3quFNKJ5TWNBy4qqQfjtV0Z7OZDHtUngqR6/6ETG9NmAEp1V628Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736278806; c=relaxed/simple;
	bh=GNoiYGNe3BTzovHNXwUSIFQihH7dzp4B+TK7/4BQUc0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=D4mDZPtVjp4V8UBmtHDG8ddUlUJJZYKm5C5aAL15Sb8vtdHTqKobOjqqPJff6cxdTvVsaHw00GSHrrA/hDEhBM3cwyNVJa9vf0xNZuLCjD7Zi7WgtcCWi0+Rf5HtQ6t0u60HzFZKsixRvoCbQ7MSdinBH2KPantp6e+qcSLxMOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 06AFC5C001BF;
	Tue,  7 Jan 2025 20:39:55 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ahva0qRIDM8G; Tue,  7 Jan 2025 20:39:53 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-13.pool.digikabel.hu [80.95.82.13])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id F04AD5C001BC;
	Tue,  7 Jan 2025 20:39:52 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id D1FDB142729; Tue,  7 Jan 2025 20:39:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id CFE801421D7;
	Tue,  7 Jan 2025 20:39:52 +0100 (CET)
Date: Tue, 7 Jan 2025 20:39:52 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
In-Reply-To: <20250107024120.98288-10-egyszeregy@freemail.hu>
Message-ID: <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-10-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1563264698-1736278792=:220661"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1563264698-1736278792=:220661
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>=20
> Display information about deprecated xt_*.h, ipt_*.h files
> at compile time. Recommended to use header files with
> lowercase name format in the future.

I still don't know whether adding the pragmas to notify about header file
deprecation is a good idea.

On my part that's all. Thank you the work!

Best regards,
Jozsef
=20
> Signed-off-by: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> ---
>  include/uapi/linux/netfilter/xt_CONNMARK.h  | 2 ++
>  include/uapi/linux/netfilter/xt_DSCP.h      | 2 ++
>  include/uapi/linux/netfilter/xt_MARK.h      | 2 ++
>  include/uapi/linux/netfilter/xt_RATEEST.h   | 2 ++
>  include/uapi/linux/netfilter/xt_TCPMSS.h    | 2 ++
>  include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 2 ++
>  include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 2 ++
>  include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 2 ++
>  8 files changed, 16 insertions(+)
>=20
> diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/=
linux/netfilter/xt_CONNMARK.h
> index 171af24ef679..1bc991fd546a 100644
> --- a/include/uapi/linux/netfilter/xt_CONNMARK.h
> +++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter/xt_connmark.h>
> =20
> +#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h=
 instead.")
> +
>  #endif /* _XT_CONNMARK_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linu=
x/netfilter/xt_DSCP.h
> index fcff72347256..bd550292803d 100644
> --- a/include/uapi/linux/netfilter/xt_DSCP.h
> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter/xt_dscp.h>
> =20
> +#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead=
.")
> +
>  #endif /* _XT_DSCP_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linu=
x/netfilter/xt_MARK.h
> index cdc12c0954b3..9f6c03e26c96 100644
> --- a/include/uapi/linux/netfilter/xt_MARK.h
> +++ b/include/uapi/linux/netfilter/xt_MARK.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter/xt_mark.h>
> =20
> +#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead=
.")
> +
>  #endif /* _XT_MARK_H_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/l=
inux/netfilter/xt_RATEEST.h
> index f817b5387164..ec3d68f67b2f 100644
> --- a/include/uapi/linux/netfilter/xt_RATEEST.h
> +++ b/include/uapi/linux/netfilter/xt_RATEEST.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter/xt_rateest.h>
> =20
> +#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h i=
nstead.")
> +
>  #endif /* _XT_RATEEST_TARGET_H */
> diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/li=
nux/netfilter/xt_TCPMSS.h
> index 154e88c1de02..826060264766 100644
> --- a/include/uapi/linux/netfilter/xt_TCPMSS.h
> +++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter/xt_tcpmss.h>
> =20
> +#pragma message("xt_TCPMSS.h header is deprecated. Use xt_tcpmss.h ins=
tead.")
> +
>  #endif /* _XT_TCPMSS_TARGET_H */
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi=
/linux/netfilter_ipv4/ipt_ECN.h
> index 6727f5a44512..42317fb3a4e9 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter_ipv4/ipt_ecn.h>
> =20
> +#pragma message("ipt_ECN.h header is deprecated. Use ipt_ecn.h instead=
.")
> +
>  #endif /* _IPT_ECN_TARGET_H */
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi=
/linux/netfilter_ipv4/ipt_TTL.h
> index 5d989199ed28..1663493e4951 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter_ipv4/ipt_ttl.h>
> =20
> +#pragma message("ipt_TTL.h header is deprecated. Use ipt_ttl.h instead=
.")
> +
>  #endif /* _IPT_TTL_TARGET_H */
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi=
/linux/netfilter_ipv6/ip6t_HL.h
> index bcf22824b393..55f08e20acd2 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> @@ -4,4 +4,6 @@
> =20
>  #include <linux/netfilter_ipv6/ip6t_hl.h>
> =20
> +#pragma message("ip6t_HL.h header is deprecated. Use ip6t_hl.h instead=
.")
> +
>  #endif /* _IP6T_HL_TARGET_H */
> --=20
> 2.43.5
>=20
>=20

--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1563264698-1736278792=:220661--
