Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713502;
	b=4+rah1LdaXX2uXc6nhYWqrTzY4xgWxGU/+AOeApwAZHsqQvTUmeTq1SEcAvXTf9WdJq4
	 oM27WYtRgsKsOUiX8dsUPcL3+oUUmOsQ3bVEBOyXit/U0GwVCWlm7LHqVYv+xVjJ1pQIQ
	 iAKNNYN0iRQsVQGEOZF+21PCwe1tVpwZrO98KBUsyAy+obkAVMOlLM09eagCrrXQe4dmm
	 N4Bb2tL3GOtPvEav6q0weQeAbqZpelKrFCl+mYDK9dh77Zwr7+nvgilkJIUUS6dgmvGPN
	 /4fhJXSZLuGPWWRRSWVi2ZACbFTsi7i0k5rTEJtmS9Wgqav8NbY2/c/f6CSbSq1iYzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713502;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=YYUG0/HYuu3hCbwYk3TWOdmodhVdeh1TclE1MGJkXVg=;
	b=MV25s8/RSMupgOC392Lg7wybzqNM7fA56IjQzuU6dSYPUtSFZkU/JpCHQP1s6AYdJAMh
	 Zyw+Ypf7mikTrQRJ+v9X4wmVt0c/EG/Rq8p8BBkMY5TjnEhZlYOZoGQTXw/oRxdbvHWNy
	 w/QGr5Du+TumORdDp2+onkCSmduYJc9Wc34lfg2B8BflsR+SiIjv62+ZMdQgVlP3bzimB
	 uAriAklqT0Q4zGUgkDaLmE+JO2m9Nfzs58bFxtIk+h4K8rWHltCP/xPt2lr9fXc05A5H8
	 7U8+nq1ra8FYXt5VCH+YijhVU4mGnkx5vSsYlqgUPDEbqZ4le/zFyQu8+AwvvP053kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hTF1Wzg6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3FD3C606D80E;
	Tue,  3 Nov 2026 13:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FD3C606D80E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hTF1Wzg6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793713497;
	bh=YYUG0/HYuu3hCbwYk3TWOdmodhVdeh1TclE1MGJkXVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTF1Wzg6+QY87G1hKWB0tPOMYzzVD4K+U7QAgyCeSebkpiMLa556p1Uni/HMKxYy6
	 Pwn4aY2wdWsQj7fIAAEGuz7KoNjh1sqI5NRC0zO2qLU0+ILHFc/BU2VSgR27Q3nGeh
	 HeF0jwqUpX9PYaXI3yvMLi5HGkKboW4lt0nCNAXOe62rufJghfV8oUVBNK+ig94Luw
	 spyBx5HJONeJwnFfmMwQsXuEGheK8yePidks4U+O1ZC4BeW8pXgzUOKkw7I+wtX4zz
	 V0yuIwiMwqbu4SVnjj8rsCYNqqQvwMm51nVXk/cDIhuRuZR6FulboMbfBEcy1T7Uzm
	 Eu9K6U+om2rXA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 504F760058;
	Tue,  3 Nov 2026 14:44:57 +0100 (CET)
Date: Tue, 3 Nov 2026 14:44:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
Message-ID: <aunlVk2Cn7ocgANE@chamomile>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
 <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>

On Tue, Nov 03, 2026 at 01:27:30PM +0100, Matthieu Baerts wrote:
> Hi Paolo, Pablo,
> 
> On 03/11/2026 13:04, Paolo Abeni wrote:
> > On 11/2/26 01:56, Pablo Neira Ayuso wrote:
> >> Hi,
> >>
> >> The following batch contains Netfilter/IPVS fixes for net:
> >>
> >> 1) Add recursion count to nf_reject infrastructure to prevent stack
> >>     overflow, from Fernando F. Mancera.
> >>
> >> 2) Address a infinite loop in RCU list traversal with the TWOS IPVS
> >>     scheduler, from Darong Lu and Julian Anastasov.
> >>
> >> 3) Use kfree_rcu() to release IPVS parent application to fix UaF,
> >>     from Chengfeng Ye.
> >>
> >> 4) Fix UaF in IPVS netns removal path due to releasing per-net protocol
> >>     data too early, from Chengfeng Ye.
> >>
> >> 5) Fix unbounded growth of stale, unmatchable IPVS connection entries,
> >>     from Julian Anastasov.
> >>
> >> 6) Restrict maximum master conntrack chain depth in ctnetlink,
> >>     from Florian Westphal.
> >>
> >> 7) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
> >>
> >> 8) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
> >>     is reachable, from Michail Andreas Michalopoulos.
> >>
> >> 9) Check non-null gc transaction in nft_rbtree before queuing it for
> >>     processing, from Xingyuan Mo.
> >>
> >> 10) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
> >>      nf_conntrack_bridge which is reachable if the protocol of the tag
> >>      of a frame differs from the vlan_protocol of the bridge.
> >>      From Laveesh Bansal.
> >>
> >> 11) Check x_tables target name is non-null before accessing it when
> >>      building a new table, from Fernando F. Mancera.
> >>
> >> 12) Fix out-of-bound memory read in nf_conntrack_sip, from
> >>      Joas Antonio Dos Santos.
> >>
> >> 13) Fix a memleak in nf_tables hardware offload when double deleting
> >>      the same rule, in the same batch.
> >>
> >> 14) Use a mutex in xt_recent netns exit path instead of spinlock,
> >>      since proc unregistration might sleep. From Cen Zhang.
> >>
> >> 15) Zero the nf_nat_range2 struct before filling it up, to avoid
> >>      using stale uninitialized stack data to configure NAT with
> >>      an esoteric NAT flags combination. From Florian Westphal.
> >>
> >> Please, pull these changes from:
> >>
> >>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
> >> nf-26-11-02
> > I'm sorry, but something went very wrong on the nipa side: the tools did
> > not pick this PR. Do you mind repost it verbatim?
> 
> It looks like the patches have not been tested, because of the kdoc
> issue on patch 6/15:
> 
> https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build/1198360/14931104/kdoc/stdout

I routinely run checkpath.pl, I will re-check what happened here.
