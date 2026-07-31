Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64FF3D8115;
	Fri, 31 Jul 2026 10:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785494013; cv=none; b=UW7uyd8G/WFmhuLIcHDJSbnLGFg4p7BFAyizBj+nN6ZMIe72+fUfK0+rCkFwspleKgTGsZnBeFMhwomuRaDVcq9YM9SE8l7uoigq4qig533/AeFSw7aj4oH98bhLEon/mjH2kCmGwVKFkD8+s2dcRyLYKsIUhTOUx08FKr3+D68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785494013; c=relaxed/simple;
	bh=lg1W+14p/dbYu6+/0qsIx1se9B4QGspSqqLSW4ptzL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQxrztnEppENZ8ljqb3KTtRZAia10h9OZEI6DXVC2WxCiPNuJ6stJqcdYI9YlJSU9+0HorFpLbEQa6+kGtTfXS1smi5NlUzA17OfAJ/AUtPV8QO/UgBuvTmfC2zg30IseOT/r2WQp8PRtGHdIbC4HZYry6I+Wm/hfN8Bm/lv61U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qEIChmlE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qEIChmlE"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 26D44601A5;
	Fri, 31 Jul 2026 12:33:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785494003;
	bh=LqekADnHQRu9/VRdBdO1Czahfx/0OfCGP11ku6HDC5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qEIChmlENuIt/40gWHOS+K9RNHfeh4CKlRAb2Jd1X18MO9x9A6twGjg5dJOJPi0uQ
	 KR4x5xM9Q2Fcxepa4/+z7Mtf8r9mzYm2QMc6jytGrtfbiDEV9zI3iNlUNsJT+pcw/P
	 /wT8ex2JoS6zwuTGJfeCa9+t4mWE+kO8Jog5SXRDf7FRzefLnzHMslqukdOsfZ6m/P
	 B31WuEeQKf7uDLCuD31zLv9HlZ02EyDJfcAi/j19gsCYhrJhbRo+SRkhWLZ5Q9c2+h
	 73dqirup2dCB5RLE8EBQENAbBFlvwwnWZb/BurZGVWaYdug5+3f2hkjpwuzKVuw2oM
	 AqDNWItwRQ/pg==
Date: Fri, 31 Jul 2026 12:33:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>, Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>
Subject: Re: [PATCH nf] netfilter: conntrack: sctp: verify vtag before state
 changes
Message-ID: <amx58O5Jb6B29XDJ@chamomile>
References: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>
 <amkCbQ1UDRKcZBez@chamomile>
 <AD2FFF7F-7EC3-4205-BB44-508B31BC2620@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AD2FFF7F-7EC3-4205-BB44-508B31BC2620@mails.tsinghua.edu.cn>

On Wed, Jul 29, 2026 at 12:56:39PM +0800, Yizhou Zhao wrote:
> Hi Pablo,
> 
> Thank you for the review.
> 
> > On Jul 29, 2026, at 03:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > Hi,
> > 
> > On Tue, Jul 28, 2026 at 03:35:06PM +0800, Yizhou Zhao wrote:
> >> The packet-wide vtag check in nf_conntrack_sctp_packet() is skipped when
> >> the bundle map contains any chunk type with special vtag handling.  The
> >> per-chunk path re-checks INIT, ABORT, SHUTDOWN_COMPLETE, and
> >> COOKIE_ECHO, but other state-changing chunks still fall through to
> >> sctp_new_state() without validating sh->vtag.
> >> 
> >> This lets a wrong-vtag packet bundle HEARTBEAT with COOKIE_ACK, ERROR,
> >> SHUTDOWN, or SHUTDOWN_ACK and still advance conntrack state.  That can
> >> desynchronize conntrack from the real SCTP association and cause denial
> >> of service for SCTP traffic behind a stateful firewall.
> > 
> > Are you assuming a specific policy in place? The connection tracking
> > does not police packets, it just provides tracking.
> 
> You are right, I overstated the impact.  Conntrack only tracks packet
> state, and whether a packet is dropped depends on a firewall rule that
> uses that state.
> 
> > 
> > Can you provide a more specific scenario?
> 
> The issue I reproduced is that a wrong-vtag [SHUTDOWN, HEARTBEAT] bundle
> changes SCTP conntrack state from ESTABLISHED to SHUTDOWN_SENT, while the
> SCTP endpoints discard the packet because of the invalid vtag.  This can
> therefore desynchronize conntrack from the association.
> 
> For example, a stateful policy that drops INVALID, accepts
> ESTABLISHED/RELATED, and accepts new SCTP only for INIT will see the
> conntrack timeout change from 210 seconds to 3 seconds.  If the entry
> expires while the real association remains established, a later DATA
> packet is invalid and that policy drops it.  This requires an attacker
> that can inject a matching SCTP 4-tuple into the firewall path, and it does
> not require knowing the correct vtag.
> 
> > 
> > We are seeing several reports related to the connection tracking from
> > your university lately.
> > 
> >> Check sh->vtag before processing those chunks when conntrack already
> >> knows the expected direction vtag.  This keeps the existing
> >> HEARTBEAT/HEARTBEAT_ACK learning and connection-reuse behavior for the
> >> `vtag == 0` cases.
> > 
> > Proposed patches to hardening the connection tracking state machine
> > should be targeted at nf-next.
> 
> I agree this is better treated as SCTP conntrack state-machine hardening.
> If you agree, I will respin the patch for nf-next without Fixes or stable Cc.

Yes, repurpose this patch to nf-next without Fixes tag and stable for review.

Thanks.
