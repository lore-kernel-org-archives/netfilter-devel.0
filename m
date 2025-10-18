Received: from eastern.birch.relay.mailchannels.net (eastern.birch.relay.mailchannels.net [23.83.209.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC2417C91
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 22:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760827859; cv=pass; b=JgWUrrCHaI4BpMEzxa1BdJ/TkAQzETtO2SyjwtSvkViDDR/qnLRBMLtxb4BlgU8Mr1vzmjkYFMrOru+eETUoN7IAm93KcT+jNXTluRaLjw206h9ubj/zi4nKIM6wBP13kp0lxTF0jfKH3oOXHkGv8a4a2MFDxclHqKd8AgqZpe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760827859; c=relaxed/simple;
	bh=zRszs/Er/8r+1aRFTuOqK8msj+F3B+fdQHbZkGAaJa8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uYH1D6dZvk3IbaVl3zX8CbjTLOzmzRsEuQ8qfRyFQnK7olihdnAsPaPAc0GO4eV50LT2zsAAWZ+J0n24BUEkx6ebXHL1sHZ3mr1Fq5axksUf7zSDgKSPCkYvxI9s8A9nYWj4/CGxZMg+7V+w0TYl6+zH6vv3Ur9ORhWpBJIJ94Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=T3bNaDMf reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.209.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="T3bNaDMf"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 294AA8E0D53;
	Sat, 18 Oct 2025 22:13:40 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-0.trex.outbound.svc.cluster.local [100.121.87.184])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 241C28E136C;
	Sat, 18 Oct 2025 22:13:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760825615; a=rsa-sha256;
	cv=none;
	b=4rwOnMGsOnQ8G/4n9g75KguD+CktpoDSPsu36FW15Z0o26uti9mt6XcslL6AMOAK6OhZfb
	r4TO7z4fqe5ohYSGoNnhb9kwhniOMbNQUHNAlPmFct7n7njNvqWG1UZgnGnEB5H13dY6uH
	9GJCIv4nXVqBMXVz/vSgdiwcIpbHzvfskfZySsvFgN/XScuQQalWrYxPgg8X3nNoheQqHW
	XsgsAYVGvxndy+H81rafvO0R8+cIui00K/9rqdhtqTickYWKTiSi0MO05Q0en/qsWrxiDA
	t5xIZfKEd/s554nvVP5ek+lGEXTcETTCPS3+LiJybzrUBwJyY/PqMBwuuJtlCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760825615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRszs/Er/8r+1aRFTuOqK8msj+F3B+fdQHbZkGAaJa8=;
	b=Gj/2/2EKUH9Efuk0Eg6gmXA9mT7L0Brnai+OMKqYfdzHFRGp/PMWf5fFxju4vmVtd8NpXC
	h6FmUWz2qqYjVbQUgak3o6J9OkQ2/mSOHRovUpAsdLJdfuu/cjGQ3tdMddh5W+nxaF9xOm
	ET/f6fvu/EWWFhlSXx0Xg3raVe1ZBm6EMNjpGJjX4A6wrhT3OB4K35o5+EaAC+Zf90Vhis
	+Xx0C244OE9JeXrvz10w2w3qbIr2rjFiQf7kCDfQ0BSiR1d3GrbVduoKtLnzqO0tF+VVpW
	lyWNh89dM5eB8TTWvRpHiA5TohJPhwmFVrPwigaUbpinoJW7R28jH25+GZQP5Q==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7ffz2;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Imminent-Bottle: 34ceeaa53505635e_1760825619997_3685960290
X-MC-Loop-Signature: 1760825619997:234952047
X-MC-Ingress-Time: 1760825619997
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.184 (trex/7.1.3);
	Sat, 18 Oct 2025 22:13:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=zRszs/Er/8r+1aRFTuOqK8msj+F3B+fdQHbZkGAaJa8=; b=T3bNaDMf5YgT
	3S88hnyv/z09BDiGHT7C/B6/dQC3WvuHg+e+Fo9Fj4nHRTUHKEnF6Sb29ttZrjSOrLdBKArb3gnPA
	JLiCORdA1Jf9+yOUBGNLY8comk8ZIaKn5oRKfZVpc+meTuJ/MqQDpTyHZEadGcKyckHX8zBXXA4zj
	zlg6q/sVSTRhNQUKGHO439Pxh2GXr7OQeDYeP/N294yzRURwFCsrGZpP/GWM2t3E6VrgJK8YuDXsV
	+A9Lsu0/w7m/FCTi+YmPaWGbFdsg6J8yBKPRPiT5vPc/3kwD0gEUo2arAmrDkFVT2rKvWZKTx2s67
	vDR84gsSAky+BHn+KNNaNw==;
Received: from ipbcc0feaa.dynamic.kabel-deutschland.de ([188.192.254.170]:62873 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAFB9-0000000Cb0F-2rY2;
	Sat, 18 Oct 2025 22:13:33 +0000
Message-ID: <2691b0512674a9dd0e5979e50b4a737249f05193.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 6/7] doc: describe =?UTF-8?Q?include=E2=80=99s?=
 collation order to be that of the C locale
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Sun, 19 Oct 2025 00:13:31 +0200
In-Reply-To: <aPOXob5BUPRLIjjH@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-7-mail@christoph.anton.mitterer.name>
	 <aPOXob5BUPRLIjjH@strlen.de>
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

On Sat, 2025-10-18 at 15:35 +0200, Florian Westphal wrote:
> Pablo, whats your take on this?
> I wonder if libnftables should force POSIX locale.

One thing perhaps to add,...

At the Austin WG there=E2=80=99s a request[0] to standardise the C.UTF-8
locale.
There=E2=80=99s no real progress yet (at least none that would be public), =
but
given that all world switches to UTF-8, and C.UTF-8 is already the
reality for many systems... I guess that might sooner or later happen.
Of course even if it would it=E2=80=99s not clear whether POSIX=E2=80=99 C.=
UTF-8 would
match glibc's.


Still... *if* nftables does something in that matter, maybe it should
go straight to C.UTF-8?

I'd guess LC_COLLATE (which is of interest here) is safely different
fro the two versions (C uses strcmp(), C.UTF-8 uses wcscmp()).

OTOH, not sure how well things would work with C.UTF-8, if people would
use non-UTF-8 filenames for included files.


Cheers,
Chris.


[0] https://austingroupbugs.net/view.php?id=3D1548
