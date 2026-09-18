Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32582F691D;
	Fri, 18 Sep 2026 02:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697054; cv=none; b=tq4nLS+vwPW7oOX+uUEGi3k0S+TBw5fbWVGrTc14PmRvO4UT03rT8PhwIQrPgRDHFX9BC0kif7zhnPWJyfEVs+iGVAbI+ZE77k3UR441SJ+d8PB9kxzW9gTTqnGV2Q/p45NO5MDy/Lu274W56x6Ly+0rjnk6Q4Bz/Ox1r3y4cMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697054; c=relaxed/simple;
	bh=SklnJMzU9xhwH2hkN3mxEtueI33xAi07xEU5FvWNXQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFAY94Qw8GEvEnQYSdMqLcpf3pHOyPtYr3wUgjC04TfKDkBkVpSW+Zq0RwEI+hri42MXdIlKk5qm55MP75hM+6qaI6POxbJaM2diswVIZmcqv3qvJfkXKrg2nfM6T9wEObqFMRgF205xZv7CCMWhPAP9SPllGmPNMWZSLOubq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCk2zL1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCk2zL1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CB41F000FF;
	Fri, 18 Sep 2026 02:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789697048;
	bh=xXPNbX5sk/MdW61YvEujNeVn2inSeucEYANNsVkGgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCk2zL1z8CVmAf5q8cQSAnLy6ur3PIkimUC+MkgRKvHyfWBHMd7DOkSwxODKb0JKI
	 DAHJJ2NlItWXMHog/fH/j+OgA74Bs0HbS0+B62HuUJSwc8IyogSWVeJ1DxlPewQRU5
	 poB4QSdX2TpZ5xlVX7FSPIAzM04gybUwfSp/rq7ZOUyR1lFR1rdcyYemC5pSqLqDoP
	 +v614Ax55lB2V4A1yrLOoYD3g/hnIMZkepcfCWfBQLuW9e3/yZ1tZPu10MFhPERmI4
	 MwL+XySSFGKUdVej3o8c8Ynp9QgUSp0vl3AicOB/qygT43GFPk4Rkp5ydxGGxKEJsw
	 51Puum6VfBReg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 01/10] netfilter: flowtable: publish HW_DEAD after worker is done
Date: Thu, 17 Sep 2026 19:04:06 -0700
Message-ID: <20260918020406.3513303-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231652.127456-2-pablo@netfilter.org>
References: <20260916231652.127456-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: flowtable: publish HW_DEAD after worker is done

The patch moves the NF_FLOW_HW_DEAD publication out of
flow_offload_work_del() into the common epilogue of
flow_offload_work_handler(), so that it happens after
clear_bit(NF_FLOW_HW_PENDING) rather than before it.  The stated goal is
to make setting HW_DEAD the last flow access performed by destroy work,
so garbage collection cannot free the flow while the worker is still
touching it.

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 801a3dd9ceea3..6757fd89c1f1a 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>  		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> -	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }
>  
>  static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> @@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
>  	}
>  
>  	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
> +	if (offload->cmd == FLOW_CLS_DESTROY) {
> +		/* Publish after the worker's last flow access. */
> +		smp_mb__before_atomic();
> +		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> +	}
> +

[Severity: High]
Does this reordering close the whole use-after-free, or only the
FLOW_CLS_DESTROY part of it?

The new invariant ("setting HW_DEAD is the last flow access") only holds
for destroy work, but nf_flow_offload_gc_step() in nf_flow_table_core.c
relies on the flow being idle for all commands.  It decides to unlink and
RCU-free based on the flag bits alone and never looks at
NF_FLOW_HW_PENDING:

net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
	if (teardown) {
		if (test_bit(NF_FLOW_HW, &flow->flags)) {
			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
				nf_flow_offload_del(flow_table, flow);
			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
				flow_offload_del(flow_table, flow);
	...
	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
		   test_bit(NF_FLOW_HW, &flow->flags) &&
		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
		nf_flow_offload_del(flow_table, flow);
	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
		nf_flow_offload_stats(flow_table, flow);
	}
}

Is the following sequence still possible with this patch applied?

A FIN or RST sets NF_FLOW_CLOSING without NF_FLOW_TEARDOWN in
nf_flow_table_ip.c:nf_flow_state_check():

	if ((tcph->fin || tcph->rst) &&
	    !test_bit(NF_FLOW_CLOSING, &flow->flags))
		set_bit(NF_FLOW_CLOSING, &flow->flags);

gc then takes the CLOSING branch above, nf_flow_offload_del() sets
HW_DYING plus HW_PENDING and queues FLOW_CLS_DESTROY, and the destroy
worker now publishes HW_DEAD while the flow is still linked and TEARDOWN
is still clear.

From then on the CLOSING branch is skipped (it requires !HW_DYING) and gc
falls through to nf_flow_offload_stats(), which only checks the timeout
delta before calling nf_flow_offload_work_alloc().  That helper gates
purely on the pending bit and stores a raw flow pointer:

net/netfilter/nf_flow_table_offload.c:nf_flow_offload_work_alloc() {
	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
		return NULL;
	...
	offload->flow = flow;
}

so a FLOW_CLS_STATS item can be queued for a flow that already has
HW_DYING and HW_DEAD published.  When TEARDOWN is later set (expiry, a
dying ct, dst check failure, nf_flow_custom_gc, or a SYN on the CLOSING
flow), gc matches teardown + NF_FLOW_HW + HW_DYING + HW_DEAD and calls
flow_offload_del() -> flow_offload_free() -> call_rcu(), regardless of
the outstanding stats work.

Can the stats worker then write into freed memory?
flow_offload_work_stats() does:

	offload->flow->timeout = max_t(u64, offload->flow->timeout,
				       lastused + flow_offload_get_timeout(offload->flow));
	...
		nf_ct_acct_add(offload->flow->ct, ...);

and the epilogue in this hunk still unconditionally runs
clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags) for every command,
after flow_offload_free_rcu() has already done nf_ct_put(flow->ct) and
kfree(flow).

Is there a similar window for FLOW_CLS_REPLACE?  flow_offload_refresh()
filters only NF_FLOW_CLOSING, not TEARDOWN, HW_DYING or HW_DEAD:

net/netfilter/nf_flow_table_core.c:flow_offload_refresh() {
	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
	    test_bit(NF_FLOW_CLOSING, &flow->flags))
		return;

	if (test_bit(NF_FLOW_HW, &flow->flags))
		nf_flow_offload_refresh(flow_table, flow);
}

so a datapath thread that looked the flow up before teardown can win the
freshly cleared HW_PENDING bit, including in the window opened between
the clear_bit() and the new set_bit() here, and queue a replace for a
flow gc is about to free.

gc runs on system_power_efficient_wq while the handlers run on the
unbound nf_ft_offload_{add,del,stats} queues, and the driver flow_block
callbacks can sleep, so there is no serialization between the two sides.

Would it make more sense for nf_flow_offload_gc_step() to refuse to free
while NF_FLOW_HW_PENDING is set, or for the handler to hold a reference
or RCU section covering the whole flow access, instead of reordering the
bits?  The commit message states that "the offload worker holds neither
an RCU read lock nor a reference to the flow", which remains true for
stats and replace work after this change.
