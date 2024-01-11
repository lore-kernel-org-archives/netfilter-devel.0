Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C47A29D09
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="TCktonAN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1704980989; x=1705240189;
	bh=V2O//YbkqAbBz7aFDu9eiZjmxZmGdp335G0M0JUqs9U=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=TCktonANYRyCvI87b5FfWsyYOHq2ym0bmQ3WiXhJNFUMtzhajB/dKO4vhfeofSwjM
	 UUCE51+qXd24c8NqutPJi8btT/2R615qmRfv5xrQjNszaNyeztkdNPKTMbFDIaptSw
	 WeKdYfniEOUE80P7Me8qX+gqG1rtBaL/RBVKK0ueQYfWKy9ouGaJ7QnxrPEVNkxJRU
	 irUKFQr4xDY3w6R9RoMs+mtgKfMn9zZvwyMOUVfrNWbfmJWJ/xwFBJocwaFDkBN6OM
	 szX7KIUwgXdldVcwor/kFbpSvGf5uu4inXt3TXF9taIZkEh9dKEp1BPUCkc89Fwymo
	 U2dxDL+wgIwlQ==
Date: Thu, 11 Jan 2024 13:49:21 +0000
To: =?utf-8?Q?Josef_Vyb=C3=ADhal?= <josef@vybihal.cz>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: Phil Sutter <phil@nwl.cc>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>, "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Subject: Re: GUI Frontend for iptables and nftables Linux firewalls
Message-ID: <no6QdlKu7XVgyYEK-F06cajulfvwQ_Mia5MzclZH9o1r_I7u2waAjxpHIvSIlMS1FqhuQ52udZkrxY9fPSb6D1kVEoLtJwmoCSPGWhha9p0=@protonmail.com>
In-Reply-To: <d069ccef6d5913a6d24291fea134fa198a60e544.camel@vybihal.cz>
References: <F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com> <ZZNwZEZtspTDLglp@orbyte.nwl.cc> <Xn0aN3rxNQeDGkg3zRrA6dSOm2vtar0_qVHQ0qJ_T4Cg4r0ZNJTE_sM542aOVZBG3n5D1Y0QH8R0tYb_klArPSOybckWd1HnttmaUOOqy1I=@protonmail.com> <d069ccef6d5913a6d24291fea134fa198a60e544.camel@vybihal.cz>
Feedback-ID: 39510961:user:proton
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sunday, January 7th, 2024 at 8:37 PM, Josef Vyb=C3=ADhal <josef@vybihal.=
cz> wrote:


> Not sure how relevant is this for you, but opensnitch [1] is in my
> opinion very interesting project. It uses ebpf, so it has much more
> capabilites.
>=20
> Cheers,
> Josef
>=20
> [1] https://github.com/evilsocket/opensnitch

Hi Josef,

This project is very interesting, being an application firewall for linux d=
esktops. Could be what I am looking for.

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore

