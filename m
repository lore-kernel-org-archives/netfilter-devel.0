Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539827;
	b=et6uoLEQNYALTduyUpsgrIfWQTiifPagsROqd6IWsIxRe1QfiiaQESh3jid8DcagM7ui
	 dOz1HO97SYjLHh1oU8XtcS0dTEbRq0pky9rF+lT/xp2PCdna5yAPdv3QOlVcXLdFFWmaS
	 kqWH3kAiPFcgtHHOJG1agelBfdnfcITmYGiyzoC3uGYVYcZw7IFSXjNmpwC3U0ZKWVpgo
	 1ZRPZ5v10/FLEc696vIBIRA7e/arV6WZwnP3WUhWUWiPGUvt2rNtR5lzgOQvsLn4DeVkL
	 7tuqv86pDyGc+REP4kI7GQlm6HHvNzK2igiHpcFrgoQxEenSIaboR/AaH2mnb/HhIkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QRKjoaIFdZcdNI6xhQFS3ddkteDcVtqc9gdnFl/fkT8=;
	b=Kl8VuaQpUoGgHAQ+fa9S3b6ieiuVjaewUp8ySL0pusBZuT95CBwJRipYbJPjxKsD4cs2
	 iuJcl+TDOJyxJo0BlIy0hw1H+kJbm7VUAhhlfxkLFFEB6Z4EoZk+UDQbOTtXojYirQYIu
	 Al1TXNNtQUxfUL5oehZaWpNdWXj58QP5HbVzLImaPjo8DtJpHijQso1SXM1MnHHHdqVVY
	 gs6mHruRnju9NQa2usJslfL/uWRk58ws/CrRZDGGvEYfB/DAIthsmsDlnf0co4PMp3JTm
	 X0bdHykBPxCb4ZsTcy0qIvdjzGvY9fDIoiDhozaI2FpWWBoOcyTbP/A3CVQlZVJUlrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JHqt0GGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70229606A323;
	Fri, 13 Nov 2026 03:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JHqt0GGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660121F000C4;
	Fri, 13 Nov 2026 03:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539827;
	bh=QRKjoaIFdZcdNI6xhQFS3ddkteDcVtqc9gdnFl/fkT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHqt0GGOy76IEMUTS3P6IoC7hWETzpJ86b+UqgWqBeFLTXZHwPeRo2TTi6xwZolmp
	 FsC9sMoZkIQzOZol/qt6QJEC+Mh8WZlDoVpVy1CTisKEk3eONnMKsvHb8xS+GXZ+Hh
	 kevhrKPtucfL07dxTI/Fq5AkByIorhUL4f9zJ1UlrOLFkPiO6MonIo+jlwYoi5UoBe
	 OWdtd2kWhrCPgZeOaU6sxchhnmdQ7UTsdL6AggfEo+iXSI1NgOKzNAxqEAi9AEkhA9
	 FoOoux6FZuxMSzgEEhb7W/VfipI4t3HADbOICEBbB8annNmqm+TbBIrWZJ3gN1dsrb
	 yHnxcXfCUpDcg==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: flowtable: do not hw offload
 flows in teardown state
Date: Fri, 13 Nov 2026 03:17:05 +0000
Message-ID: <179453982588.2168702.434281488157747833@kernel.org>
In-Reply-To: <20261113031251.2437074-2-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
 <20261113031251.2437074-2-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
