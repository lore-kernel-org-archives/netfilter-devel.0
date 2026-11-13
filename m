Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794540246;
	b=gcIgAVSs8rXUrvIv7O5O6HzUbOquRRbAK8/LEvetdJbPk72AqLKy9j/RqfD65R1wC9AM
	 dU5weTAJEye4u/GyWno+b+vYi/5chiNgZAO5b1dqo3EcyPlgyqaDqTwUIE7EPXLrdRiU2
	 Clc/QJ1msjZPXqV6vEarse39JuuhQXoMBx3YK8oYPsuq59smYqKXEFKOy5MSGeFWLOVlG
	 r0F0rY7UZj0GIIZCfeFw8j/y86T/YicEcvelxElg6/DYm29SiPrZl0V4qOOCB1Gmsv6bD
	 gMKQ/U424QMBsqVZv+qZSN5g7xNtmLeCYlz4VuBigaP4xGyn2oeUV18Dcn7ph215PsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794540246;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=r72rP2oLT4zT09yMIEBKGgs71HhgXzGMvm2dEiYeCFA=;
	b=gEvUWOleJAmTJCCIF0w15yCnLaypHCq5ylBPont72V2Lsp2O+LyDPP0ScDCSqfKvAyB+
	 WwOR5awB1AsJKLodoQ3v+OohBLFU1Gmvm01jUrN7PDJ0BvPIPxlXwXZR5l0a26nQzJfHL
	 YDaS1PXqKsjQbK6qyZUGZafPNQaJfLEIcAOmZFQFf+5jrHcznMETW3LmJJZNA72s8cdMK
	 eRdpokIQRljlteqgYYwFIflp9bJZPUDqWLSEqwjTAdGGWUs20I4dHKhHXQBRg2tfk4AWV
	 gr8ZEHt8qm7pwZlnXjcZMEi2+RFTfCtH2B/GuGw5T+SMKq0bNLbFZh/80Qwtg+XlLdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=aOS4Ponj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C49CC606A321;
	Fri, 13 Nov 2026 03:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C49CC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=aOS4Ponj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794540243;
	bh=r72rP2oLT4zT09yMIEBKGgs71HhgXzGMvm2dEiYeCFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOS4PonjN22OncF3nzoYUSFRPzr416/ILrI/0g1WJ+q9HH2AQUlCZsJStYia/rbvY
	 caadaSux80juVamnkRmZnf5PzZoxATdyuHQ42Dl3rwBhIpTMLJFW7MKXcbD+j1dDl4
	 UJCc134PO06UWK78ws0zcfmF2FiqvGecoAl3hqi7wND6r+9Pt2aF48BhB+0R57r5JR
	 q6zJzdZF4mn2/kXrURKK0IRLj+r/BnJHp2J4L2P28z7f85wh2Sqp4n4m2DZLMTyfPq
	 nU0kDlMAOEiP4VWsXV4qyyi4gHhJbW/CCg3Bzfd9gxhs0jriw6J3BlIFy811BXqhLn
	 dEHxr4HNgwMVg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 630D86005C;
	Fri, 13 Nov 2026 04:24:03 +0100 (CET)
Date: Fri, 13 Nov 2026 04:24:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: flowtable: do not hw offload
 flows in teardown state
Message-ID: <avaC0HXnXTfLBBnb@chamomile>
References: <20261113031251.2437074-1-pablo@netfilter.org>
 <20261113031251.2437074-2-pablo@netfilter.org>
 <179453982588.2168702.434281488157747833@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179453982588.2168702.434281488157747833@kernel.org>

Hi,

On Fri, Nov 13, 2026 at 03:17:05AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
> 
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

This is a pull request for nf-next. It mixes fixes and new work, so
here is the information per patch:

- "flowtable: do not hw offload flows in teardown state" and
  "lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non
  init-netns": reported by Sashiko (LLM review, theoretical).

- "flowtable: retrieve stats on flow deletion" plus the mtk_ppe and
  airoha updates: reported by Valentin Berezhnoy on netfilter-devel
  (link in the Closes: tag). The last stats sync with conntrack is
  missed on hardware flow deletion.

- "flowtable: tunnel device poisons h_source of fast-path frames":
  hit in production on a DS-Lite setup (ip6tnl over PPPoE over 802.1Q
  VLAN). Every offloaded TCP/UDP flow dies because the PPPoE endpoint
  drops frames with the wrong source MAC.

- "xt_time: fix monthday computation for dates past 2039":
  theoretical. LLM keeps banging on this as an issue, so let's
  address it.

- "nft_flow_offload: do not offload multicast": this was most likely
  found in production.

- "flowtable: do not clear the offload bit twice": Found while
   developing a new driver supporting the flowtable.

- "nfnetlink_queue: make skb writable before writing NFQA_L2HDR":
   LLM finding.

- "flowtable: purge entries immediately when destroying the
  flowtable", "flowtable: do not scrub as crossing netns" and
  "flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()":
  LLM findings too.

- The two selftest patches add a test and fix a clang warning. They
  are not fixes.

Thanks.
