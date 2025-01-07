Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09D31F4E53;
	Tue,  7 Jan 2025 19:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736278750; cv=none; b=Zf4sk66ZKTjVHhhqR8pno6LUsVcyi1QsMNG9ozbiypgGPFpXg23Je7Cgoc/iQkSOI3gsTi65b3HBqoA4sI4H9AwaJUrjBx6znvuyUGWSuY83oMFNLYzBWx2rvkDD8fIVxkA/Bp3zOW7gjroqGo500F+m3W/K0LR/rNJZq3xZs60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736278750; c=relaxed/simple;
	bh=RRyTg5RqrSNfrSyZmgHjPDOuJWlvk/L3IspmB+J+1aw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IG4tgWjeUNkt1aYR7bpInmgabXFPYQ0/w3gQ8H58xEqg9sKz2VYUfh7KHO5y+PxH+SYmlX0l4pNPSy749fRIh/XO42CjlBOryRe4e3ZVX1eFSYmVyoMrvcEUzcsplz7I9NGItn/dt4B5LvlmVcimHk3AGFlxQi2ILFV19TnD3Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 198FB19201E1;
	Tue,  7 Jan 2025 20:39:05 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 5PPwP1cMl44Z; Tue,  7 Jan 2025 20:39:03 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-13.pool.digikabel.hu [80.95.82.13])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id BA43B19201D6;
	Tue,  7 Jan 2025 20:39:02 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 99F88142729; Tue,  7 Jan 2025 20:39:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 96C1D1421D7;
	Tue,  7 Jan 2025 20:39:02 +0100 (CET)
Date: Tue, 7 Jan 2025 20:39:02 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10] netfilter: Adjust code style of xt_*.h, ipt_*.h
 files.
In-Reply-To: <20250107024120.98288-9-egyszeregy@freemail.hu>
Message-ID: <2962ec51-4d32-76d9-4229-99001a437963@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu> <20250107024120.98288-9-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-440724473-1736278487=:220661"
Content-ID: <24bbde30-061d-d652-76c0-18326c941711@blackhole.kfki.hu>
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-440724473-1736278487=:220661
Content-Type: text/plain; charset=UTF-8
Content-ID: <4c59e9c5-bcac-7ce4-a57f-39543a03b686@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>=20
> - Adjust tab indents
> - Fix format of #define macros

I don't really understand why it'd be important to use parentheses around=
=20
plain constant values in macros. The kernel coding style does not list it=
=20
as a requirement, see 12) 4. in Documentation/process/coding-style.rst.

Best regards,
Jozsef
=20
> Signed-off-by: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
> ---
>  include/uapi/linux/netfilter/xt_dscp.h      | 6 +++---
>  include/uapi/linux/netfilter/xt_rateest.h   | 4 ++--
>  include/uapi/linux/netfilter/xt_tcpmss.h    | 6 +++---
>  include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 8 ++++----
>  include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 3 +--
>  include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 3 +--
>  6 files changed, 14 insertions(+), 16 deletions(-)
>=20
> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linu=
x/netfilter/xt_dscp.h
> index bcfe4afa6351..22b6488ef2e7 100644
> --- a/include/uapi/linux/netfilter/xt_dscp.h
> +++ b/include/uapi/linux/netfilter/xt_dscp.h
> @@ -15,9 +15,9 @@
> =20
>  #include <linux/types.h>
> =20
> -#define XT_DSCP_MASK	0xfc	/* 11111100 */
> -#define XT_DSCP_SHIFT	2
> -#define XT_DSCP_MAX	0x3f	/* 00111111 */
> +#define XT_DSCP_MASK	(0xfc)	/* 11111100 */
> +#define XT_DSCP_SHIFT	(2)
> +#define XT_DSCP_MAX		(0x3f)	/* 00111111 */
> =20
>  /* match info */
>  struct xt_dscp_info {
> diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/l=
inux/netfilter/xt_rateest.h
> index da9727fa527b..f719bd501d1a 100644
> --- a/include/uapi/linux/netfilter/xt_rateest.h
> +++ b/include/uapi/linux/netfilter/xt_rateest.h
> @@ -22,8 +22,8 @@ enum xt_rateest_match_mode {
>  };
> =20
>  struct xt_rateest_match_info {
> -	char			name1[IFNAMSIZ];
> -	char			name2[IFNAMSIZ];
> +	char		name1[IFNAMSIZ];
> +	char		name2[IFNAMSIZ];
>  	__u16		flags;
>  	__u16		mode;
>  	__u32		bps1;
> diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/li=
nux/netfilter/xt_tcpmss.h
> index 3ee4acaa6e03..ad858ae93e6a 100644
> --- a/include/uapi/linux/netfilter/xt_tcpmss.h
> +++ b/include/uapi/linux/netfilter/xt_tcpmss.h
> @@ -4,11 +4,11 @@
> =20
>  #include <linux/types.h>
> =20
> -#define XT_TCPMSS_CLAMP_PMTU	0xffff
> +#define XT_TCPMSS_CLAMP_PMTU	(0xffff)
> =20
>  struct xt_tcpmss_match_info {
> -    __u16 mss_min, mss_max;
> -    __u8 invert;
> +	__u16 mss_min, mss_max;
> +	__u8 invert;
>  };
> =20
>  struct xt_tcpmss_info {
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi=
/linux/netfilter_ipv4/ipt_ecn.h
> index a6d479aece21..0594dd49d13f 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> @@ -16,10 +16,10 @@
> =20
>  #define ipt_ecn_info xt_ecn_info
> =20
> -#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
> -#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
> -#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
> -#define IPT_ECN_OP_MASK		0xce
> +#define IPT_ECN_OP_SET_IP	(0x01)	/* set ECN bits of IPv4 header */
> +#define IPT_ECN_OP_SET_ECE	(0x10)	/* set ECE bit of TCP header */
> +#define IPT_ECN_OP_SET_CWR	(0x20)	/* set CWR bit of TCP header */
> +#define IPT_ECN_OP_MASK		(0xce)
> =20
>  enum {
>  	IPT_ECN_IP_MASK       =3D XT_ECN_IP_MASK,
> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi=
/linux/netfilter_ipv4/ipt_ttl.h
> index c21eb6651353..15c75a4ba355 100644
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
> @@ -9,13 +9,12 @@
>  #include <linux/types.h>
> =20
>  enum {
> -	IPT_TTL_EQ =3D 0,		/* equals */
> +	IPT_TTL_EQ =3D 0,	/* equals */
>  	IPT_TTL_NE,		/* not equals */
>  	IPT_TTL_LT,		/* less than */
>  	IPT_TTL_GT,		/* greater than */
>  };
> =20
> -
>  struct ipt_ttl_info {
>  	__u8	mode;
>  	__u8	ttl;
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi=
/linux/netfilter_ipv6/ip6t_hl.h
> index caef38a63b8f..4af05c86dcd5 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
> @@ -9,13 +9,12 @@
>  #include <linux/types.h>
> =20
>  enum {
> -	IP6T_HL_EQ =3D 0,		/* equals */
> +	IP6T_HL_EQ =3D 0,	/* equals */
>  	IP6T_HL_NE,		/* not equals */
>  	IP6T_HL_LT,		/* less than */
>  	IP6T_HL_GT,		/* greater than */
>  };
> =20
> -
>  struct ip6t_hl_info {
>  	__u8	mode;
>  	__u8	hop_limit;
> --=20
> 2.43.5
>=20
>=20

--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-440724473-1736278487=:220661--
