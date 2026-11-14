Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626619;
	b=DzpykmbcugD6LNnQfzQ5v7HFz/wmAtvTWfE3YaiAgGxN+zP/IPmABdnL8fX1eTl2olJs
	 vNtsAM/E5LlRzgDXS7Q9mcAjQQpEUK7tsSpOMOBEqRPAxvaR1GSkJKeSZmfis/5bIFWXe
	 QzhBGONA/M0OgonsiQHfV6eGp0W2dCfUDHjq8qq6uDVrBL8dAoVK9UIc1YjW03OM2Zkn3
	 tKbHuHThHivsNPcmKPYCApImpfEHFyP5bPfupa4TvRC7StRyGi0O/H1vw8mhQBOlj+aR2
	 cukl9/tvIxDm9jXysHiaOTaftSZx9SaKuHf8KmlDOGzWuDeYfZ0v2UdMOBNOKZ43eSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626619;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qBIvOvOA603roCB7Rre/75gvv3F6mY8loL0odoti8E4=;
	b=heVyyzjo5P8oV1tqg1KIXFRrnpPda51QxPF5I5yxVuTgx75VeB+sQRSPw7EcA3va7ioS
	 o2VDdOrxolwDE1ZJ6D9hp4mp33seOoqrV4SmsaQ1G3xkVUmLKfADIjOpTqq8KuVI/c9PW
	 Tdb6vZ9yjB+5go6oJZCSEc7h+VPznkOmgv+chURK/3NLKsoFPe2jxOXEffTmImTqB2YfB
	 ZBp11i/urYtkU/oSm+0GOiGfwe3DKSIxD8QLBrBsoW2WMnaesJEjys6P1Q2gr6T5+0pq+
	 flf368ghDClMUCVANQ1W7RzG6IekRSZYNRbiRtgsb3fJKNKls89OrqrJGClqM0Idbaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eiMy+n/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5485606A330;
	Sat, 14 Nov 2026 03:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eiMy+n/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315C71F000C4;
	Sat, 14 Nov 2026 03:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626619;
	bh=qBIvOvOA603roCB7Rre/75gvv3F6mY8loL0odoti8E4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eiMy+n/BNDwYAeDNlNYNeZIjof5AUFzWsZy5gA2IFzfVZmvtIZAQX19JmbU+6Gxnb
	 lyz4tyj3IRj4Esx4NsX2NKSutZr5/mxvLijsiq9+e7EkSHxTD3nLGing63XANhYE8M
	 HkcBNfy6DkDA/eaUWaNRInSAYxrOY17pegwjYbCvItM173/WaYHcO9vD+ikfGqok6V
	 8DH9eAq+DccJqdk3/PhXo/hA2ViTYYH0hiCB3gQXMpGq59lcNreEGc+MWr3s5jk7Xe
	 felTZk85/33izXrQ6Gj+JT38SCZ1KnU/PBvKD8WvY3xDREhLZLTAqca25V9Agb+nds
	 OxdBNpP0F1dFQ==
Subject: Re: [PATCH net-next 01/15] netfilter: flowtable: do not hw offload
 flows in teardown state
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:38 +0000
Message-ID: <179462661878.2199510.10033227088688888386@kernel.org>
In-Reply-To: <20261113031251.2437074-2-pablo@netfilter.org>
References: <20261113031251.2437074-2-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch only partly closes the packet-path refresh race.
- [Low] The commit fixes a race found by an automated reporter ('Sashiko
  reports...') but carries no Fixes:, Reported-by: or Closes: tag.

--

netfilter: flowtable: do not hw offload flows in teardown state

This commit makes nf_flow_offload_refresh() check NF_FLOW_TEARDOWN again
after NF_FLOW_PENDING has been acquired. The goal is to stop the packet
path from queueing a hardware refresh for a flow that is going away. It
relies on GC skipping flows that have NF_FLOW_PENDING set, which came in
with commit 7c549fb7eecd.

> Sashiko reports that refreshing hw offload from packet path is racy
> since the flow might be already going away.
>
> Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
> status bit"), GC skips flow entries that are still pending to be
> offloaded. Let's just check for the teardown status bit after the
> pending bit is set on to address this race.

[Severity: Low]
This isn't a bug, but should this have Fixes:, Reported-by: and Closes:
tags for the report?

The fix only works on trees where nf_flow_offload_gc_step() already skips
flows with NF_FLOW_PENDING set:

	if (test_bit(NF_FLOW_PENDING, &flow->flags))
		return;

That check came from commit 7c549fb7eecd. A stable backport to a tree
without that commit would leave the race open.

Could the message record this dependency? Could it also state the
consequence, which is offload work queued on a flow that GC frees, i.e. a
possible use-after-free?

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6a..3a18fa48cadb0 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1120,6 +1120,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
>  	if (!offload)
>  		return;
>  
> +	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> +		kfree(offload);
> +		return;
> +	}
> +
>  	flow_offload_queue_work(offload);
>  }

[Severity: High]
Does this close the race for flows that are only in the NF_FLOW_CLOSING
state?

GC also sends a hardware DESTROY for a CLOSING flow while TEARDOWN is
still clear. This happens in nf_flow_offload_gc_step():

	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
		   test_bit(NF_FLOW_HW, &flow->flags) &&
		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
		nf_flow_offload_del(flow_table, flow);

On the packet path, flow_offload_refresh() is the only place that tests
CLOSING, and it does so before PENDING is taken:

	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
	    test_bit(NF_FLOW_CLOSING, &flow->flags))
		return;

	if (test_bit(NF_FLOW_HW, &flow->flags))
		nf_flow_offload_refresh(flow_table, flow);

Could this sequence happen?

CPU B (packet path)
flow_offload_refresh()
  sees CLOSING == 0 and NF_FLOW_HW set
  <stalls before test_and_set_bit(NF_FLOW_PENDING)>

CPU A
nf_flow_state_check() on FIN/RST
  sets NF_FLOW_CLOSING

GC
nf_flow_offload_gc_step()
  nf_flow_offload_del()
    takes PENDING, sets NF_FLOW_HW_DYING, queues DESTROY
flow_offload_work_del()
  removes the rule, sets NF_FLOW_HW_DEAD
  PENDING is cleared

CPU B resumes
nf_flow_offload_refresh()
  nf_flow_offload_work_alloc() wins PENDING
  test_bit(NF_FLOW_TEARDOWN) == 0
  flow_offload_queue_work() with FLOW_CLS_REPLACE

flow_offload_work_add() does not check NF_FLOW_HW_DYING or
NF_FLOW_HW_DEAD. It installs the hardware rule again and sets
IPS_HW_OFFLOAD_BIT.

Nothing clears HW_DYING or HW_DEAD after that. When the flow later
expires, the teardown branch in nf_flow_offload_gc_step() goes straight
to flow_offload_del() and sends no new DESTROY:

		if (test_bit(NF_FLOW_HW, &flow->flags)) {
			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
				nf_flow_offload_del(flow_table, flow);
			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
				flow_offload_del(flow_table, flow);

Would the re-installed rule then stay in the driver and hardware after
the flow and its conntrack entry are freed? Its cookie is the address of
the freed tuple, so a new flow allocated at the same address could
collide with it.

There seems to be a worse interleaving as well:

1. GC reads PENDING == 0 at the top of nf_flow_offload_gc_step().
2. CPU B wins PENDING and reads TEARDOWN == 0.
3. GC calls flow_offload_teardown(). HW_DYING and HW_DEAD are already set
   from the CLOSING DESTROY, so GC frees the flow through
   flow_offload_del() without taking PENDING.

Can the queued REPLACE work then run on a flow that was freed via
call_rcu()?

The window is narrow. It still looks reachable on PREEMPT_RT, where
softirq is preemptible, or under vCPU preemption. The FIN/RST that starts
it comes from the network.

NF_FLOW_HW_DYING is set while PENDING is held, and it is published before
PENDING is cleared. Would re-checking NF_FLOW_HW_DYING (and/or
NF_FLOW_CLOSING) here, after PENDING is acquired, cover every state in
which GC has already issued the DESTROY?

Later patches in the series don't appear to change
nf_flow_offload_refresh() or flow_offload_refresh().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
