Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F8A946C
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Apr 2025 07:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745219706; cv=none; b=c4Rtwn0AriLzZpsqmW1PXjY6KZwD/Y+R/76mKsMIxll6tfLP/GfuQMgfFQG4/4UxbuHdqYThcYvWcSH3vT+dS1znN5GtMCRMUP6rM12pezJPFvZ3INQf7Rbsd2k7tVnMd2vJynlLQ/9/x5Oui5L0Fbb1TSi1vBW+WlnKInlirKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745219706; c=relaxed/simple;
	bh=7RSoV7vSeeBhxDzoK9ZuU0cXN99Y5UdPX63RpZEgUD8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYWHrbtwXgEZl7TYRe53k6QfYaDvRsG7FI3RmPY3/c3Q4qAGP6sg8M19DNXU2j5h8OwtwnoGDHl/HtdIfcaUIByDXoBDy+gzA6tIY7ADSW4FFavFsr7RrahYasaGjqmVSmQgxt1Dthb4ncOkFXLE5ECFt3rTtiO28EAB/Ghj9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=eHFDoupA; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eHFDoupA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=laKCz247DGONFcM/nwZxRwkeULOujCG+LSbu3IxUlXY=; b=eHFDoupAyg3Ca5GtVfhTs//Fmw
	agaOT4h0tJoHjk6faTcRAULSHAXzAi+aYnKvqHEFsM55aX/SRRjnLOOJhHpBt9A9NdA8KfZm0jYYF
	ldLeBxYNML2mKJwWvtsQwD+qOfgTOPenTUOSZqU81spJ5xNY8d6KJSHtxBmlmcvaHlcpfK1vH8M5w
	Ou5ilLvh4ymL/yunWrjqbUtsyDHpUhxZMer4Qd18xebbQxwECp0zzgJ0CuV8azq1N3Rf7ThqWT5Bp
	XpVcATc9JUjSnvrX7erP3pMYs/zrlev24n7pjV+aduPULGTYd72tF+s15Gl3zt38NbE4H9P7nJG1l
	3L62TX9Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6lMn-0068o0-0r
	for netfilter-devel@vger.kernel.org;
	Mon, 21 Apr 2025 08:14:57 +0100
Date: Mon, 21 Apr 2025 08:14:55 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: use `NFPROTO_*` constants in
 "nf-logger-" module aliasses
Message-ID: <20250421071455.GA34242@celephais.dreamlands>
References: <20250420191540.2313754-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F2Ph58TAac93s2A8"
Content-Disposition: inline
In-Reply-To: <20250420191540.2313754-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--F2Ph58TAac93s2A8
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-04-20, at 20:15:40 +0100, Jeremy Sowden wrote:
> The nf_log_syslog and nfnetlink_log modules define module aliasses of the
> form:
>
>     nf-logger-${family}-${type}
>
> The family arguments passed to the `MODULE_ALIAS_NF_LOGGER` macro are a
> mixture of `AF_*` constants for families where these exist and integer
> literals for the rest.  In some of the latter cases, there are comments
> containing the related `NFPROTO_*` constants.
>
> Since there are `NFPROTO_*` for all families, use them throughout.

Please ignore: the `NFPROTO_*` constants are enum values, not macros, so
this doesn't work.

J.

> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  net/netfilter/nf_log_syslog.c | 10 +++++-----
>  net/netfilter/nfnetlink_log.c | 10 +++++-----
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 86d5fc5d28e3..b2463e5013b6 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -1078,8 +1078,8 @@ MODULE_ALIAS("nf_log_bridge");
>  MODULE_ALIAS("nf_log_ipv4");
>  MODULE_ALIAS("nf_log_ipv6");
>  MODULE_ALIAS("nf_log_netdev");
> -MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 0);
> -MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
> -MODULE_ALIAS_NF_LOGGER(3, 0);
> -MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
> -MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 0);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 0);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 0);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 0);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 0);
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 134e05d31061..03e3560eaa51 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -1207,11 +1207,11 @@ MODULE_DESCRIPTION("netfilter userspace logging");
>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ULOG);
> -MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
> -MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
> -MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
> -MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
> -MODULE_ALIAS_NF_LOGGER(5, 1); /* NFPROTO_NETDEV */
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 1);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 1);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 1);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 1);
> +MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 1);
>
>  module_init(nfnetlink_log_init);
>  module_exit(nfnetlink_log_fini);
> --
> 2.47.2
>
>

--F2Ph58TAac93s2A8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJoBfBYCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmfCeNGk4Y3XBMJpqTRLPw/umX9ApjzVQisqSnL31DhZ
ZBYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAMIA//VDjVuZilAlHp0HuBUxHKlx5E
D62tRWSy4JmBl2Z/JSeaz/6MXMPHElF09nh0rynXDG5+y2oa4a6YAyH1q2La75lx
QxOsG9Xidz3Ilx8fjdxmAF4XA3xVFYoTwaDKThv0q8lhiHgm43rJSdJk78v07LVE
eK4Y8lHZYGSptGa3j1PnsaHAHIDNDB0jk3dcqcEL4dfrXudetQM1MbesfFxDgPLy
VqaWMuAfDFe/TNVDu00pML3ciIvNpeKr/mWdjkE6nqJvLwQQQEJihoyvv5wkGl+J
ORP/QA8s4unnljG2HMcVdsa81aL9mXWbMh2hHsHjwMktoZyMGKjd36eb245ZTUEt
lOkpQEERp3Ar1vlvom/8Pd1jdTcw4hUeJmLJPIQqNzVw/y2CVsViHJ8BhC1FY0Iy
Y4TiWZ4R4zeVVAqzZCDsEEtVcLtbelStfNhfbV/7X3EDFiYNBbaPahDhV5EN0hND
Lpy8r+r6fQATFkGwTgc9paEE28bDlcO3ixYEkeHbneBBq5THkNa1Mud2rXlC6rIu
YM3QQat4MbfQSwsd6RHJjV7D+kOrsW6NKLXgjS2Jiletnk0S8vJncDX4DfbetJGx
tkppv8zkFpSEVSTGmbd4kpVtGSSoG+pUwN5GpZ2WNvbCRwAFjt3ALbrwOQyTWuvJ
aBDLDb8Y/1bji2BMPds=
=nLC1
-----END PGP SIGNATURE-----

--F2Ph58TAac93s2A8--
