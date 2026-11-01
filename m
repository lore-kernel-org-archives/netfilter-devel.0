Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793574669;
	b=l/1fkSEBe/GZnz+xVP/Z856O7dgQ79zLBOfg16m/jrGLXpGqPmuNGKAHTqIZ3qfn31uQ
	 PVNT56gGgDOkLAeh+QqZM1CFLMID0nZuXaHnKQhL/sgRKfyAayhl8abzd7ssuor5S7NwI
	 ZrZhS4Mp07rahm5ZuKl8CUUZ1EgvZseglEr46vmGkhPV97SHjUIKPpX9kF9boA8eYA86X
	 5jk/BLq39gnOhBJwAyUXHVFywfK3NZ79PTHD9mmmRrkvAN/V6XzFY69a/Y94iQnUBGdGi
	 iq6X/4GNR+Ekc6D5tQdqvXlv8JNw2SGCpvbA/lLIXGlMG6pAUji8ky2hVhDq7ASCwAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793574669;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=pP4TSECHhZx0zxl/HEDYPKq8T0EGn/TF0YTD8IQWiug=;
	b=i7+kEilQyxTmVvNEcydYJvd/Lru9d61XIRUTFVd4P5Qg5VhrEkTGNej3OfFogaIG55Ba
	 OscZcizFanH0lWCgwFGOdFmMMn941sJvEWL3vqh6tNY1UTBiVf069wdRJg07dFyPrHiTB
	 MZp4EP8+aQfRWxbss8UmA6897NMHi/+WVTm0a9tCwIGsexNgNmafel29qO2DGMfg5AWLH
	 sXlbrcavxYcCt+KEKLse2Hhz1mQIuLGKjB0VN3nhNOAV6VkrJjKeKiwX+S9tuuqYAQ4qP
	 CWndk0GMcR9va1NgLQW+CgqWmew6p2x/nv9weWi0/i+s/bN0qS16gIL5tWzfiMPT2dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Kby+au8r;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A6398606A324;
	Sun,  1 Nov 2026 23:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6398606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Kby+au8r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793574666;
	bh=pP4TSECHhZx0zxl/HEDYPKq8T0EGn/TF0YTD8IQWiug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kby+au8rk/2gDQQrwaEaUYRsa3sad14btpmCw5JdLOy6c8YuLhSPmxt9BOqC23Gs/
	 0pkG1xXBnLWsDLuZNFuDt3mV6pmTJzJWx1Vm9NG3OpgudaKJ4Y/xG7yeJQr+/uBMuk
	 C7JJQ8DV+UijEAUPu4z+c9G/vHyyhmoW5WWzOLrYGuGVJQ+ehI4AXrIVn3dI3QX1FL
	 xnw9FhWv8G+5El+tNfN98wXyBlGm3CbuFm5oWuL+/M1kd9qQyVar5lyFOS4MkRBFt2
	 42l2GGz1oOkA/SfJtak0gOyyxVQn+ZRowKY/dfo6u+Xwkk7V3MqB7D3vwTWfkN0BWd
	 jJQztauMwGqVQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0A8D460058;
	Mon,  2 Nov 2026 00:11:06 +0100 (CET)
Date: Mon, 2 Nov 2026 00:11:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: flowtable: flush delete work after
 final GC
Message-ID: <aufHB1HXHtm7rw4M@chamomile>
References: <20260927163248.1002656-1-nicoyip.dev@gmail.com>
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
In-Reply-To: <20260927163248.1002656-1-nicoyip.dev@gmail.com>

On Mon, Sep 28, 2026 at 12:32:48AM +0800, Chengfeng Ye wrote:
> nf_flow_table_free() can return while delete work still holds a pointer to
> the flowtable. Its caller can then free the flowtable before the worker
> accesses it, causing a use-after-free.
> 
> nf_flow_offload_del() sets NF_FLOW_HW_DYING only after allocating the work
> item. If this GFP_ATOMIC allocation fails during the first teardown GC
> pass, the flow remains eligible for deletion in the final GC pass inside
> nf_flow_table_offload_flush_cleanup(). That pass runs after the delete
> workqueue has been flushed, so a successful retry queues work which is
> not waited for:
> 
>   teardown worker                         delete worker
>   first GC: work allocation fails
>     NF_FLOW_HW_DYING remains clear
>   flush delete workqueue
>   final GC: allocation succeeds
>     queue FLOW_CLS_DESTROY work
>   destroy rhashtable
>   free flowtable
>                                           access offload->flowtable
> 
> Flush the delete workqueue again after the final GC to complete this work
> before the flowtable can be freed. All flows have already been marked for
> teardown, so this GC pass only queues delete work, and the delete worker
> does not queue further offload work.
> 
> KASAN reported:
> 
>   BUG: KASAN: slab-use-after-free in flow_offload_work_handler+0xbe8/0xe30
>   Read of size 8 at addr ffff888109c9fd98 by task kworker/u16:3/397
>   Workqueue: nf_ft_offload_del flow_offload_work_handler
>   Call Trace:
>    flow_offload_work_handler+0xbe8/0xe30
>    process_one_work+0x63a/0x1070
>    worker_thread+0x45b/0xd10
>   Allocated by task 87:
>    nf_tables_newflowtable+0x5d0/0x22f0
>    nfnetlink_rcv_batch+0x1396/0x1d00
>   Freed by task 11:
>    kfree+0x131/0x3c0
>    nf_tables_trans_destroy_work+0xb26/0xeb0
>    process_one_work+0x63a/0x1070
>   Last potentially related work creation:
>    __queue_work+0x68e/0x1030
>    flow_offload_del+0x74c/0xad0
>    nf_flow_offload_gc_step+0x264/0x8e0
>    nf_flow_table_gc_run+0xcd/0x150
>    nf_flow_table_offload_flush_cleanup+0x5c/0x70
>    nf_flow_table_free+0x280/0x350
>    nf_tables_flowtable_destroy+0x71/0x270

For the record, proposed alternative to this patch:

https://patch.msgid.link/netfilter-devel/20261029230657.302417-1-pablo@netfilter.org/

> Fixes: c921ffe85333 ("netfilter: flowtable: Fix flushing of offloaded flows on free")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6-Astra
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> ---
> Changes in v2:
> - Rebase onto current mainline; the independently revalidated one-line fix
>   is unchanged from v1.
> 
> v1: https://lore.kernel.org/r/20260824115829.205118-1-nicoyip.dev@gmail.com/
> 
>  net/netfilter/nf_flow_table_offload.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 6757fd89c1f1..728220ba3882 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1172,6 +1172,7 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
>  	if (nf_flowtable_hw_offload(flowtable)) {
>  		flush_workqueue(nf_flow_offload_del_wq);
>  		nf_flow_table_gc_run(flowtable);
> +		flush_workqueue(nf_flow_offload_del_wq);
>  	}
>  }
>  
> -- 
> 2.43.0
> 
