Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525752;
	b=MVvEw03hwaM2TedOlA+nsGPQE4QX7wkqTJ7kjUO7Je6lh2jrdAFe5fa+PPOEIZRamMyN
	 e0HAW6FAI/1+39XEm5NxwKAjwy0yt1wjaoVImX4KdiJsJVxfSf9M90JF2VADr+eDO23Jr
	 /Q+EkhwXB6GNoIqLkYc7OYkMfvWOC5BKWWCN+R+IdL3ujG/iMu8+ZM0jpHTQgi0Vc5bLo
	 Y1ZoA6fLfELAvKXTJlth7ABlphVXO8Xkr6iPIUBq3bq4tDQ7InQ0zsLilMW3rYyeErp4l
	 F2UruhhrwXbhOanfbwHMQEm7TAHLwCpagCwjxmndVygCwL41t8cQ1/BJGYA2lzPME7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525752;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=2YIGNvCIU2YvRgOXmYyTaRrrJOu/XInDM3EdnXF/wIE=;
	b=mTcmnyQ+kUysyrn7opquPnD6wGI6WRbhkOWVqqv3d6cF++/vNnpJsBdiF+fpDm9SBfqZ
	 Y/aMv2i0EFqkdRfw257PuNd6XhjitU5ulRnuZ06KoSByW/57ViBG3SSvxNGdVxbCRUcCY
	 +ORDvowz6gRAa3GIOL25vG20u/XkwHakk/9yL4ZR0SDIGOXfPHCuTlL1Wg6Zg7IFlh0tI
	 JfxvqKrBu5OwsVrrScF/0kKMtcrGusLTpkvrYw6IuguoRdCCMZsuv1euFJirYQaq+1Uiv
	 QMfYluIHlpFAlOGZidgGaaoxG9m0CVDyx+1L13K+3sX0EefKSlvi31FbL1CndEWccdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=osws0djj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 28FBB606A326;
	Tue, 24 Nov 2026 13:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28FBB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=osws0djj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795525748;
	bh=2YIGNvCIU2YvRgOXmYyTaRrrJOu/XInDM3EdnXF/wIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osws0djjc8gx2b4fTjQfSbzwX0VhYwzW5zq+GqMq9O91ZoNlTQCiOf3yh4vMbvlQ6
	 P6D7QMiSUg1QoU1FlOpj8pBZXyqpZwtgYFA2upKyDEhe54Swc85xzDrm6lk9Egbs7W
	 qTxwJ+0PDTdtgikGPOeAGOWA8ikYR5DEl1qUCNyGaygTBweIpWwlWWEtQwYpm/IIq2
	 czMOYeUHD0WKMMmldanQKqkNfuuKLSXjFmWEEnaCEPtvbYqkSK7T71u9bKJVfLj6Wi
	 4zEDZ8uWCR1itdi+bj1gfS1QsPwAFAMaVmXpAHxnbAjRQovjzTGvHxg3sIGOFYgxl0
	 ROivDFtqx8f8g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 45399601B3;
	Tue, 24 Nov 2026 14:09:08 +0100 (CET)
Date: Tue, 24 Nov 2026 14:09:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Qican Ma <goonsomeway@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: flowtable: interlock NF_FLOW_TEARDOWN
 with NF_FLOW_PENDING
Message-ID: <awWMcRVhzciy1gIw@chamomile>
References: <179550685613.38700.16148920957970479663@gmail.com>
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
In-Reply-To: <179550685613.38700.16148920957970479663@gmail.com>

On Tue, Nov 24, 2026 at 03:54:16PM +0800, Qican Ma wrote:
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
> Found with an LLM-assisted code review tool and verified by inspection on
> v7.4-rc4 (b6a9fa34ce4). Build-tested only; reproducing the race at runtime
> requires a hardware-offloaded flowtable device.

This is the refresh race.

> Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qican Ma <goonsomeway@gmail.com>
> ---
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

Do you have this patch in your tree?

commit 0abb543639741a3d1124e7a1a33fd9d3649d6079
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Oct 16 11:16:37 2026 +0200
 
    netfilter: flowtable: do not hw offload flows in teardown state

This patch is in net-next.

> +
>  	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
>  	if (!offload) {
>  		clear_bit(NF_FLOW_PENDING, &flow->flags);
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
