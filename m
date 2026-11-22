Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795382246;
	b=P7Wxl6byJkFlvZQaUCgRZ47MlAL4ZSPCvWgMNnPAHj5afWr8/tCFj0MxXOUerOhQE22L
	 Zd07LIocIxNJX6/2Q7/aX9dU2iiBxb6KIbGxSEy6yO510QCbDaQ83YZhkZd+ARcEeLQzO
	 H4/l/8Yo+5ZZzRrtMVMZlvuGzGlqkrqsnqFMIh+4+2Pp4taDYLkK0ovWn8I6vFVgi/lNc
	 x9AXo9f/bwzHeJG0qjbjd1wUDmoszXWdtoQyozBXa6C8m9vkTXO9TbXlhbvBJFE90gH+k
	 cu/y4PZG6NUNfO1fRBeA7uuBQx2tfuaDhmwoh50FYVkZJNBvmYJ9WUg1nlNEQ6rPZNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795382246;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=wRYkt/8bNJ83BACxmsyULTPzgzoASxC6Ha6Jh0WjC7A=;
	b=djIljtAJTsGhxpRYWLZekoajM/KDERRdjYwY2v7NDLlCdRC0+vzDaNBPIikzWlyu7ijm
	 FjlxSU9dMLKPDzzE8NxQkMrXEMOgkPhWyBd693DIbTluMzkm/noDdqizx3HPicw7Dxo2q
	 tMe5qec1gVUsaE6Sxv2fWqHjnxRyt1evB/FWietT8dB+rcjTIpYSEJanVVP4LowyIkw2m
	 LztGlsuSGmEkOn6cF+tfUvBrvG8PyVLkKXD3F/hPbOFagRHcUDoIXU4vcJ/F7LDktWhaf
	 6VtGuPMd4ZVvGDun83a+WF/H9lZDT/O+kjtKWS2cGilhHCQFSae14WITpu5J9DzV3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIuYE0bU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E158A606A31A;
	Sun, 22 Nov 2026 21:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIuYE0bU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50C81F000CA;
	Sun, 22 Nov 2026 21:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795382245;
	bh=wRYkt/8bNJ83BACxmsyULTPzgzoASxC6Ha6Jh0WjC7A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WIuYE0bUeVh7j/c1tgbS8K7qmz+PGL4nSuV/JONTuW33K7yFbi2NGfmizYXYOwafi
	 JA+MwHWxErlgc6mrZyIqiGsgfk3I2U4B5VjWTH+vaSi2vvsMZybYLWWhLL/UC/QzHk
	 YlHwcmLGb14znJdpbxCyPXT0kh0Gz/VgpcN9+ThZj1PNL7vPXwYM/SFRyfF8rGuZk6
	 5OilF8sZ+iWuAd7Us//Utc027aBFPDob3yimedL8MaIghJ+codIQTo1sfC8TFAXwLN
	 6P/fpcBrLX2vxr43cAR/Em08metddXH4ctFZZe1WF3OxTbEfZ8EGOXczhmuBiMNO9/
	 9sXw1OITOSvnw==
Subject: Re: [PATCH net 1/4] netfilter: flowtable: do not queue offload work
 after DESTROY
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, shuah@kernel.org, toshiaki.makita1@gmail.com,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Date: Sun, 22 Nov 2026 21:17:24 +0000
Message-ID: <179538224441.3135.6950839726802616846@kernel.org>
In-Reply-To: <20261118201250.2075007-2-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-2-florian.fainelli@broadcom.com>
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

- [High] The new NF_FLOW_HW_DYING guard in nf_flow_offload_work_alloc()
  (net/netfilter/nf_flow_table_offload.c) does not close the bug class…
- [Low] The commit message describes the race mechanism and the affected
  work types imprecisely.

--

netfilter: flowtable: do not queue offload work after DESTROY

This patch makes nf_flow_offload_work_alloc() refuse to queue any work
other than FLOW_CLS_DESTROY once NF_FLOW_HW_DYING is set. The goal is to
stop a packet path reader from queueing REPLACE work for a flow that GC
is already removing, because the offload worker could then use the flow
after it has been freed.

> once the DESTROY work has run and cleared the bit, a reader can take it
> again and queue a REPLACE (or STATS) work for a flow which is already
> being removed.

[Severity: Low]
Is the STATS part accurate? The packet path only reaches
nf_flow_offload_refresh() through flow_offload_refresh(), and that queues
FLOW_CLS_REPLACE.

nf_flow_offload_stats() has a single caller, nf_flow_offload_gc_step(),
and GC skips any flow that has NF_FLOW_PENDING set:

	if (test_bit(NF_FLOW_PENDING, &flow->flags))
		return;

GC also never runs concurrently with itself. So STATS work that GC queues
cannot race with GC freeing the same flow.

For STATS, the only effect of this patch is that GC stops queueing STATS
for CLOSING && HW && DYING flows whose hardware rule DESTROY has already
removed.

> GC removes a hardware flow after NF_FLOW_HW_DEAD is set, and frees it after
> an RCU grace period, which the reader can outlive in a preemptible RCU
> read-side section.

Could this be worded more precisely? A reader cannot outlive a grace
period that started while it was inside its read-side section, because
the call_rcu() in flow_offload_free() waits for it.

What outlives the grace period is the REPLACE work that the reader queued
on nf_flow_offload_add_wq before rcu_read_unlock().

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6a..62f460d38efa2 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1088,6 +1088,19 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>  	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
>  		return NULL;
>  
> +	/* GC only removes a hardware flow after its DESTROY work has run, and
> +	 * NF_FLOW_PENDING keeps another one from being queued, so nothing can
> +	 * free the flow while this work is pending, unless DESTROY was queued
> +	 * before we took the pending bit. A reader which found the flow before
> +	 * it was torn down must not queue more work then, as the flow could be
> +	 * freed before that work runs.
> +	 */
> +	if (cmd != FLOW_CLS_DESTROY &&
> +	    test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> +		return NULL;
> +	}

[Severity: High]
Does the claim that "nothing can free the flow while this work is pending"
hold for flows that GC frees through its software-only branch?

flow_offload_add() publishes both tuples in the rhashtable before
nf_flow_offload_add() sets NF_FLOW_HW:

net/netfilter/nf_flow_table_core.c:flow_offload_add() {
    ...
	err = rhashtable_insert_fast(&flow_table->rhashtable,
				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
				     nf_flow_offload_rhash_params);
    ...
	nf_ct_refresh(flow->ct, NF_CT_DAY);

	if (nf_flowtable_hw_offload(flow_table))
		nf_flow_offload_add(flow_table, flow);
    ...
}

In that window, nf_flow_offload_gc_step() can decide to tear the flow
down while NF_FLOW_HW is still clear. The teardown can come from a dying
ct, a stale dst, or NF_FLOW_TEARDOWN set by another CPU after a FIN/RST
arrives on the already-published REPLY tuple. GC then takes this branch:

	if (teardown) {
		if (test_bit(NF_FLOW_HW, &flow->flags)) {
			...
		} else {
			flow_offload_del(flow_table, flow);
		}

That path removes the rhashtable entries, releases the dsts and calls
call_rcu() on the flow. It never takes NF_FLOW_PENDING and never sets
NF_FLOW_HW_DYING.

The creating CPU then carries on:

CPU1 (creator)                       CPU2 (GC)
flow_offload_add()
  rhashtable_insert_fast(REPLY)
  rhashtable_insert_fast(ORIGINAL)
                                     nf_flow_offload_gc_step()
                                       teardown, NF_FLOW_HW clear
                                       flow_offload_del()
                                         flow_offload_free()
                                           call_rcu()
  nf_flow_offload_add()
    set_bit(NF_FLOW_HW)
    nf_flow_offload_refresh()
      nf_flow_offload_work_alloc()
        test_and_set_bit(NF_FLOW_PENDING) succeeds
        NF_FLOW_HW_DYING clear, new check passes
      queue FLOW_CLS_REPLACE

Suppose the work runs after CPU1 leaves its RCU read-side section and the
grace period ends. Would flow_offload_work_handler() then use the freed
flow in flow_offload_work_add(), in nf_flow_offload_alloc(), in
set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status), and in
clear_bit(NF_FLOW_PENDING, &offload->flow->flags)?

If the work runs earlier, it seems it would still install a hardware rule
for a flow that is no longer in the table. GC would never DESTROY that
rule.

That is the same use-after-free and stale rule outcome the commit message
describes. As far as I can tell, no later change in this series touches
this path.

Would it make sense for GC's non-HW branch to claim NF_FLOW_PENDING, or
set a dying marker, before freeing the flow? Another option would be to
set NF_FLOW_HW before the flow is published.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118201250.2075007-1-florian.fainelli%40broadcom.com
