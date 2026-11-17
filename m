Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794912641;
	b=2ePgWrnXfQ/rEnrmVNnGBndjMj3U2AOMY2nQX/RhoT5A7vYvslWNf92eW6JET+JQmrRQ
	 jzqDK5UhikMXL3cILPXyAFkMp5SSuuN/7zaiUhUgDEHOP/mfOnmwfYyfBKphOBoY8tFrg
	 Jznvntr6FIUK3zBc3HcXzarftwd92ZhsGKmNl4E3H3S5erVphMKws0ZzonNstLm20oBUd
	 Savjbon6smdja9LBGe8fJcZodNzM5T4oGjdIgghsuv2Vi7H21Zeh2AokXrGM59TBxB6g0
	 3o1AElSAmJaOaqsybnmamc9/topAwrGKBK6yJUjJP+f4VL7Eh+NLN0mEcY63YeAzjMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912641;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=HOulvh/frrmuKu3RAxzKr1qTMmiBK/clrbfOmAZBfXI=;
	b=mpalyUl722OUrl+PhoW68ub1kQu/yhs/eoINyoxtLgiB4iwO5UkmTlItsN0RTMQRRB2c
	 bRJxy2qLUsCquz30iO+5/ug/2nGR175QYhzqIHVCPK9at2AtJ/ieAVOguqQ3rK1RR7EKa
	 grm7t/7D4o01ooaZQyS+iZfOQ4SQjFmiPzXluq3waqQceBw+i2UbSxBtcY95JmcuyHq6O
	 elJJIS0ZIr3cO/4Xn1F797NUVwT2ImZQ0veeEek50LM47ctjiIQqRKMoClotVjY23SZam
	 p7fuLfAAbfmRiT80XXsF3GjV1D/qlhJSodYckU3+lbRopP8UoUCHGzAniFz0IwdtSGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=obPCjd9e;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CF606A31C;
	Tue, 17 Nov 2026 10:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD0CF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=obPCjd9e
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id D047C21B52;
	Tue, 17 Nov 2026 12:50:36 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=HOulvh/frrmuKu3RAxzKr1qTMmiBK/clrbfOmAZBfXI=; b=obPCjd9eRopl
	CeesWKhUyinYoB/1F+EssY0ZCNuknYofU5M4/NrTMwJHb8sFEADHtJIRen7wR5D6
	2VwSLDePha3oGU60rCYAvP1oM4n1WYMe2b0KupvnIuJNN9EOinD4E+3vGS0ID0yo
	xChXImtEqP2CAbGqlkpwF4vE7aDoE9A+16fqH3hFYGhvod+VFyMLEwZfUM0Co9lu
	YGxZxyHPsVTaNKsrQ0LmAEpncuABtWzmJAZSKD2+9RY51Nh1si9MvTMuUGKQSKOH
	aP59poXXPfhImQWTg+VajoVz7ZMUFrHk1MVBlUvi9hiuIUu1jUvV+d0BywbgUs1e
	OWVPSM3FbFIO7DoWCoCwIyhIfNHuVe622FGwm7xQO0QnFjfZWcdgQajn7/WbuVvg
	kD/vnNW2bUwMZ3iGI098Hynrz6p5fucGtyJqkxa/xJ2LRFH4EUg6y5+Z0YTDuM66
	dEjefglW2X84b3Tob5SwOpUjH/W7hvpsZgkeyOwq0mDuGGC+h4UKpIrgTUQSb3mL
	2J9nYqyj1Up63EPuxj7ruhCChyr7uPbWnvSHI3G75faVAI8oGNZ8G1uIFihK8ehX
	PItYo33TZcUEsOQ/tTGBFFqGZjNlj2bKKaAvykLTFwkIvkxQHkehiSJq5a64+2gy
	bnlHP/2gRhGdwUHOACU5XA1qQEfa5a4=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 17 Nov 2026 12:50:36 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 368A160356;
	Tue, 17 Nov 2026 12:50:36 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6AHAoXdj029351;
	Tue, 17 Nov 2026 12:50:33 +0200
Date: Tue, 17 Nov 2026 12:50:33 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Paolo Abeni <pabeni@redhat.com>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
        horms@kernel.org, fw@strlen.de, netdev-bot+sashiko@kernel.org
Subject: Re: [PATCH net 10/11] ipvs: do not create conns from packets with
 port 0
In-Reply-To: <39940277-ffc1-4ede-a9d0-605ba0f8ad3c@redhat.com>
Message-ID: <e4ac303a-b86d-1c8c-9c45-1f6d93d748d6@ssi.bg>
References: <20261116004404.2821183-11-pablo@netfilter.org> <179487963329.3136.11227226787276094605@kernel.org> <39940277-ffc1-4ede-a9d0-605ba0f8ad3c@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-952026072-1794912635=:8727"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-952026072-1794912635=:8727
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Tue, 17 Nov 2026, Paolo Abeni wrote:

> On 11/17/26 02:40, netdev-bot+sashiko@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issue(s) to consider.
> > 
> > Critical: 0 · High: 0 · Medium: 1 · Low: 1
> > 
> > If you believe none of the issues are legitimate, please reply to each
> > issue of Medium severity or higher and explain why the AI is wrong.
> > If any of them are legitimate and you plan to respin, please let patchwork
> > know by including "pw-bot: cr" as a separate line at the end of your reply
> > (one such reply per series is enough).
> > 
> > - [Medium] udp_conn_schedule() (net/netfilter/ipvs/ip_vs_proto_udp.c) now
> >    drops every UDP packet with source or destination port 0 that matches…
> AFAICS this is the only new/unaddressed comment in this revision.
> 
> @Julian: could you please have a look?

	RFC 768 allows source port 0 for one-way UDP but
due to the NO_CPORT usage we do not allow it. I assume
server port 0 is not allowed because we can not bind on
port 0. That is why vport 0 is disallowed too, only for IPVS
traffic.

> Likely no additional revision needed, a confirmation this under control
> would suffice.
> 
> Thanks,
> 
> Paolo

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-952026072-1794912635=:8727--

