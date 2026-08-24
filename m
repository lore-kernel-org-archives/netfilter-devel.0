Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0054345EAD;
	Mon, 24 Aug 2026 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787579242; cv=none; b=cIAQ0ceU8Ja3JT0Q+WIXLWxAc0dG4sHOBr1Lp50TLLgsaB0FsBkv2EerL4qhKXoEcdE+UyR81YB/RPjOIDBrT0kXAIrC6UKUdPsQvq0Svu2f96ensw5j/lfw+VwuD3hrWzm2Zmacz6Y3tYul6R/ecl9tMK05l9NYLNYWfCwAtoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787579242; c=relaxed/simple;
	bh=gsZth2D5w2+FUxwW8I64Md+XCABLbTd3Ip9I+dJOdTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNIwppMknUsz4/PVBjiiS9LODSVlTbNgt7dFGfp2OmTdwjJ4TXNMX/TW6bpTVXY10sAHRw7AoLuvGDYwkmfM3L8gD7lGGvowwiZmgWWJOi39U68dUOrxn3UEZCJII5AitQL5NzQ+OtJ/yE+xv2U1ldapd8uMvoFZMkFHEEQr0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=lUNgbKWE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kEBExeIA; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="lUNgbKWE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kEBExeIA"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id C786F1300075;
	Mon, 24 Aug 2026 09:47:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 24 Aug 2026 09:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1787579235; x=1787586435; bh=v0eOO8mP3K
	vc+I6zkuxDnQ7yn0ErBoVsdLcBQWhrggM=; b=lUNgbKWEU+TSOAdrRlhzdv2zIB
	IR/RZtTNW1RSkmZy8TgEcXyVse+i1WIGbr26kod86DfJwn/IW0OtF9x0SjluCQe5
	P8ZGu5oozI1iVddoWsNP4K0SabJqi9syhn0n7lBtGHQ+jUdeLIJZxnnQd2/ockNt
	culPcHq5MA49b8XGNX58prG6eICgjj1LOEAfBXZ3SBuCHd5x+4dUjWc3uTEjbQjk
	4xdtJqMyZ7zv2BIrlb7HKfNCfBOCW5LRL40Bjk8anuqjpNib8FZwNj+DbUmwW9cq
	Il36zG99CR4LUKQkbVtNnlCSf/ZxdGUKief2D8eWhdH6tjp9zifrjU3Qz23Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787579235; x=1787586435; bh=v0eOO8mP3Kvc+I6zkuxDnQ7yn0ErBoVsdLc
	BQWhrggM=; b=kEBExeIAqdjlMDEu3AlSrjSPTXocCpyKyKuodb4tLOeGZxli4ZP
	o4lU0fnOniSa+vzbx5n54/8qXzJFpxWfOmUDSmZIZAwAi+LepfgEdnIOdev/bmSA
	1mgv34rv+2qXTFz6Y5tiCvCjN/Hz2YZbDUY+exvThK976WVX0mUWHwY2i7QFcz7z
	EoIrddz/NJf8rdGozjNKM6qKPpkOVmwtw9MX9nJhSbMTa6KrcYStZUieANhXlvtp
	JPK8ZHKb9nlprgffrI5Ar4QpwKXE2kXoLb/rlnrmC2Yo811luC00P3bndOs93CLG
	QIoFNk6lew5S1nVN3TxxOMOPu61ON2lFCSw==
X-ME-Sender: <xms:YkuMaq6ALhlGHFuHpwfws93_iyMOTSNLYBBIRuhkiUMXUDbvO8kA5g>
    <xme:YkuMavlr1JlhmNiQVNcNz6PNZtjr8uiOX6Vc6LiIZJDm8xPMnkd8rp6VTk7OaE4uz
    658-hxl_CICFZyf1rxOYFuvKssY9Pa3H969BdVtu88J2Tt_-f4>
X-ME-Received: <xmr:YkuMatFMO4p4hb3BwWkVyUL9LcdQoDro1unhkJbk1FkZMPfLUhNB7YDrQqpukTexTSwrls4cQFhJrq9WMdPfDoDJWTBpQr5lW48bwksFAsQ>
X-ME-Proxy-Cause: dmFkZTEo1+qQ5pn1rPMdWCcaft2bSBaYbe5yoW99KucM5sbb0NM+N53s+3Q8UNHPVUoYEV
    swGT7AgHtJgWJs3OdNpJRcTo1LPOftAILAXRjyDdSzlJth+JxtnNXUUSGi3ReJRQhxi4bX
    lrpyjQNVSt5/+Ty/iwQdFIdzFwUqFadTnbVDYZd4Yek9WrgC9tXUMfbP0dS7SQMUHj+SuN
    Ugh46bDRiOICsRnjFVucUeAre8TZxDqm3i9ClfvaqMqKp8Fo0cJjoxiE/GONj6OLOT0x3f
    pMRqt5dUlgOvlGtwhXGjvnibfg36qySeC4L4LfWeuqwZb3k0PSFwfjspbWcQ6EKd6I/pH3
    4aau0ixZF4J/1YZsAKqhM33PzQhEn2erhtTEmyqRq/q/iYRtgOxOUo7zVcVd5rqrLNGLEj
    5Gt2wWMSbigmAjNGJlgwwB6+o/CRbO8I4r96I8imy3Trz/bjJF7Xvk23bA754Iay4ALhsX
    YM9AweG6uXx51e4mmqnN6qwXujQjngExUZ0K+Q+FWsv9epvHYRnUq/zKh1ZVr4I+YVFb0a
    jyagL4+OYQeU04oE0tPQgNlDLziCoWhKN4iAdAnUhb8zbYizp6HmQgCRPfDYRqa4Dc2unw
    BbtbaIZYMXarPxI5wWuIcVKcBfO66UVykrxciNpJJpLMfI15ezCTH3k81JSw
X-ME-Proxy: <xmx:YkuManZJ8R071JOU9mDSxBMfV6B2MTWwEsElzm_XoZfBxg7CX8V3KA>
    <xmx:YkuMasKQqn9gwrS5h3rTcSme0k-A1a2r7AixJ1gFGtjJHUkleYXbWw>
    <xmx:YkuMagyQtL1HArvfT92UQVds6Qh_EiRjYA2Hhl87Xe0dR1huV3RuRg>
    <xmx:YkuMak207O2KEwmnxN2A46K_Ay09DIR96YNbrenapmdPE0u9WXIhdw>
    <xmx:Y0uMaiN8O1Y--Kv4TSWRswfV9XD6_73-1VlymsJewVrmZUAZqsrebZRo>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 09:47:13 -0400 (EDT)
Date: Mon, 24 Aug 2026 15:47:09 +0200
From: Greg KH <greg@kroah.com>
To: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Cc: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	David Ahern <dsahern@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6.1.y 4/4] ipv4: start using dst_dev_rcu()
Message-ID: <2026082454-jacket-gravity-6ddc@gregkh>
References: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
 <20260821-cve-2025-40074-6-1-v1-4-cad5cf499b76@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-cve-2025-40074-6-1-v1-4-cad5cf499b76@bootlin.com>

On Fri, Aug 21, 2026 at 03:33:38PM +0200, Miguel Gazquez (Schneider Electric) wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]
> 
> Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.
> 
> Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
> ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().
> 
> Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ minor modifications to fix conflict, added rcu_read_lock and unlock
> to ip_defrag function ]
> Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

We need a working 6.6.y version first, before we can take this one.

thanks,

greg k-h
