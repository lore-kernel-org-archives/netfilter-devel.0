Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCD1FBEA8
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761785599; cv=pass; b=aCFLz1008QQpupv2u1P3eQlnK0Ttpo7JIjYhIZsljeBn8ji8b06Sn4bTkBqh+u0a4bKjP8Ki2pvgHph6+mnId/qOjHSSUQnh5LQB8mWQe/o3uFNoxSjfnR8OjMHuKyZ07uIQzMFgC5tLVr7edNKBPPsixD/kLeLtBc76uRyOowA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761785599; c=relaxed/simple;
	bh=630ZLVL0IJ0TCu42hp14ywFsnINLXfJiquGV/C11tMQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VJgQ7E2XBpf8hYeT1aY7OtNZUUmo0EasSjGioysVxsStYLg+FrtxcvUBg/7AxTi3W58lnrYP0/J5g1DJlssUiLXzXmKP4025DUMxFWKMXxqPOoqAJuMQXCRUkkqwp+WPn3gBa0mh6OOK6WfqOyc628/fNJ+oXVTajXWnOU7SHnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=E15hY9gC reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="E15hY9gC"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B9B08721D1F;
	Thu, 30 Oct 2025 00:53:16 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-5.trex.outbound.svc.cluster.local [100.123.217.88])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id EA3C77212CB;
	Thu, 30 Oct 2025 00:53:15 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761785596; a=rsa-sha256;
	cv=none;
	b=+OT2TRRq+2XQy4bSarUkqYSXnQhf5CW+3IW8VtXtGCV/dltw9AFMMnR1/H84gdU1sQgz37
	Vg8gkHSusRgoXOcMM65tq7ShsoCvP7yG2iX9Uy6TsG/G9cUw5A2aFWVaVCjj+rSQCU3698
	TSouiMTbFuKze2qhWHoCfO9XYEY3LaTuRXG5G9v4RiYnV+tDGmxB+ycPuGKhoasOS9PePb
	P2epMPh6Sox2Tp7zzFKUo3AHUXvh/ooYK7eCOkliA72bX2K8bU2TvLK+Q48vmYDjBQeCfP
	BeADpcpK5h8rcr3qR0uAOb/RrLG/xBzdO2ujOAZyyvuvPhCnEz9m2++XJ4ShqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761785596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=630ZLVL0IJ0TCu42hp14ywFsnINLXfJiquGV/C11tMQ=;
	b=6ST+iIX53U6Zz5UxrpMTe+jkdsTCmvCTweV7F2QoqyUNbzoDqgMJ0qikvKOmhBeAZ/40nx
	A4bZatXwp7UNylaoF9Sl574mLR3oEcvamghhK86ATkG+b+gdD634W96zKV9V9MYmaWewQN
	/dI+Y4TSKok38HrEEaqsGet3A92SV8NkY8rK3+va4Qx/FEl1yiWkjGPiO1WlJDjyohE9k7
	tUyCGxEYOT3/SRZttjdLB0xi8AYM0P/uy41HWRNhq5Ezqj24HS2WZ6qMJtMvhLsw7W+Nmw
	FSEB8BG+DdIhYPw8dddcLqSiH6VPPmD4ko1s6FbCJ6VmJvy/AhDPR9wwi+Oetg==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-qk84r;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Stretch-Abiding: 7ee680794e9a118d_1761785596637_1065377626
X-MC-Loop-Signature: 1761785596637:3612121517
X-MC-Ingress-Time: 1761785596637
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.217.88 (trex/7.1.3);
	Thu, 30 Oct 2025 00:53:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=630ZLVL0IJ0TCu42hp14ywFsnINLXfJiquGV/C11tMQ=; b=E15hY9gCpDS2
	ME7+S/6mqRMi1ROGINcNIFE9llVlRUuqnWLdYvHlzFPC+/lahX/H5H2R0wM5bg6DWaW0okBAEq1BL
	ZIGojLs3IQNjoQEoy/oi3i0dgPZoEYZsLZIpX980SyKMti/DCwW+g8FKfCsYEAyHrJ0Hj0w3qHfuc
	7awo05LAM5v6gSBR91Xt+7RMBW0PIDx7zPQpSMbJnysKThJAv+0x0CAovc+gAVufPtTgT+Fy9ixV3
	jFPzoqAT/R12Vp/H1Zmo74S4971w76DhMEqw/PajLvnPUZTYJBvS+M/c4WQ2vLHnpNQ9FJUDKtyMf
	xCSz81WZWVk4OnlocLbaew==;
Received: from [212.104.214.84] (port=42397 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vEGug-00000002la8-2vMf;
	Thu, 30 Oct 2025 00:53:14 +0000
Message-ID: <d61be988f7974bd60f0550221b14354c2d4b6a76.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual
 dedicated unit stop
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Thu, 30 Oct 2025 01:53:12 +0100
In-Reply-To: <5rs82n4r-4por-6784-1n4o-39730qrs65n0@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	  <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
	  <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
	 <b88acc763d340c8f7859349621fa6a0f027610b2.camel@christoph.anton.mitterer.name>
	 <5rs82n4r-4por-6784-1n4o-39730qrs65n0@vanv.qr>
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

On Wed, 2025-10-29 at 11:07 +0100, Jan Engelhardt wrote:
> "The universe will always build a better idiot"
>=20
> before you know it they'll type `systemctl stop nftables; systemctl
> start
> nftables`, nullifying the restart magic.

Well but here it's literally to be seen in the command, that there's
first a stop, then a start.
Which is - at least not that - obvious with restart, especially as
there are services which have no ExecStop=3D, as you say.


> If you really need restart-safe behavior, then just delete the
> ExecStop=3D line entirely (at the cost of not flushing the ruleset).
> sysctl.service does not have ExecStop either, it also does not reset
> sysctl settings.

Well, I had suggested that as an alternative in the first mail of the
series.

I think it would be better than what we have now, but may of course be
disliked by people who actually want to use the stop action to disable
any firewalling.
That's why I came up with the proposed solution that would give us
both.


But I merely proposed that for the benefit over everyone, so I'm
totally find with ending discussion at this point and simply leaving
things as is.


Cheers,
Chris.
