Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958161;
	b=j3z3F41OiRuqvrFiG6dT363n6nKXifmGmct6N2P6SND34aLvdRJvIqOq+Juj5GH/2coS
	 zzWYgieIFGwmVAKevWVhM34j0Qc11sIUt36Qt+dm8A0aDgV2ea1y8xYFub6thBo+7DCVE
	 P8HMpzm76lD73r6eVHIwLMVZ5a8gA0kgBrdAAn120KfbK6IZkHz84uFMsn6dRJqU+Bg4I
	 mh33SbUFJgVEGOD7qdL+Nfeq2mtiWPcfvr8c8H4ceKLPJEsqrhqzCWexfFhG3gsEOg3Pd
	 gs47Nt+SbuRAKP6u10+Cvc0ocrFieYCPaVGCysMcGTKkf5RMKhX/cnYQyoTodLv02NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958161;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6l3YXXOGzefgjfKYki1kUCfxY/B6YsVZGiucocYAgdg=;
	b=XQcVwdMgwNsOqXbOOpm9oPJbnrqvDTgdg9vXjVR+12UPGE9q/2a7BcR9OxVorlq/7aJY
	 o3DOJ0ojpuLFqFElfbnIZFA+UA7N4nz+/CkzHaGhK8x8WJ+kib04UAuyMu+LCCNA0nnEo
	 Sa7BdkY95afMcyVUcfzMDOL/hv0O2KVvracyfxd+qzucuHw3hU3K4uMr8gj78xLU7o979
	 Et54uIWMoRFcMAy3wHgZCileu7hY3QVZD9DPUfS68q9KbbrJo8H94cFldH5K/4o+5fstR
	 NtqoU6KWmEXTxuZY1e/PYe1+JEXa/CRwflaqHjcoUmJ83t9K116S8++ztWzCCTtTrFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A18a/Unq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB8606A337;
	Tue, 17 Nov 2026 23:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A18a/Unq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048331F000C4;
	Tue, 17 Nov 2026 23:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958161;
	bh=6l3YXXOGzefgjfKYki1kUCfxY/B6YsVZGiucocYAgdg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=A18a/Unq3wxii+l9YzDXGE/+ENja4tS5EdEUKNIx3GdDGY8SdaGxOsyOriS2tNvxO
	 AWCkr0ugay/umI/Gx71FG7LjbrCVWlOC9P/5loP/UKVe0hBr+7fjxPNnt8/2kwyiAc
	 FQaFDjIpAYZzcLxzZb18cOSg7+4bpeSwRcMkcEc1DZhht7HhDf3miC0G9MjcBJow4X
	 hP5yIHTY/wSSxg7v895XNrTt2909uqW4ilNSNoxGmPE84nfSnTpbmn3VIYsZgzeZK9
	 wjcAAkeVQr4O8N0g0OBXQuT2kmUQ5eeewpNV8+HdglYz8g26dumcNrqmGumQibTALa
	 B5rbRYpczVO4g==
Subject: Re: [PATCH net-next 3/9] netfilter: flowtable: retain offload
 ownership until deletion completes
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, horms@kernel.org,
 corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 17 Nov 2026 23:29:19 +0000
Message-ID: <179495815956.3136.7417407587662864290@kernel.org>
In-Reply-To: <20261116222519.1416501-4-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-4-florian.fainelli@broadcom.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 4 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Moving IPS_OFFLOAD_BIT out of flow_offload_teardown() means
  the lockless check in nf_flow_table_extend_ct_timeout() can no longer…
- [Medium] This patch reverses the central change of the commit in its
  Fixes: tag but does not say so, and it does not mention the later…
- [Medium] The patch's ownership argument ('For hardware flows, GC
  reaches this point only after hardware deletion is complete ...…
- [Medium] The patch now releases IPS_OFFLOAD (re-admission) in
  flow_offload_del() once NF_FLOW_HW_DEAD is set, and the commit…
- [Low] The new KUnit test nf_flow_test_hardware_retirement() and the
  NF_FLOW_TABLE_KUNIT_TEST help text say they check that hash removal…
- [Low] The new Documentation/networking/nf_flowtable.rst text (and the
  commit message) list the visible side effects of keeping IPS_OFFLOAD…

--

netfilter: flowtable: retain offload ownership until deletion completes

This patch moves the clearing of IPS_OFFLOAD_BIT from
flow_offload_teardown() to flow_offload_del(), after both hash entries have
been removed. The goal is that a replacement flow can't be admitted on the
same conntrack while the old owner's cleanup is still pending. It also
documents the transient status and adds KUnit tests for the ownership
lifetime.

> diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
> index d757c21c10f2d..b9b4444357758 100644
> --- a/Documentation/networking/nf_flowtable.rst
> +++ b/Documentation/networking/nf_flowtable.rst
> @@ -205,6 +205,19 @@ refers to the software offload mode, so there is a distinction between [OFFLOAD]
>  which refers to the software flowtable fastpath and [HW_OFFLOAD] which refers
>  to the hardware offload datapath being used by the flow.
>  
> +During teardown, software fastpath lookups immediately stop matching the
> +flow. Packets reaching software follow the classic forwarding path, while
> +hardware deletion may still be pending. The OFFLOAD status
> +bit remains set until hash removal and asynchronous hardware deletion are
> +complete, preventing a new owner from racing the old owner's cleanup. As a
> +result, conntrack dumps can temporarily retain [OFFLOAD] or [HW_OFFLOAD]
> +and omit the TCP state after a FIN or RST has returned to the slow path.

[Severity: Low]
Is this list of side effects complete? Several in-tree users of
IPS_OFFLOAD_BIT now see the bit set for the whole GC and async DESTROY
window.

ctnetlink_dump_info() skips the timeout as well as the protoinfo:

net/netfilter/nf_conntrack_netlink.c:ctnetlink_dump_info() {
    ...
	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
	    (ctnetlink_dump_timeout(skb, ct, false) < 0 ||
	     ctnetlink_dump_protoinfo(skb, ct, false) < 0))
    ...
}

ct_seq_show() hides the expires field in the same way. As a result, the
repaired timeout mentioned in the next paragraph can't be seen during this
interval.

nf_nat_used_tuple_harder() also reads the bit as "entry is offloaded":

net/netfilter/nf_nat_core.c:nf_nat_used_tuple_harder() {
    ...
	static const unsigned long flags_offload = IPS_OFFLOAD | IPS_HW_OFFLOAD;
    ...
	if (nf_ct_kill(ct))
		taken = flags & flags_offload;
    ...
}

A torn-down TCP entry in CLOSE or TIME_WAIT that has gone back to the slow
path would now be evicted but still reported as taken.

The UAPI comment for IPS_OFFLOAD_BIT in nf_conntrack_common.h still says
"Conntrack has been offloaded to flow table", but this text redefines the
bit as ownership pending cleanup.

Should these effects be documented here too?

[ ... ]

> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 2aa2647ed9df0..4c82097cd50bc 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -393,12 +393,15 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>  	rhashtable_remove_fast(&flow_table->rhashtable,
>  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
>  			       nf_flow_offload_rhash_params);
> +	/* Release admission only after both hashes and async hardware state
> +	 * have gone. An older owner must not clear its replacement's status.
> +	 */
> +	clear_bit_unlock(IPS_OFFLOAD_BIT, &flow->ct->status);

[Severity: Medium]
The commit message says "For hardware flows, GC reaches this point only
after hardware deletion is complete" and "Holding the admission bit
prevents overlapping owners".

Can a datapath reader still queue a FLOW_CLS_REPLACE for this flow after
its DESTROY has completed?

flow_offload_lookup() checks NF_FLOW_TEARDOWN once. The later
flow_offload_refresh() only looks at NF_FLOW_CLOSING and NF_FLOW_HW:

net/netfilter/nf_flow_table_core.c:flow_offload_refresh() {
    ...
	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
	    test_bit(NF_FLOW_CLOSING, &flow->flags))
		return;

	if (test_bit(NF_FLOW_HW, &flow->flags))
		nf_flow_offload_refresh(flow_table, flow);
}

nf_flow_offload_work_alloc() is gated only by NF_FLOW_PENDING.
flow_offload_work_handler() clears that bit after flow_offload_work_del()
has set NF_FLOW_HW_DEAD. One possible sequence:

reader                      gc / offload work
flow_offload_lookup()
  TEARDOWN not set
                            flow_offload_teardown()
                            nf_flow_offload_del()
                            flow_offload_work_del()
                              set_bit(NF_FLOW_HW_DEAD)
                            NF_FLOW_PENDING cleared
flow_offload_refresh()
  nf_flow_offload_refresh()
    REPLACE queued
                            flow_offload_work_add()
                              set_bit(IPS_HW_OFFLOAD_BIT)
                            flow_offload_del()
                              clear_bit_unlock(IPS_OFFLOAD_BIT)
                              flow_offload_free()

After this, the re-installed hardware rule is keyed by a freed cookie, and
IPS_HW_OFFLOAD stays set on the ct. nft_flow_offload_eval() or act_ct can
then admit a replacement owner through test_and_set_bit(IPS_OFFLOAD_BIT).

With PREEMPT_RCU or PREEMPT_RT, the reader's RCU section could span
flow_offload_del(). Could the queued REPLACE work then use the flow after
flow_offload_free_rcu() has freed it?

The lookup/refresh window existed before this patch, but the new ownership
argument depends on it being closed. Later patches in the series don't
touch flow_offload_refresh() or nf_flow_offload_refresh().

[Severity: Medium]
Does NF_FLOW_HW_DEAD really mean the device removed the rule?
flow_offload_work_del() sets it unconditionally:

net/netfilter/nf_flow_table_offload.c:flow_offload_work_del() {
	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
}

flow_offload_tuple_del() throws away the return value of
nf_flow_offload_tuple(..., FLOW_CLS_DESTROY, ...), and
nf_flow_offload_tuple() skips callbacks that return errors.

A driver's DESTROY can fail and leave the rule programmed, for example
bnxt_tc_del_flow() after a firmware HWRM failure. In that case
flow_offload_del() still releases IPS_OFFLOAD and frees the flow, and the
flow's tuplehash[dir].tuple is the driver cookie.

Could a replacement owner then program a second rule for the same tuple
while the stale rule, with the old route or NAT, stays in hardware with no
way to delete it?

The ignored DESTROY result predates this patch. However, the ownership
serialization described in the commit message depends on deletion having
completed.

>  	flow_offload_free(flow);
>  }
>  
>  void flow_offload_teardown(struct flow_offload *flow)
>  {
> -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>  	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>  		flow_offload_fixup_ct(flow);
>  }

[Severity: Medium]
Without this clear_bit(), can the flowtable GC overwrite the timeout that
flow_offload_fixup_ct() just repaired?

nf_flow_offload_gc_step() samples NF_FLOW_TEARDOWN once and doesn't check
it again before calling nf_flow_table_extend_ct_timeout(). The only guard
left in the extend helper is the IPS_OFFLOAD_BIT re-test:

net/netfilter/nf_flow_table_core.c:nf_flow_table_extend_ct_timeout() {
	u32 ct_timeout = READ_ONCE(ct->timeout);
    ...
	if (!refcount_inc_not_zero(&ct->ct_general.use))
		return;

	/* load ct->status after refcount increase */
	smp_acquire__after_ctrl_dep();

	if (nf_ct_is_confirmed(ct) &&
	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
    ...
			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
    ...
}

That re-test now always passes until flow_offload_del() runs. Consider:

CPU0                                CPU1
nf_flow_offload_gc_step()
  teardown = false
                                    flow_offload_teardown()
                                      set NF_FLOW_TEARDOWN
                                      flow_offload_fixup_ct()
                                        nf_ct_refresh()
nf_flow_table_extend_ct_timeout()
  READ_ONCE(ct->timeout)
    /* repaired, below 5 min */
  test_bit(IPS_OFFLOAD_BIT)
    /* still set */
  cmpxchg(&ct->timeout, ct_timeout,
          now + NF_CT_DAY)

CPU1 can be the datapath after a failed dst check or a missing outdev, act_ct
on FIN/RST, or nf_flow_table_cleanup() on netdev events.

The refcount, smp_acquire__after_ctrl_dep() and re-test sequence from
commit 03428ca5cee9 depends on teardown clearing the bit before
flow_offload_fixup_ct() repairs ct->timeout.

flow_offload_del() doesn't repair the timeout again. A UDP flow with no
further packets would therefore keep its conntrack entry for NF_CT_DAY
instead of seconds or minutes.

Doesn't this contradict "TCP state and timeout repair run at first
teardown" in the commit message? Later patches in the series leave
flow_offload_teardown(), nf_flow_offload_gc_step() and
nf_flow_table_extend_ct_timeout() unchanged.

[Severity: Medium]
This undoes the main change of the commit named in the Fixes: tag:

    Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")

e5eaac2beb54 moved this clear_bit() from flow_offload_del() into
flow_offload_teardown(). The reason was that conntrack gc could race to
undo the packet path's timeout adjustment, leaving the entry with the
one-day offload timeout.

Moving it back looks safe on mainline only because commit 03428ca5cee9
("netfilter: conntrack: rework offload nf_conn timeout extension logic")
removed this block from gc_worker():

	if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
		nf_ct_offload_timeout(tmp);
		...
		continue;
	}

03428ca5cee9 has no Fixes: or stable tag. Suppose this patch is backported
to a stable tree that has e5eaac2beb54 but not 03428ca5cee9.

Wouldn't gc_worker() then reset ct->timeout to now + NF_CT_DAY during the
whole window from teardown to flow_offload_del()? flow_offload_del() would
then clear the bit without another repair. For closed TCP and expired UDP
entries, that brings back the bug e5eaac2beb54 fixed.

Could the commit message say that it reverts part of e5eaac2beb54 and
depends on 03428ca5cee9?

[ ... ]

> diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
> new file mode 100644
> index 0000000000000..378a1c60b50b9
> --- /dev/null
> +++ b/net/netfilter/nf_flow_table_core_test.c
> @@ -0,0 +1,86 @@

[ ... ]

> +	flow_offload_teardown(flow);
> +	/* nft_flow_offload must not admit another owner during async DESTROY. */
> +	KUNIT_EXPECT_TRUE(test, test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status));
> +	flow_offload_teardown(flow);
> +	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
> +	/* Model completed hardware deletion before the GC removes the hashes. */
> +	clear_bit(IPS_HW_OFFLOAD_BIT, &ct->status);
> +	set_bit(NF_FLOW_HW_DEAD, &flow->flags);
> +	rcu_read_lock();
> +	flow_offload_del(&table, flow);

[Severity: Low]
Does this test cover the ordering it describes? The Kconfig help says
"Require hash and asynchronous hardware deletion before re-enrolment".
However, the only code that makes deletion wait for hardware removal is in
nf_flow_offload_gc_step():

	if (test_bit(NF_FLOW_HW, &flow->flags)) {
		if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
			nf_flow_offload_del(flow_table, flow);
		else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
			flow_offload_del(flow_table, flow);

This test sets NF_FLOW_HW_DEAD by hand and calls flow_offload_del()
directly, and flow_offload_del() reads neither flag. If the
HW_DYING/HW_DEAD gating were removed or broken, neither case would fail.

Both cases also use IPPROTO_ICMP, so flow_offload_fixup_ct() returns
immediately. The TCP state and timeout repair at first teardown is never
exercised. nf_flow_test_teardown_repeat() only checks that
flow_offload_teardown() no longer touches IPS_OFFLOAD_BIT.

Later in the series the Kconfig help is reworded to "Test flowtable
ownership during asynchronous hardware deletion", so the gap seems to
remain in the final state.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
