Received: from mail-41103.protonmail.ch (mail-41103.protonmail.ch [185.70.41.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5721DDCA
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2024 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Gw8VP19A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1704437653; x=1704696853;
	bh=ZouF4jZMOHrMta5Q76w6AMcvJWcI0C5dkLyzmmJgU20=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Gw8VP19Af95rKPT8MKQchjVPJ1FP7/iMebRbbrFEXKErX08WH9IPVL3irv2Q6Hvd8
	 XOcbBj2f5Z51zRZBD9hQonwmIkf6zogEbu0QJMCha/k4Q0XFGniNV9xsSp4yqjZ/n4
	 IYvSGrqvXnMqteON9exofPk8MMQJwZIOFebuafCBsHiSozlp1iD/mKdWr/LQzN6VOl
	 Tx3h1cr4mXZ7IbR4els3mLGpRkfOkuWG00YEKeyxOL5qGoc9moVQ3b26V+2s792xb8
	 Kcz993q8SYTszXbWngEUQpYOx91jm6C+oKJtsr2ln2CJbGfMOPScLlbbmNcyRpEBr9
	 50ic8LJ9+P7Lw==
Date: Fri, 05 Jan 2024 06:53:56 +0000
To: Phil Sutter <phil@nwl.cc>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>, "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Subject: Re: GUI Frontend for iptables and nftables Linux firewalls
Message-ID: <Xn0aN3rxNQeDGkg3zRrA6dSOm2vtar0_qVHQ0qJ_T4Cg4r0ZNJTE_sM542aOVZBG3n5D1Y0QH8R0tYb_klArPSOybckWd1HnttmaUOOqy1I=@protonmail.com>
In-Reply-To: <ZZNwZEZtspTDLglp@orbyte.nwl.cc>
References: <F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com> <ZZNwZEZtspTDLglp@orbyte.nwl.cc>
Feedback-ID: 39510961:user:proton
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 2nd, 2024 at 10:09 AM, Phil Sutter <phil@nwl.cc> wrote:


> Hi,
>=20
> On Mon, Dec 25, 2023 at 03:26:13PM +0000, Turritopsis Dohrnii Teo En Ming=
 wrote:
>=20
> > Subject: GUI Frontend for iptables and nftables Linux firewalls
> >=20
> > Good day from Singapore,
> >=20
> > Besides Webmin, are there any other good GUI frontends for iptables and=
 nftables?
>=20
>=20
> This is a question better asked on netfilter@vger.kernel.org.
>=20
> > The GUI frontend needs to allow complex firewall configurations. I thin=
k Webmin only allows simple firewall configurations.
>=20
>=20
> I was once told fwbuilder[1] is a nice tool for that purpose but I never
> really used it and it seems dead ("Last Update: 2013-07-03", if sf.net
> is to be trusted).
>=20
> Cheers, Phil
>=20
> [1] https://fwbuilder.sourceforge.net/

Dear Phil,

I think I have given up looking for the best GUI frontend for iptables and =
nftables Linux firewalls. All of the software projects are either immature =
or abandoned. I think I will stick to firewall distros instead.

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
