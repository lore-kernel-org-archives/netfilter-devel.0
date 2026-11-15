Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784388;
	b=xlfOVcVD/EH+EJneaumzjvm1OQCREjFcT/wx+DggM8u9VeNuN3VO/KV27dW/R/1eqeWA
	 UGZshq4510p4kjb4awgiGoQccfJjfTiGM3ivsoGgy2dss987V8h6DuTkX0e0/W3YXvKpN
	 di5Bo6+vt9QK1qvJLrRHrSH75hmRXQ/eQP3VWrzSf+of7APutJ7XUOzlcJ6peCL72D3CB
	 7ipX7oqYO8Ioh1Bo0fXfhYNIHkvqk/3jIqUADDT7Z6IPoSH+bQAPaMlEDmSt3yJ/Af5ta
	 mnvdtnV00rH9Lmn5JfSnOzbTwn+GLgC2Osf0RIFp/bI0hwN37OlLJIR1sh1LFB82/oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784388;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=AZvjtH6H70KE39bWF+l9SI/XMWJOGMAp/FHL80ErtWU=;
	b=Mq34XZfoTZFaHo+SmMldDXHpBTICsmMDM65az+1XQF9/zAHSESJaUv4FwDswJ7q94xh6
	 1mm2hxm6fMZJKryO7BZTUt+2JXR3CLmyE963snR7Tpvo2vIpGquAuMoGt8mw7TuYhvvKK
	 wtx/kd44exLgd662+aA1q1GTBRUZ4semR+CD1eV7WGRbTvdx6Ada29riwB2ybmSoj1ojQ
	 XcwHZnIRG9HYzAoeBOdmyvaHEEwK3sqcdXQR0BYJqIe9j7tlksxxBix8H2zMz+id2/LXn
	 HhzMzk5TJ7Ttec0KfSWUDW/OIl9HsY2MY13m0InRw+wwZQgsz6VaEJYS33qzkrSc3Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gUhPa12I;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CB3A7606A323;
	Sun, 15 Nov 2026 23:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB3A7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gUhPa12I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794784378;
	bh=AZvjtH6H70KE39bWF+l9SI/XMWJOGMAp/FHL80ErtWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUhPa12IUp4JC2tSOOBn58UOFYI49T/jpnjOjq48fL1MFsGh670gnzRPNKJWR3zDt
	 68XI5rn/ZwKLHTbqh+irmToiDY80AdCs7rOtXQYbmr/zGNG2wZUQa37EoF86cZa/NW
	 uxdLNLBJR+soxumIHhOPeCBpWrBKFZH1OhkmDPuRskUZPdKH7DiNnY6oltFXI/gJZx
	 phvme3WvmTLhxeDUlFMkeDQKomUyndT+On2pDOItAa+jfiZJkCze/79IShUyzem8YM
	 S4jQ8kwODmGX5Qpa2342tDp9kPTnRhg4eWH8Wec/hGDVTzlutOJKQkWi9KmlNtCvlV
	 snlQwcmU6Pmdg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CE40760060;
	Mon, 16 Nov 2026 00:12:57 +0100 (CET)
Date: Mon, 16 Nov 2026 00:12:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: flowtable: do not hw offload
 flows in teardown state
Message-ID: <avo8doGLhLtsvSIV@chamomile>
References: <20261113031251.2437074-2-pablo@netfilter.org>
 <179462661878.2199510.10033227088688888386@kernel.org>
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
In-Reply-To: <179462661878.2199510.10033227088688888386@kernel.org>

Hi,

On Sat, Nov 14, 2026 at 03:23:38AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch only partly closes the packet-path refresh race.
> - [Low] The commit fixes a race found by an automated reporter ('Sashiko
>   reports...') but carries no Fixes:, Reported-by: or Closes: tag.
> 
> --
> 
> netfilter: flowtable: do not hw offload flows in teardown state
> 
> This commit makes nf_flow_offload_refresh() check NF_FLOW_TEARDOWN again
> after NF_FLOW_PENDING has been acquired. The goal is to stop the packet
> path from queueing a hardware refresh for a flow that is going away. It
> relies on GC skipping flows that have NF_FLOW_PENDING set, which came in
> with commit 7c549fb7eecd.
> 
> > Sashiko reports that refreshing hw offload from packet path is racy
> > since the flow might be already going away.
> >
> > Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
> > status bit"), GC skips flow entries that are still pending to be
> > offloaded. Let's just check for the teardown status bit after the
> > pending bit is set on to address this race.
> 
> [Severity: Low]
> This isn't a bug, but should this have Fixes:, Reported-by: and Closes:
> tags for the report?
> 
> The fix only works on trees where nf_flow_offload_gc_step() already skips
> flows with NF_FLOW_PENDING set:
> 
> 	if (test_bit(NF_FLOW_PENDING, &flow->flags))
> 		return;
> 
> That check came from commit 7c549fb7eecd. A stable backport to a tree
> without that commit would leave the race open.
> 
> Could the message record this dependency? Could it also state the
> consequence, which is offload work queued on a flow that GC frees, i.e. a
> possible use-after-free?
> 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 4365859220e6a..3a18fa48cadb0 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -1120,6 +1120,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
> >  	if (!offload)
> >  		return;
> >  
> > +	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> > +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> > +		kfree(offload);
> > +		return;
> > +	}
> > +
> >  	flow_offload_queue_work(offload);
> >  }
> 
> [Severity: High]
> Does this close the race for flows that are only in the NF_FLOW_CLOSING
> state?

This patch is intended to address the TEARDOWN race only as described.

> GC also sends a hardware DESTROY for a CLOSING flow while TEARDOWN is
> still clear. This happens in nf_flow_offload_gc_step():
> 
> 	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
> 		   test_bit(NF_FLOW_HW, &flow->flags) &&
> 		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
> 		nf_flow_offload_del(flow_table, flow);
> 
> On the packet path, flow_offload_refresh() is the only place that tests
> CLOSING, and it does so before PENDING is taken:
> 
> 	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
> 	    test_bit(NF_FLOW_CLOSING, &flow->flags))
> 		return;
> 
> 	if (test_bit(NF_FLOW_HW, &flow->flags))
> 		nf_flow_offload_refresh(flow_table, flow);
> 
> Could this sequence happen?
> 
> CPU B (packet path)
> flow_offload_refresh()
>   sees CLOSING == 0 and NF_FLOW_HW set
>   <stalls before test_and_set_bit(NF_FLOW_PENDING)>
> 
> CPU A
> nf_flow_state_check() on FIN/RST
>   sets NF_FLOW_CLOSING

It seems CPU A is also on packet path. Two TCP packets of the same
flow going through different CPUs is unlikely to happen. This also
assumes preemptible softirq, ie. PREEMPT_RT.

I will have closer look to search for possible issues with the CLOSING
state but that this patch is specifically aiming at the TEARDOWN state
only.

> GC
> nf_flow_offload_gc_step()
>   nf_flow_offload_del()
>     takes PENDING, sets NF_FLOW_HW_DYING, queues DESTROY
> flow_offload_work_del()
>   removes the rule, sets NF_FLOW_HW_DEAD
>   PENDING is cleared
> 
> CPU B resumes
> nf_flow_offload_refresh()
>   nf_flow_offload_work_alloc() wins PENDING
>   test_bit(NF_FLOW_TEARDOWN) == 0
>   flow_offload_queue_work() with FLOW_CLS_REPLACE
> 
> flow_offload_work_add() does not check NF_FLOW_HW_DYING or
> NF_FLOW_HW_DEAD. It installs the hardware rule again and sets
> IPS_HW_OFFLOAD_BIT.
> 
> Nothing clears HW_DYING or HW_DEAD after that. When the flow later
> expires, the teardown branch in nf_flow_offload_gc_step() goes straight
> to flow_offload_del() and sends no new DESTROY:
> 
> 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
> 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
> 				nf_flow_offload_del(flow_table, flow);
> 			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
> 				flow_offload_del(flow_table, flow);
> 
> Would the re-installed rule then stay in the driver and hardware after
> the flow and its conntrack entry are freed? Its cookie is the address of
> the freed tuple, so a new flow allocated at the same address could
> collide with it.
> 
> There seems to be a worse interleaving as well:
> 
> 1. GC reads PENDING == 0 at the top of nf_flow_offload_gc_step().
> 2. CPU B wins PENDING and reads TEARDOWN == 0.
> 3. GC calls flow_offload_teardown(). HW_DYING and HW_DEAD are already set
>    from the CLOSING DESTROY, so GC frees the flow through
>    flow_offload_del() without taking PENDING.
>
> Can the queued REPLACE work then run on a flow that was freed via
> call_rcu()?
> 
> The window is narrow. It still looks reachable on PREEMPT_RT, where
> softirq is preemptible, or under vCPU preemption. The FIN/RST that starts
> it comes from the network.

A follow up patch could possibly discard refreshing entries for
fin/rst packets, but this is unrelated to this patch.

> NF_FLOW_HW_DYING is set while PENDING is held, and it is published before
> PENDING is cleared. Would re-checking NF_FLOW_HW_DYING (and/or
> NF_FLOW_CLOSING) here, after PENDING is acquired, cover every state in
> which GC has already issued the DESTROY?
> 
> Later patches in the series don't appear to change
> nf_flow_offload_refresh() or flow_offload_refresh().
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
