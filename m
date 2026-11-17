Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874972;
	b=ols9TXW1HHfkaQ65dj+pEag44/t2ypim8WwX9C9z9vFKPq/4xbzahT/iPAo60jzoPq1F
	 J2kSWN2Sp6K2P76HGFE0s+6eNdD9Knhug9SwE5p7NJEMt79eQTIMGmi5RkXx8Hb/uEkYw
	 9+kWtiulIk1QizFG3SDI6qaNjWQUYbvdv99WnjElFR5GJowACmXdzWhFlVgcKnGcOMitP
	 2Bw/KVDHu7hgPEzmYNvjPdjN5RhASUB9cyhTbdLIml+RNRC7lO6p3mcxbDm1b/FwuELLh
	 AUMoBLcCdjDOuKnl1oyATefjarcjwex5m60Kiz8UoSjc+MWC/UFRNDxIfbJIHG0TVUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874972;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=s3ohfzjwBrYVWyD7nMXcGy5TMW1X4opNptJQOtW8jLU=;
	b=UAaLe/TUeSp60SIuRa2hHfji4EwBipO8SnL0K73wF/BOxxWP3hXUW+p6dT08Mo4+D9i4
	 tOCDZhZXe8coXgvd3JNjTi3X5E95Y+BJo3Kggj59u+7ICAfms3d2mkqp3f37G4jEsCm+Q
	 00yHkO4prlcLTB2uOR/5wz+4VkNiuyYURczh+9zI+t5YSuubdhLV5FRyf5RllVM9c1oDW
	 jmX3dluke0vHaAEjI9vLGcStIX79mgAkGHMDI5kD15m9lnNPcMDUzq405HZ3p00W17wlb
	 rpjjvAdO6ZlwQAkKKptgWyn8ct6l39npEC7Gs3oicOkdZRyh7JjeIQ8nqmk7SFioM0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHd3mONO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73708606A329;
	Tue, 17 Nov 2026 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHd3mONO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28A1F000C8;
	Tue, 17 Nov 2026 00:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874972;
	bh=s3ohfzjwBrYVWyD7nMXcGy5TMW1X4opNptJQOtW8jLU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DHd3mONOryG/hmWDdnUZeGK2eqFqNo8zo7l8NY0tDY8VMQlwvi4rY5tdbp9qbFMWQ
	 /O5ZjVQ6meAvLCT5tqfmfZMchKHr0x7/SAcTXSzK/BrsLyNbh938cu54s1b/qzB2Gp
	 9vzfuaBHN6660Flc/NXEUrAD5cYgcSwYteDiqDQgkc8EpEYzzZLQKWyb3Vzh0uvJgb
	 rn70WVf0E7rOnNmyE3AkjIa4P908Fs1s1xYtCNZ5MlUtZML2lCs9h4CWDHV3kwgXUv
	 LUorCu98kDkrwodxDJdTV1fB6x4d1Dyfs7ngr/lkk3r7rqHX/7t5onDQr7uECbRlQ5
	 C3IFGppAryY0Q==
Subject: Re: [PATCH net-next 07/13] netfilter: flowtable: purge entries
 immediately when destroying the flowtable
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:51 +0000
Message-ID: <179487497106.3136.16489968297961134711@kernel.org>
In-Reply-To: <20261116001612.2806263-8-pablo@netfilter.org>
References: <20261116001612.2806263-8-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message for "netfilter: flowtable: purge entries
  immediately when destroying the flowtable" understates the bug it…

--

netfilter: flowtable: purge entries immediately when destroying the flowtable

This commit stops using the hardware offload workqueue to purge the
remaining flow entries when a flowtable is destroyed. nf_flow_table_free()
now calls rhashtable_free_and_destroy() with nf_flow_table_do_purge(),
which tears down each flow, removes it from hardware synchronously and
frees it. NF_FLOW_PENDING marks that the first tuplehash of a flow has
already been visited.

> Work memory
> allocations can fail, leaving us with either waiting indefinitely until
> work can be allocated or leaving entries in the hardware.

[Severity: Low]
Does this fully describe what could happen in the old destroy path?

In the old nf_flow_table_free(), a torn-down flow with NF_FLOW_HW set and
NF_FLOW_HW_DYING clear goes through:

nf_flow_table_gc_run()
  nf_flow_offload_gc_step()
    nf_flow_offload_del()
      nf_flow_offload_work_alloc()   /* GFP_ATOMIC */

If that allocation fails, nf_flow_offload_del() returns before it sets
NF_FLOW_HW_DYING:

    offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
    if (!offload)
        return;

    set_bit(NF_FLOW_HW_DYING, &flow->flags);
    flow_offload_queue_work(offload);

The flow therefore stays in the table for the second pass in
nf_flow_table_offload_flush_cleanup():

    flush_workqueue(nf_flow_offload_del_wq);
    nf_flow_table_gc_run(flowtable);

If the allocation fails again, rhashtable_destroy() frees only the bucket
tables. Wouldn't the flow_offload leak, along with its nf_conn reference
(nf_ct_put() in flow_offload_free_rcu() never runs) and its route dst
references?

If the allocation succeeds in the second pass, the FLOW_CLS_DESTROY work
is queued after the last flush_workqueue(). Nothing flushes it before
nf_flow_table_free() returns. The flow still leaks, because
flow_offload_del() is never reached for it.

The caller then frees the flowtable. act_ct frees ct_ft after
tcf_ct_flow_table_cleanup_work(), and nf_tables kfree()s the
nft_flowtable that embeds it.

Can flow_offload_work_handler() and flow_offload_work_del() then read
offload->flowtable->net, ->priority and ->flow_block.cb_list from freed
memory?

The code change looks correct and fixes both cases. Could the changelog
also mention the flow, nf_conn and dst leak, and the possible
use-after-free of the flowtable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
