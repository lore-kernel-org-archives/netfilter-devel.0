Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720CB30DD3A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 12:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769516119; cv=none; b=cMX7HpXpEDsewbNMsZ3c4cygwk+HzFLm35sJITrX8nRnOlWlGtewhK7gvRoKGHXvfgQmBy7DOQc8NynQvrVx12/jn8tqUrlsXdXHkldygFf9jUXEunK1Wa0RCM6Rupf3FoUcV4Nz4/GketoRc0AyNtKijKTG7cevSpNeLT3IxNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769516119; c=relaxed/simple;
	bh=8IvF9whHf7JnvqOc2epbzBtRNfsqvAVpMBTb5tkzRBU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPyBtLvxKwIdCVmP2PrwV/iT3QHy1MjGTSjA8f4bFqFQ0YdTNYW9I6Q5S+AjkNiYpdtzMMTiVOnQyiiUQw5Khcyg/qDj9BhTBvG17ddOCCIprFJhjV69iPrRmXFEFVQ429uovYSyKgJSX00A4WGYjIPTZpCWbif3ln63+8C0HWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=RRLfU6Tz; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="RRLfU6Tz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769516101; x=1769775301;
	bh=8IvF9whHf7JnvqOc2epbzBtRNfsqvAVpMBTb5tkzRBU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RRLfU6TzqRddRtzOJJiyeFVvLd7bBFXpWPTBuy+Qis3f54ni4Fbi/1F9hSI4xBis1
	 exblp0fIKZLrPwQ7ge86j4fqW9pmQ1V6FOSGfgvzkL5OXHw+b71bdd5CLQhIvHKtqn
	 jQg+vbRgbREMpMP9TLfivGwbKDRQW3sIp/R1MumzgkXWi1P6LuyNR+iPnmR/EKe2xl
	 k8yveUdvYnnYYVLq+zN9l7+Je5Y+a7bFj2l+bsgHIWo5qNeAAerh64yrP6FCNYOpuH
	 1ZXWuzljqiddfKJZk3471Ed4B8T0ZDJIQUYU0WvIORBQQEsDU+Dm46DyO+ncWzkwI7
	 NKSACjwMWmv0A==
Date: Tue, 27 Jan 2026 12:14:56 +0000
To: Florian Westphal <fw@strlen.de>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com>
In-Reply-To: <aXiiYOxuXVn5YhXG@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-6-one-d-wide@protonmail.com> <aXiiYOxuXVn5YhXG@strlen.de>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 204d2a215ee0497f9b11ffb164a21565a103ffe6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 27th, 2026 at 11:32, Florian Westphal <fw@strlen.de> wr=
ote:

> Remy D. Farley one-d-wide@protonmail.com wrote:
>=20
> > Signed-off-by: Remy D. Farley one-d-wide@protonmail.com
> > ---
> > Documentation/netlink/specs/nftables.yaml | 25 +++++++++++++++++++++++
> > 1 file changed, 25 insertions(+)
> >=20
> > diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/=
netlink/specs/nftables.yaml
> > index 4b1f5b107..ce11312b9 100644
> > --- a/Documentation/netlink/specs/nftables.yaml
> > +++ b/Documentation/netlink/specs/nftables.yaml
> > @@ -1509,6 +1509,31 @@ sub-messages:
> > operations:
> > enum-model: directional
> > list:
> > + -
> > + # Defined as nfnl_compat_subsys in net/netfilter/nft_compat.c
> > + name: getcompat
> > + attribute-set: compat-attrs
> > + fixed-header: nfgenmsg
> > + doc: Get / dump nft_compat info
>=20
>=20
> Whats the intent here? nft_compat isn't used by nftables, this
> is iptables-nft compatibility glue.

I noticed getcompat operation used by `nft list ruleset` command, and it
doesn't seem to be defined anywhere else. Should I re/move it?
