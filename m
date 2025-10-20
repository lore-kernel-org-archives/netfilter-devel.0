Received: from siberian.tulip.relay.mailchannels.net (siberian.tulip.relay.mailchannels.net [23.83.218.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325742E3387
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 21:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.246
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760997478; cv=pass; b=t8tmZY4T3PoevuGhmG5gJflCdtDKOUYDWog+hGTQrOz3YT0TgIidnKk4ZWb3aiwbH2Ut1IfJAr/zqwA9SBATWdzUD3eHGm4TZS6lya+cH5F4v2Y7ESxtTRGtK2lnh0jwqAXyuCpZcAgYMnmvORagLTTzlPjthe1rBHM8jHjgIqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760997478; c=relaxed/simple;
	bh=usXC/oazqOtLDDjrGNg+tPjTSiVfsZah7FTloi1W83I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cuqg4CkxmDFXSRWcF56y8P0vV8uem/MeaJGorWorPI6njYdeh3hjsLPHpXmz7gkiAzEwwe3PziS32cbivT1ESEBXG28/lzWRl1TGEvEMRQTMJqlNt7njj0nnByQrQx+Rlne+tgKskyFQOy70e5N5l6tg8J70VfnqGVa/76SiFZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=DJXEc6Cd reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="DJXEc6Cd"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C8C71700F06;
	Mon, 20 Oct 2025 21:57:49 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-117-132-18.trex-nlb.outbound.svc.cluster.local [100.117.132.18])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id BABF8700BAA;
	Mon, 20 Oct 2025 21:57:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760997469; a=rsa-sha256;
	cv=none;
	b=nyPZBBaoF2bo2zBWWCboLqQHCDPE2xydGpjiXzlM35aUPR6lrJQQehPp6M2cNsJGrGtNET
	kOPowIUfrNTzXJ6fwUqq0mjHAx7PSZ7vb4K0r/5exqNeh01jqlTarIQ/wG0NezMfWMnDPW
	yN0PAyhIO55P6dTZhS+AvHCK9+A1/mYIIO4GqRbTWBQWdPrrz8zHfdHXf6YKnrysUUmzkj
	Qx8DKmYvncurej+enImioXgmkRsV15/Xl/TZR4xqyLWvZTu1ZYEHrcdeCi7M0i/MRQDCtk
	my/PlborcAXseApHAj9haTCpJQOsUqYNUTlRtf9sgNoM0BS7Ymjs+gwdif+zwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760997469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usXC/oazqOtLDDjrGNg+tPjTSiVfsZah7FTloi1W83I=;
	b=K1Xg1Cr40rv7r4F4l2UV4TerpMIN075/qemVeM9U9Mn+NUIeTRegZ3Dxfw/iFUYmwOwcmW
	od1K8Ox0whGb0zjioqhVKnSDzljRONsAWWcwgukQ6Cz08+trfxStF5KtS8f1CcVGC+7Unr
	g3CH4iv83yb393VaiZFG8wuVA+Yex9Rs6evIAuAWMtFoK0sG5XvgwVY0LoKX/ovgUe3VgF
	zw3MZGROH5wix1IVQWoii9Wb1zq0rGiYFVqB9bV9xuCB3wcIN8zfkKfdaoNWeapfbHv2Lv
	mbCo0W3D8S8MFO3A0Jl2B302PnhyJIutCXK8uksX+bng1zltSexmgd0xSy20hA==
ARC-Authentication-Results: i=1;
	rspamd-869c579f6-7rcq2;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Occur-Fumbling: 7ee7ab54683420df_1760997469649_3570051947
X-MC-Loop-Signature: 1760997469648:3100155619
X-MC-Ingress-Time: 1760997469648
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.132.18 (trex/7.1.3);
	Mon, 20 Oct 2025 21:57:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=usXC/oazqOtLDDjrGNg+tPjTSiVfsZah7FTloi1W83I=; b=DJXEc6CdXIXa
	0wJ9aFXy4XsstVZio0TnBrzdTzwm++cBl/4c+1dPv5qVm1AHhip/KPOxw3wrGYqMiW77OAMeVNac9
	2Sq4+xScEAnEyDrcWR9j7o5iBdC76CJI3nw/xbzKBothZM669HtL1bv++18fudVPBoX1FbsSNicSJ
	86ZYYUFp8p873ptoBqhV10wV/QR+2Aj4STFU2quxIPvPkD481bm82+nnwRFEu72E4bgyqM0hOB7tX
	tQOuDeyneeV9xrheXbpUI97YDjI6CUHt5Dksw3MaEVG+IzIteUlb89pUQyit9Qf4SNGoIXP/0TurO
	+P8ZRmdUwI6vg27bmzXK5w==;
Received: from [79.127.207.162] (port=54232 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAxsw-00000008xpM-1VmP;
	Mon, 20 Oct 2025 21:57:45 +0000
Message-ID: <cb2b48e9a9d4d8c13b53297e5cc4482e0057deec.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v3 4/6] doc: add more documentation on bitmasks and sets
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Mon, 20 Oct 2025 23:57:44 +0200
In-Reply-To: <aPX7qH9nCZ5VfxEJ@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
	 <20251019014000.49891-5-mail@christoph.anton.mitterer.name>
	 <aPX7qH9nCZ5VfxEJ@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

On Mon, 2025-10-20 at 11:06 +0200, Florian Westphal wrote:
> Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:=C2=
=A0
> > +Equality of a value with a set is given if the value matches
> > exactly one value
> > +in the set.
>=20
> That contradicts whats right above, which describes range handling.

Uhm... what exactly do you mean?

But that's anyway missing the stuff about how interval values are
matched, which I only sent as stand alone patch in some mail before.


> > +It shall be noted that for bitmask values this means, that
> > +*'expression' 'bit'[,'bit']...* (which yields true if *any* of the
> > bits are set)
> > +is not the same as *'expression' {'bit'[,'bit']...}* (which yields
> > true if
> > +exactly one of the bits are set).
> > +It may however be (effectively) the same, in cases like
> > +`ct state established,related` and `ct state
> > {established,related}`, where these
> > +states are mutually exclusive.
>=20
> Would you object if I apply this patch but onlt rhe first part?

You mean: not the changes to nft.txt?

What I think should be kept being added to the SETS documentation in
nft.txt is:
> Equality of a value with a set is given if the value matches exactly
> one value
> in the set (which for intervals means that it=E2=80=99s contained in any =
of
> them).

Cause that's currently nowhere really documented, AFAICS.

The following:
> It shall be noted that for bitmask values this means, that
> *'expression' 'bit'[,'bit']...* (which yields true if *any* of the
> bits are set)
> is not the same as *'expression' {'bit'[,'bit']...}* (which yields
> true if
> exactly one of the bits are set).

Can be skipped, or maybe one should add a small reference like:
> See <<BITMASK TYPE>> for how equality checks differ between sets and
> bitmasks.

This:
> It may however be (effectively) the same, in cases like
> `ct state established,related` and `ct state {established,related}`,
> where these
> states are mutually exclusive.

We can either simply drop, or move over to the BITMASK TYPE section.
It's not super important, but I think there might be some value in
understanding why these are identical (especially as many people use
something like ct new {established,related}.


> I think the above just duplicates what is explained in the new
> bitmask part above it.

Other than the above... I'd be fine with that :-)


Wanna a new patch or are you going to do it yourself?


Cheers,
Chris.
