Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626629;
	b=3G82pkLFzBpBSGWonPn2Pzsy+b5YC5nY9yCcVNhF3iYagtVbP70W0Xt0oYzKAl4226Wu
	 ai9Oac2le8BBqP/PLYNY1o294r5kdgquQbOvFRJKOOwNTx+VlO9BOpqpi8ZmvqGqBVRRx
	 HzppYJ3ob/Dae6qIE7dgf1HvsiZp9K+yo/0m8AhmuoyTSDugoPX4eH02QFrpK5ufItBp0
	 VjJfoPQtGYRi88ORICmiYoYEtJri+ViDdeIfwp8PDZKSwaRygnWtTwcbC/5hY0L81vauX
	 W9ZrF+s5t7e/y/syEBqaFSvEbc2uoWlmcJWpHdSO2IqZCvvjSh8eepAg9I1mSoEsIdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626629;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=EOVBelVsv2I8YL97UAGEhvodlQG6Qp9F9pQ9y48RuQg=;
	b=sAXxrDHQIiXQMj+N72imI3C/bxGa85LrlBcIVhmGQRuw38FwsC//PYxrjq9jh3IOFoA6
	 ClnGy8kTc9irjD5tQYCzmbmyKtBrIrPWB2y8eQ9DLFipS9cCqkV3wiqnYv37KrDsmn0vB
	 YuMxHhGU2F5XJHooT1xFpHjZBr4jwvUGOHZNp5ZdrN9MwqpCLdnqr7Wpej+pSHd18SwH8
	 GFOOj6Ss3gE+M0ZASwuULXyarJH6LSmKtwKUfkgw92l/7rosKYmcoz4A3svwCJM2ivt/S
	 PG8BbOQG0cWIyr00KdFi/bU0ectF1zBNpSNP8I1LofzzQ+UVTaRU3XBTxLBJa94nz6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnUVkQB5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D460A2610;
	Sat, 14 Nov 2026 03:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnUVkQB5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7EE1F000C4;
	Sat, 14 Nov 2026 03:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626628;
	bh=EOVBelVsv2I8YL97UAGEhvodlQG6Qp9F9pQ9y48RuQg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RnUVkQB54I5nSPX0pbVQqkKQONuiAbjju/g/YfM0g/qgn4LksKlx/h3IX96enS5Fh
	 dvixDVMgB3+zbPHhvDmtWIsUHuMLye8V1oRRbdVHtVQ3isX4M2PQ8u77dOWFpovwRh
	 WSrQTiallZSaKgejk7l4qJDcfruhhbHlF5LWNVAtCEHitcsj2AYor3ZB1jd61VtYXR
	 UwKK1q2REh51Au6obsJqLAh7YQ66t1O2T3GOyUyHkLZWorW6Tmbt9AKFi2bn/A72zw
	 f9E02YiLK1N1aIem+pJtgpyzvmsy9vhXYMW5/eEVFmV61vfMdEq+eGgGaIsqCVqfvb
	 ZmNjjDpiU0mrQ==
Subject: Re: [PATCH net-next 09/15] netfilter: flowtable: purge entries
 immediately when destroying the flowtable
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:47 +0000
Message-ID: <179462662793.2199510.7483926977653221306@kernel.org>
In-Reply-To: <20261113031251.2437074-10-pablo@netfilter.org>
References: <20261113031251.2437074-10-pablo@netfilter.org>
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

- [Low] The commit message understates the impact of the bug it fixes.

--

netfilter: flowtable: purge entries immediately when destroying the flowtable

When a flowtable is destroyed, this patch stops relying on the hardware
offload workqueue to purge the remaining flow entries. It now walks the
rhashtable through rhashtable_free_and_destroy() with
nf_flow_table_do_purge(). That callback tears down each flow, removes its
hardware state synchronously and frees it. NF_FLOW_PENDING marks the first
tuplehash visited, so the flow is released only on the second visit.

> Do not use hardware offload workqueue to purge the remaining flow
> entries when the flowtable is being destroyed. Instead, iterate over the
> flowtable to purge the remaining flow offload entries. Work memory
> allocations can fail, leaving us with either waiting indefinitely until
> work can be allocated or leaving entries in the hardware.

[Severity: Low]
The code change looks correct. Does this paragraph understate what the old
nf_flow_table_free() sequence could do when the work allocation failed?

The old sequence was:

    nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
    nf_flow_table_gc_run(flow_table);
    nf_flow_table_offload_flush_cleanup(flow_table);
    rhashtable_destroy(&flow_table->rhashtable);

On that path, nf_flow_offload_gc_step() calls nf_flow_offload_del(). If the
GFP_ATOMIC allocation in nf_flow_offload_work_alloc() fails, it returns
before setting NF_FLOW_HW_DYING:

    offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
    if (!offload)
        return;

    set_bit(NF_FLOW_HW_DYING, &flow->flags);

As a result, flow_offload_del() is never called for that flow, and it stays
in the rhashtable. rhashtable_destroy() frees only the bucket tables. That
leaks the struct flow_offload along with its nf_conn reference and its
route dst references, which goes beyond leaving entries in the hardware.

The allocation could also fail in the first nf_flow_table_gc_run() and then
succeed in the second one, inside nf_flow_table_offload_flush_cleanup():

    flush_workqueue(nf_flow_offload_del_wq);
    nf_flow_table_gc_run(flowtable);

In that case, the del work is queued after the last flush and never flushed
again. nf_tables_flowtable_destroy() calls kfree(flowtable) right after
nf_flow_table_free() returns, and tcf_ct_flow_table_cleanup_work() frees
ct_ft. So when the work runs later, flow_offload_work_handler() would read
offload->flowtable->net, and flow_offload_tuple_del() would walk
offload->flowtable->flow_block.cb_list, both in freed memory.

Could the commit message mention the flow and conntrack reference leak, and
the possible use-after-free of the flowtable from late-queued del work?
That would help stable and security triage assess this fix.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
