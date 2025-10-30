Received: from black.elm.relay.mailchannels.net (black.elm.relay.mailchannels.net [23.83.212.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADB329E4E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761868752; cv=pass; b=QRogNneMQMhOthE0excdByDCdnZA69dUcl/oYVc+b7XMRQUEB7f0d0PDj4xGGrOH1Gy6g7cEGBC3612T95oLD4jvTSeTc9nSs9ewqF116Gm7ykCFXngBHRYefLOsArRO3vL4K7bXrNYK6QgbxFAzqBKH2h608AYcQLvLGM0eQYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761868752; c=relaxed/simple;
	bh=bXm4jZL0fksrWnPy1xZpnIL+t8qpvJJv8B0S9s2xAGQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DwHuRxVYjKH2xM6kMAD6kfCqJNNdzdyvo+ZdgBb0rlRleCydX5Rejmi4E7uhVrK79H3tg5UbNd6pxsQ/Sg3y1TWNWyf+gh3RNun0ILCH//yHnzP9wSiBrDqctoG4NapBq4yyjYiJYGz8rNbxg7SK3UAZ8RuCJU4oqn03XuDARuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1785D121558;
	Thu, 30 Oct 2025 23:59:09 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.121.54.118])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 35782120514;
	Thu, 30 Oct 2025 23:59:08 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761868748; a=rsa-sha256;
	cv=none;
	b=Et4OpgZBevMxKtaW0IRdOjWSS8xVP7d22hW17u7ai/SiT94YsaLGtwLaC/z+nXMi4lIDKw
	rVUoZ2z24WuN0p12vzZh2u/M+zkmYjfFaOkQ5IdNYgCQQakZqdicyYuKciMW2yMr5S7lRJ
	GHZUpD4bzeDlj9WpDjoNFXl9meBfdD9nnRNuoMJ80JFn1dTzjGfXXkwrcsBXFCx4HxgRWP
	tHm/ACNZO+uNqTfSVclq95uiG+TGpUNKzmsNZahWDXWVXW1GDwD674taXYD+CeJgRrhlrQ
	GzgYzwNd+kqDCR96xJGs2QK1S4lVfrDHtBMVYageOUr0OFJfoMlPqp2s3gtO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761868748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bXm4jZL0fksrWnPy1xZpnIL+t8qpvJJv8B0S9s2xAGQ=;
	b=egg+3PvCHFQqRnodZwQBuKaObfgsu+S4Nvwe1iyvHovPjWrBMXIEfYg66EhZdYLPuF94xo
	71CIe8qeziGuVm0y8GUCSrH/rN70Gs8lAd0G7XjxTDnK+Xs53eq1dyItGnYL3tWo1RNr0d
	Mn93VVnRhYiFIjkoJhPsl6pwKoTcZBsjdnzsZpfivzNhzdZWdM2QN/vF1u7ZfE4iLZ7hhI
	Qi+EcRHbTs1z6h4gW3qajpAeg5rhU9sxY2iSzPUgXzplaDTZzVpJPGonZfanrR9dLl/ohC
	7/JHg9gUxyG6PQaOamlwNUq3CZnEFxYq8awdH3YyxG4h9Gvl3Lr22MwrE90MQQ==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-f949h;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Illustrious-Zesty: 2f2eaf9c59d51b21_1761868748906_1385069019
X-MC-Loop-Signature: 1761868748906:2513600873
X-MC-Ingress-Time: 1761868748905
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.54.118 (trex/7.1.3);
	Thu, 30 Oct 2025 23:59:08 +0000
Received: from [212.104.214.84] (port=9990 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vEcXq-00000009Wxb-0r40;
	Thu, 30 Oct 2025 23:59:05 +0000
Message-ID: <f92fa0061f00e62af78033faef7b13e648afb3b8.camel@scientia.org>
Subject: Re: nftables.service hardening ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 31 Oct 2025 00:59:02 +0100
In-Reply-To: <aQPwcOW3X-4OGuiq@strlen.de>
References: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
	 <aQDuvGsDwlaiK94D@strlen.de>
	 <7c3760d6afad70f7579311022748363f7d5f5c77.camel@scientia.org>
	 <aQPwcOW3X-4OGuiq@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Fri, 2025-10-31 at 00:10 +0100, Florian Westphal wrote:
> Sure, but then we're talking about e.g. bug in dns resolver/parser
> or something like that.
>=20
> In general I don't believe Linux is capable of isolating against
> abusing userspace, unfortunately.=C2=A0 Especially with CAP_NET_ADMIN
> (which is very broad and provides access to many facilities in
> =C2=A0the kernel) or with unprivilged user namespaces enabled (the
> default,
> sigh).

Well, in principle I agree... still we get more and more such
sandboxing stuff (all the bubblewrap, etc.) and even if none of them
may give a 100% safe jail, if they help only in 10% cases it may
already be a win.


> > Sure, nftables is probably not the most likely program to be abused
> > (in
> > particular as it usually won't process untrusted input), but still
> > even
> > nftables can't be 100% sure to never be abused in something like
> > secretly included malware or so.
>=20
> In that case I think all bets are of.

Maybe. Though if you think e.g. about XZ, some distros were basically
safe for more or less obscurish reasons.


>=20
> Ok, if you want then feel free to start to send patches.
> (and CC Jan).
>=20
> I think that enabling CAP_NET_ADMIN restriction is fine,
> otoh if you think that this should be done then I believe
> its better to patch nft and not rely on systemd for this.

Well I as said, I have no strong desires to get any of that upstream.=C2=A0

For me personally, the patches from the first series (in particular the
one about not stopping on shutdown/isolation and closing the "pitfall"
of restart) would have been the ones I'd have considered the most
beneficial, but that was already conceived not so enthusiastically. ;-)


I can of course make patches if you really think some of this makes
sense (like e.g. CAP_NET_ADMIN), but then it'll be helpful[0] if you
could just tell me the numbers of the points from my original mail,
which you think are reasonable to even consider and which are way off.

And whether you rather want each set of related hardening options in
one commit, so you can easier pick (we can still squash shortly before
merging) or from the beginning larger patches.

But it shouldn't be considered as me trying to strongly push any of
that getting merged. If you say "no let's leave things as is", I'll
hold no grudge :-)


Cheers,
Chris.


[0] In that case, please keep in mind that some of the sandboxing
options make not much sense without some others:

E.g. ProtectHostname=3Dyes seems to be safely usable with nftables
(assuming it should never try to change the hostname), but if we don't
set (12) or even better run nft it as non-root, it's as per
systemd.exec(5) not really useful.

I tried to mention all these cases in my mail.
