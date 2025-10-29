Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074272C15A6
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761698523; cv=pass; b=UG1yb/5TR9IGnsnaziCB4RJKrYZJBK7aYxf2QxTmPn+j3XxhYJ0oZjBk0IeG22hc1PTGYGEhNQk+6b4gAl6E0HrIUpU7YlU4Tlp09Mq667AuNGgliPYIqY0Lh2pnSWU4U2FEb+c9ns8/bP9gxF6WQNJgcdnixRHhDvkh8v0UkIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761698523; c=relaxed/simple;
	bh=66WKiP+5zaY3za83VDAM+CMG4FteB+s71DMmjTWJOyU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mClFir0ha8fFwJudTID7xlWbGtQneiSMg2QZCrm6sBIqmFtzu6lxRF7xVp7/1kgg9zNT7R7w3kb6DZC8fKQ/VhlkeOdABNFkLYvVdO5TNuooAHLXrUz3Q0S8riTK21IahNwUv3D5AG+h0/qkp5pqkTnu0WABlX6f26MfoxmMNS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=SAhGnWf5 reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="SAhGnWf5"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DDA04780E61;
	Wed, 29 Oct 2025 00:41:55 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-118-36-217.trex-nlb.outbound.svc.cluster.local [100.118.36.217])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0C7B0780A49;
	Wed, 29 Oct 2025 00:41:54 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761698515; a=rsa-sha256;
	cv=none;
	b=7qVbbsMd6h2MAHDbpQrkvxcKN/ub1038ywX+hcutDkZpPVvAZkc2dsbGooVATHoYOQQKz4
	UVSgMRtmS6kg6sPxm6JaVrJ7vDw1d2CJobCd1gk/o+7S8Jl4xGj760+njZBIGkeG6+o6oV
	usmE6cG+ZMg63UVbhlYrbi2DquvqPW2qNh95lJ34sY8bdOCwU9/bD2V4tiKtLa5COibW0I
	VkizKLpHZokjysu0ZxEaj/NHZdt7uXTLrLNZMzLNtuH6dYVoi2aJYZPJ4VdjNY6bApmjY6
	r/uAOlhblHtJJbjLYaYlZO7chjsu1CLuV4l5I9s3m7p+niMt+HW4AIBT7Q6yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761698515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8MII1P9tcvJ0E1uo9o0kkMFuYrUmzQvYO0tRdfktCQ=;
	b=H63kWyeCyYA9WzFeYV8ZLO3Xzya8rIZuZIygPN38HGee3MO2olE59AnxJTCoJYPU/ecbOz
	0rXBTfIVExd3r4avvwkJrvvEz1tbWgfe/wFVKyrzc2Y+64311m8mohFfpWMzzqCajUDNrX
	himzEceLlM7XXkSnV/GEghtROhjVvgwEB7RFO1PkUtkE6wQiTsTTlfz4Ytdnj8IvLvtA9g
	qRbxSn85UBcfxROQU7pZa4OQPMcF9XBDRwn722ofJKLPbpznizw1JeZD3QNSxvJtSUqpyX
	eJMs73quu8qSli0z+sa1/fHkps71oLRZpeInepTYZbuHRhjyrzuKn1iRURhcGg==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-hvscs;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Continue-Illustrious: 3df1dd610cc3251d_1761698515737_544701233
X-MC-Loop-Signature: 1761698515737:2299918186
X-MC-Ingress-Time: 1761698515736
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.36.217 (trex/7.1.3);
	Wed, 29 Oct 2025 00:41:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=O8MII1P9tcvJ0E1uo9o0kkMFuYrUmzQvYO0tRdfktCQ=; b=SAhGnWf5E0jI
	OEXEBv0M5vq0Yj3zi+Arc6jpiATo+YtxTJ/+iscW2s2LbnE+Ly0RZvQQLIVSC09a+c5LT4IeDLz4F
	PbhKF2oCM18zX4X9sQPjlk+4MgCb+P2cpa8SC2GfcYxxQuxqO36+lw+OKSY6FaLIw96yn2veBQ3Ds
	F3Xyoq9tWsrY3VXxhKtn6ollSpGjMxfJrEDWr1IVfKLrzDDh0vG4MteUYS6XUNaVKgJDgAHfORhzf
	+yK2aj2aBwxRPD8xYr5XGSlP0cpOOzco8hF/xPo7FW3gr5esY11S+kTUSch5wItAonS1undKKs9HC
	QWxZM47ZYPkdwGSSFMgg1A==;
Received: from [212.104.214.84] (port=24654 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vDuG9-0000000DKte-1MIY;
	Wed, 29 Oct 2025 00:41:53 +0000
Message-ID: <b88acc763d340c8f7859349621fa6a0f027610b2.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual
 dedicated unit stop
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Wed, 29 Oct 2025 01:41:51 +0100
In-Reply-To: <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	 <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
	 <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
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

On Tue, 2025-10-28 at 18:31 +0100, Jan Engelhardt wrote:
> On Friday 2025-10-24 04:08, Christoph Anton Mitterer wrote:
> > In systemd, the `ExecStop=3D` command isn=E2=80=99t only executed on an
> > actual dedicated
> > unit stop, but also, for example, on restart (which is a stop
> > followed by a
> > start).
> >=20
> > There=E2=80=99s a chance users either don=E2=80=99t know this or (accid=
entally)
> > confuse restart
> > (and similar) with reload.
>=20
> I do not see room for a confusion, for I cannot imagine a Linux
> newbie in 2025
> starting off with a sysvinit-based distro (good luck finding those)
> and then deciding "yep, I'll edit nftables.service".

That rationale, I don't understand. What does editing nftables.service
have to do with it?

The scenario I'm trying to "solve" is:
A user changes his nftables rules and wants to get them loaded.
Unknowingly or accidentally he does a
  systemctl restart nftables.service
rather than
  systemctl reload nftables.service

The former, with the current service file in git, will cause the
ExecStop=3D command to be executed and the ruleset to be flushed.
Even if the new rules are sound, there'll be a short time window in
which everything is open.
And if the rules contain a syntax error/etc. the stop implied by the
restart will still succeed but the (re)start will fail, leaving the
firewall even longer open.

One can assume now that all systemd users know about reload vs. restart
(and that nftables.service actually has a reload defined), but that
seems quite optimistic to me.

So I felt if nftables *does* ship an example .service, it can well ship
one that handles such things better and less error prone.
Unfortunately, I found no better/shorter means for doing so than the
way I've had proposed.


Cheers,
Chris.
