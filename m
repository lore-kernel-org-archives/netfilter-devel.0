Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794649659;
	b=wmyYsAiKE1akr/rg93tZCl5V6DZpMxBr4ADlNptqJ753sCJQYZISYzPjoZfyu76es4L/
	 y4hrRDhhSJ2zBGbsrVtlBIYZmXTVtB751eALVgd9Fq89YmBhTzqqKMIuL3CWgXsj+HPxV
	 TeGFRPoNfbxdD85lFsjFymqa4WLWHsM/35bc+y9wDhy9EZpDdDL495NJZJJUsOuRNTuwq
	 7vHXwXwaJxW0V4LGAOpbmgubLQOndVmTOm0fk7ANXPBS/VIm60EQGiShQ4mfSstZj8Ko1
	 4BGD3REtzgd3YeYzdPuBC036Xh3xCooW8XKnCt/vtLAnymS0Za5G2dXAQ/3FDkB5BRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794649659;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=PTY1o7j7L5nX7oMObMEPbTXGH2Y/CuCX5bnofZ59I48=;
	b=Nhy099poo/5z1DA+hatWu18ugCAA/gypR+LVPdk8tuFsVcdXql8OH1ECNktpX/Sf26Pd
	 h15VhHYbW7Dlf3LAys+WyM1oM7MMKpbeetX4rU4n4EzbjypuczLTxVt5Y11vgA8wXTmT5
	 l+Tsm1Ls5j/jKdm4Na7TC7GlZ16K4iNcqleXt5HBz4ay8t+iAWGIEeuxjiSu11rApKkjV
	 AQlpR6c8zvjFgiGz1PhEb095Z0ctb6qCfaLTEB1xXqkQnNYPaas5FYffw1U3pZbaBDKOL
	 NqgqBcBX6ukvOMVe+sB5EDUDns5PKtarSQhueI0W/jKdQz/viVr8N5fDaFYukrJ60Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=s6oNpMlq;
	arc=none smtp.remote-ip=195.10.208.40
Received: from mout-b-210.mailbox.org (mout-b-210.mailbox.org [195.10.208.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F302E606A327;
	Sat, 14 Nov 2026 09:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F302E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=s6oNpMlq
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-210.mailbox.org (Postfix) with ESMTPS id 4jRTnL2sTRzFqbv;
	Sat, 14 Nov 2026 10:47:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794649654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTY1o7j7L5nX7oMObMEPbTXGH2Y/CuCX5bnofZ59I48=;
	b=s6oNpMlqY5TOV7G82Irnq1EDMUVG13acT8vn2wqkq1tMD7NBwCQRx2xY/R9xsQL1kHxWvo
	sxKMJfS/rFD7Gr3id9jDnz7lsZ7oNmec1Z4YaatiCh9rTkAaOs9VcfFBcNy+TABu+AuTCr
	HI3Tasu6gs8gwNWPGct2JI3PWuRbBcIKgCZ6a1BZxkE7RWy7ZyQGCmTw8gswsfQClQc5H8
	v0Qb6LjjzAcimuTnD0/6+t1F66yjkXy40FSmqpUsgLC7N+oMLbSY+Q71VvBP2juKT8zzP1
	OyiDIX+cZPNak7kGmmRilFxc+YjoEu9CXRmeueLh8PAuEvu/E03D4qEmQSV4QA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: Xavier HSINYUAN <XavierHsinyuan@outlook.com>
Cc: antonio@mandelbit.com,
	bgalvani@redhat.com,
	coreteam@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	dxld@darkboxed.org,
	edumazet@kernel.org,
	fw@strlen.de,
	horms@kernel.org,
	idosch@nvidia.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	phil@nwl.cc,
	toke@kernel.org,
	xavierhsinyuan@outlook.com
Subject: Re: [RFC net-next v2 00/18] net: introduce ipxlat stateless IPv4/IPv6 translation
Date: Sat, 14 Nov 2026 10:47:21 +0100
Message-ID: <20261114094722.114623-1-ralf@mandelbit.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <TYTPR01MB11000E65B4D5C27C27D7414B4CA762@TYTPR01MB11000.jpnprd01.prod.outlook.com>
References: <TYTPR01MB11000E65B4D5C27C27D7414B4CA762@TYTPR01MB11000.jpnprd01.prod.outlook.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4jRTnL2sTRzFqbv

On Fri, 06 Nov 2026 22:17:57 +0800, Xavier HSINYUAN <XavierHsinyuan@outlook.com> wrote:
> Hi Ralf,
>

Hi Xavier,

> Thanks for your v2 series!
>

Thanks for the review.

> Here is a question about netfilter hooks in ipxlat-lwt. In RFC v1,
> netdev-based ipxlat allows POST_ROUTING rules to be applied for
> original-family before translation. Currently LWT path translates first
> and does not check nf_hooks_lwtunnel to optionally run original-family
> POST_ROUTING before translation.
>
> Is this difference intentional since it keeps LWT path simple and leave
> such cases to netdev path, or would an optional pre-translation pass in
> LWT path also be worth considering?
>

Actually v2 has no netdevice attachment any more, the LWT is the only
harness in this series.

Aside from that, yes, the difference you describe follows from the v2
contract. The selecting route terminates original-family processing, so
that family only sees PRE_ROUTING (received) or LOCAL_OUT (local), and
FORWARD/POST_ROUTING/LOCAL_IN run in the translated family only. That is
indeed the first open question in the cover letter.

Looking into it again, there seems to be two concrete problems with that
contract:

- original-family conntrack entries are created at the entry hook and
  never confirmed, so stateful rules in that family see replies as new
  or invalid and a conventional ct state established firewall drops
  them;
- SNAT in the original family before translation is not possible, which
  rules out NAT44 in front of a CLAT and the NAPT66-based NAT64 recipe
  from the v1 documentation.

So I do not consider the current behaviour settled.

nf_hooks_lwtunnel is one way to add an original-family exit hook, and
seg6 is a good precedent for the hook placement. I am less sure about
the gate itself because it is global, cannot be switched off again, and
is off by default, so the default configuration would keep the problem.

Two alternatives I am evaluating are calling the exit hook
unconditionally, and moving the translation point to the LWT xmit stage
so the original family completes its normal path. I will come back with
a concrete proposal and a per-hook table.

Which setup do you have in mind: SNAT before translation, filtering, or
accounting?

-- 
Ralf Lici
Mandelbit Srl
