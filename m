Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597520;
	b=u559lRSGYNf5ecqWTJcpdy5FCIE5wY4Y6kP5PkeT7YuG1H++WewKGhFaxFiT79fZ8Ojo
	 lN/8nf00dOy/2Y2nqeV4EWlKH0ipI5cqEI47Y4MYBaYX6RTT1mNcgNsQytGWGLAHziG9Q
	 TksHA2T9SKDLOv4y/1BtQnYYIKu5uDobbxTcJ+Xk5MqNtY0QhpNUvul6fcEqh/BxpcXVg
	 CmXNLU4fGQVxhOaTiR6X+g/SWw7wMGGRR7+keK8GEPGuB2exFgNccn+0V0TvT+1V0vWGY
	 klO6jSazoqUdfJemkq+Ny1zdIN63qyGMc6/QTEy8TX65IDcO1KVDaAtHsU/RAxF8xIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597520;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=kjGcOEJ6nYNII7Jo6nONx1FrsPfS6rbEw2scGdCG8Zs=;
	b=hoULPPW6OqrQ43zZJKh/+cf16Kk8LSp9uxQp+furS81AaGISyXWJLRtx75l1Co5pfp77
	 XvaFaxAiKQSjuFQc+4bHvCaKTl30QhTJEU2teasAQPuF+CjJhEHMxL1cOSRfIaDyTluQz
	 OXQ2cofQQVpYWr71EaBoAsMNf+anLzzSXxvgWcnyIgB5c9jskT1lYop27MyD/DGwW0xkj
	 ZMz96eaBavGJlsfqXGa+/jrwuqYcYynW1GlR+DIjnl2cn9QNgXg7dsZgi/wCR8ZTQlZSm
	 QYusdMbHJSuEOGtR8dW/3zsZrem41DndvLVCDZVHVoAiAKwwQnyqmkn4BjV+Zd8tdRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=E54Xe4jf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9E63D606A31E;
	Wed, 25 Nov 2026 09:05:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E63D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=E54Xe4jf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795597516;
	bh=kjGcOEJ6nYNII7Jo6nONx1FrsPfS6rbEw2scGdCG8Zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E54Xe4jfdP/rY9wZz1OIN+VrOtgMLTFx8pFRpveN1dH6yUs9fs0UbECGRmt7KkKp4
	 WRw9M4AArwv51zHASR+QRV73VrGtOLzqnEk3+YPDxiBB47ry/vr45qPi69TCNwJ2bO
	 eF3EnldLMxaQAgbqS5J1C5c/Eb89vqOle7Le5KCm2n1bb4C72TEJKiACVmSgpOijrQ
	 TA+8Be+FEcOvBBLBoPQLIvMIeFwiJrdfBHwBi92BgKvV0LDCARODv7fpp5e2HQy6Mu
	 jW9FzBTrQWMWU0Xym1nbaDzMvCgThR/lsF078Mk0cI/wvaPPumq1oiB2VrlCS3Yd7i
	 bEvrmuJdFO/+g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 50D0B60058;
	Wed, 25 Nov 2026 10:05:16 +0100 (CET)
Date: Wed, 25 Nov 2026 10:05:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Qican Ma <goonsomeway@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf v3] netfilter: flowtable: interlock NF_FLOW_TEARDOWN
 with NF_FLOW_PENDING
Message-ID: <awakyVQMHrobvvAL@chamomile>
References: <179559147736.38007.14255585896242834600@gmail.com>
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
In-Reply-To: <179559147736.38007.14255585896242834600@gmail.com>

On Wed, Nov 25, 2026 at 03:24:37PM +0800, Qican Ma wrote:
> nf_flow_offload_gc_step() checks NF_FLOW_PENDING once at entry before
> setting NF_FLOW_TEARDOWN and potentially freeing the flow via
> flow_offload_del(). Concurrently, flow_offload_add() or a datapath caller
> that looked up the flow prior to teardown can call
> nf_flow_offload_work_alloc(), set NF_FLOW_PENDING, and queue a
> FLOW_CLS_REPLACE work item holding a raw pointer to the flow without
> rechecking NF_FLOW_TEARDOWN. If the pending bit is set after the GC check,
> flow_offload_del() frees the flow via RCU while the queued work item can
> still dereference and clear NF_FLOW_PENDING on offload->flow.
> 
> Interlock the two flags: in nf_flow_offload_gc_step(), check
> NF_FLOW_PENDING after NF_FLOW_TEARDOWN has been observed or set, paired
> with a full memory barrier; in nf_flow_offload_work_alloc(), recheck
> NF_FLOW_TEARDOWN after test_and_set_bit(NF_FLOW_PENDING) for
> FLOW_CLS_REPLACE and bail out if set. Restrict the teardown check to
> FLOW_CLS_REPLACE because GC itself queues FLOW_CLS_DESTROY and
> FLOW_CLS_STATS work on flows already marked for teardown.
> 
> This complements commit 0abb54363974 ("netfilter: flowtable: do not hw
> offload flows in teardown state"), which checks the teardown bit in the
> nf_flow_offload_refresh() caller: checking inside
> nf_flow_offload_work_alloc() covers all FLOW_CLS_REPLACE callers,
> including flow_offload_add(), and the GC-side barrier closes the
> remaining window where GC reads NF_FLOW_PENDING at entry before
> NF_FLOW_TEARDOWN is set.
> 
> Found with an LLM-assisted code review tool and verified by inspection on
> v7.4-rc4 (b6a9fa34ce4). Build-tested only; reproducing the race at runtime
> requires a hardware-offloaded flowtable device.
> 
> Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qican Ma <goonsomeway@gmail.com>
> ---
> v3: rebase onto net-next with 0abb54363974 included; note how the check
>     inside work_alloc() complements the refresh-side check and why the
>     GC-side barrier is still needed. No code changes.
> v2: resend via direct SMTP without line-wrapping corruption in the diff.
> 
>  net/netfilter/nf_flow_table_core.c    | 8 +++++---
>  net/netfilter/nf_flow_table_offload.c | 7 +++++++
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 2aa2647ed9d..fcd37f7a37f 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -578,9 +578,6 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  {
>  	bool teardown;
>  
> -	if (test_bit(NF_FLOW_PENDING, &flow->flags))
> -		return;
> -
>  	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
>  
>  	if (nf_flow_has_expired(flow) ||
> @@ -594,6 +591,11 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  		nf_flow_table_extend_ct_timeout(flow->ct);
>  	}
>  
> +	/* Pairs with test_and_set_bit(NF_FLOW_PENDING) in work_alloc(). */
> +	smp_mb();
> +	if (test_bit(NF_FLOW_PENDING, &flow->flags))
> +		return;
> +
>  	if (teardown) {
>  		if (test_bit(NF_FLOW_HW, &flow->flags)) {
>  			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e..402a46e1645 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1088,6 +1088,13 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>  	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
>  		return NULL;
>  
> +	/* Pairs with smp_mb() in nf_flow_offload_gc_step(). */
> +	if (cmd == FLOW_CLS_REPLACE &&
> +	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> +		return NULL;
> +	}

Not correct, this is duplicating an already existing check in
net-next.

> +
>  	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
>  	if (!offload) {
>  		clear_bit(NF_FLOW_PENDING, &flow->flags);
> -- 
> 2.50.1 (Apple Git-155)
> 
