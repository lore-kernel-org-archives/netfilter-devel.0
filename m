Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47212D1F1
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 05:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783142760; cv=none; b=WCKY+gt4xvMCN03fn2z+IFzAfNYk71/DkLqCR0mppVoi2uWnEBbCn3TtFqSJ7gfRn2nAvwPf2QcZqq6rj4hrR2ziZtztp2WluIUa4o+XOWA3eEKPtjCzBA39AcKLxc9+L87nOe+BbZabr9xjAV4jHoNtJtixtBjrKnOErlY4Rtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783142760; c=relaxed/simple;
	bh=g3BbGoj++v7FUqgyA1w4ZfJQT0NPPs+1tmrgpJXuZWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+Uv8S/b5zkYAiIBkz+W2cK4LMh/aWSh0IPeFqXzGWDDpZaVKeW5IjlsSPanhztvBWuJBZkN392T6GepJyOGGJa1chDeph/9D1foYl8VXhZ9Nvye9i+n6mA7esYtld9DkCXwcHUEeLcDcpuaBcmFRev75oKp94f9Ak8BJaaoCac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=anGKZcMU; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anGKZcMU"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so1029755b3a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jul 2026 22:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783142758; x=1783747558; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLr+g9xBAzoeFI6qg+mRghCqjK0gLzc/72nBV2jRy5c=;
        b=anGKZcMUw6fxviM7ktoMLFXkNFBDPNRan+GKEwNXEaLTJlTaB+qyC6QGXOFszDO+WG
         0JDJnrOpPPb57PCezmPpODcvtcDFYzbQMQ+qpJiT8aTwz4OuSD4bas2eFJytf8O49uOA
         rPW6gDEOWitsm62Y+rX5+ct5SKh0dS2LFFaGFbhT2+xdIzPMbQUe//9m/Ux5YM/Dm3dm
         qNSdwWgUEd13Q/hvh+zka2Lv47yOCX4G9trSG6Vo1ydpOqbup8gIMLoL4bqF9Xv8gw7e
         +rsxEhFZke7ORsnPJKYoWIhEYPLP58sGSJ8Jyp32lQBlHOF+iyKlEEksxTlyWtRp7pan
         0Z1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783142758; x=1783747558;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HLr+g9xBAzoeFI6qg+mRghCqjK0gLzc/72nBV2jRy5c=;
        b=BTXNrbaGWUeu6ozzWPDPJC5h01KgWCX76gWU5Ymj47y5GZCQteoGjZvnyGi+mhIkBB
         JS3/l5cg9GXWD6f8WBnE9Rha/7FpquxJWkInK/szdT38HXQx1QLWih9wRKrAdfKAHCDz
         41+QhywcktVTjTPlE+ZsTpLsJq+0MmJHYWMuhICt+unPR8ABmNKOSHY+umYPbO5h1MS8
         ZXDS2276LQrAWfCy7v6xoRBZJnr3n8uzcZkBNNsqnxJ5+B9LsyWjAi909AdnmKGDl27U
         yM2SidEVwdsJ2bLBcp0Z8ubBMjDeVtnPHkXwOj1hVrrRB+k1EgMrpf1oNn7CLhjIsaU3
         8XDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jjySe4oji4CaJAz/plR4gKQTh94LKMVwzOm/CVhnKnptZZJjkKa5ZNLBgS3NS+CqZcPLmfS4kr+BDMkKG8sA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmUGV9qTO5xQuk+kdgayMdOjCR1D6vjM0Rr9nLEuvVGuC5fTh9
	fXbeE0l6kUukvt1m7S537MwglVn7hrBf0yyFWEW2I8z1LLfRONch8TGh
X-Gm-Gg: AfdE7cnQPfujpbuPeYfuG34/v/eGDBNEsP8uVKnMoaEv71EqIbdA990OhamlZCZ0xLY
	LDwfZg8LdJxZ0mUy0JwbE8wOkY4gp4LqBAUdINBfaJ6/+cRlp72Lcs88g6gKRef0R3cJt/bJjNx
	+qHiHn4RD1Cis6BfIwW/pzFVYX93a2L6h7XeY/laN9lkN2SQcxW8FOsgCGgB9VtThE6ofk2ObOs
	VCfCI/260lk/XBknFiwP1UyRsm/sfwqjAyCmVkoacR4YT2ujSt/RMGZ7prbi8fKuCMr2Jqal4gu
	JpgzOk/h/Aqx6kS0E53HrbL2aPF26PvHxA3vGACTbjKjnQGNQsxi5qrGgfaWqs5+AvXXTSs84yB
	gv8Iynq/bEpzGBoGpTUhSRejd1931yuZFo43Tdzg+8iBQ/BSdvAApwCT2gboQgPCBQ9xRfFRsZx
	98BlhPZldgX5xabgwu1OodP96UidZevUqT
X-Received: by 2002:a05:6a00:2da1:b0:847:8d0e:5d83 with SMTP id d2e1a72fcca58-847f86e4257mr1431868b3a.26.1783142757944;
        Fri, 03 Jul 2026 22:25:57 -0700 (PDT)
Received: from [0.0.0.0] ([2a12:bec0:16e:590:1aa:f10:c238:546f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b93f8csm797364b3a.19.2026.07.03.22.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 22:25:57 -0700 (PDT)
Message-ID: <53245eb5-baac-4e04-a632-1b722ea18972@gmail.com>
Date: Sat, 4 Jul 2026 13:25:50 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v5 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, yuantan098@gmail.com,
 yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
 netfilter-devel@vger.kernel.org, Ren Wei <n05ec@lzu.edu.cn>
References: <cb8bfe944f4afa8cec437fc15210a3d094612859.1780803571.git.royenheart@gmail.com>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <cb8bfe944f4afa8cec437fc15210a3d094612859.1780803571.git.royenheart@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/8/2026 1:43 PM, Ren Wei wrote:
> From: Haoze Xie <royenheart@gmail.com>
> 
> The bridge netfilter fake rtable is embedded in struct net_bridge and is
> attached to bridged packets with skb_dst_set_noref(). If such a packet is
> queued to NFQUEUE, __nf_queue() upgrades that fake dst with
> skb_dst_force().
> 
> At that point the queued skb can hold a real dst reference after bridge
> teardown has started. The problem is not that every bridged packet needs
> its own dst reference. The problem is that NFQUEUE can keep the bridge
> private fake dst alive after unregister begins.
> 
> Fix this by keeping the bridge fake dst model unchanged and pinning the
> bridge master device only while the packet sits in NFQUEUE. Record the
> bridge device in nf_queue_entry when the queued skb carries a bridge fake
> dst, take a device reference for the queue lifetime, and drop it when the
> queue entry is freed.
> 
> Also make sure queued entries are reaped when that bridge device goes
> down, and drop the redundant nf_bridge_info_exists() test from the fake
> dst detection.
> 
> This keeps netdev_priv(br->dev) alive until verdict completion, so the
> embedded fake rtable and its metrics backing storage cannot be freed out
> from under dst_release(). It also avoids the constant refcount bump and
> avoids using ipv4-specific dst helpers for IPv6 bridge traffic.
> 
> Fixes: 34666d467cbf ("netfilter: bridge: move br_netfilter out of the core")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Haoze Xie <royenheart@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> Changes in v5:
>   - drop the redundant nf_bridge_info_exists() test in the fake-dst bridge
>     device lookup
>   - teach dev_cmp() to reap queued entries that hold the bridge device
>     reference when that device goes down
>   - v4 Link: https://lore.kernel.org/all/cbc3a29c0654e8fcee30cb021d57883fed77fafc.1780630094.git.royenheart@gmail.com/
> Changes in v4:
>   - inline the bridge fake-dst device lookup into
>     __nf_queue_entry_init_physdevs()
>   - drop the extra helper introduced in v3 and keep the queue-entry setup
>     local
>   - use dst_dev_rcu() as suggested during review
>   - drop the unnecessary blackhole_netdev special case
>   - expand the comment to state explicitly that dst_hold() cannot protect
>     the embedded fake rtable backing storage
>   - v3 Link: https://lore.kernel.org/all/fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com/
> Changes in v3:
>   - drop the per-packet fake dst refcounting from v2
>   - stop using ipv4-specific dst helpers for the fake dst
>   - keep the existing bridge fake rtable model unchanged on the fast path
>   - pin the bridge master device only when NFQUEUE upgrades a fake dst
>   into an asynchronous queued reference
>   - v2 Link: https://lore.kernel.org/all/831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com/
> changes in v2:
>   - spell out how NFQUEUE upgrades the fake dst into a real reference
>   - switch to rt_dst_alloc() instead of br_netfilter-private dst_ops state
>   - detach the bridge device with dst_dev_put() during teardown
>   - keep the ref-holding contract local to bridge_parent_rtable()
>   - v1 Link: https://lore.kernel.org/all/783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com/
> 
>  include/net/netfilter/nf_queue.h |  1 +
>  net/netfilter/nf_queue.c         | 14 ++++++++++++++
>  net/netfilter/nfnetlink_queue.c  |  3 +++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index 3978c3174cdb..fc3e81c07364 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -18,6 +18,7 @@ struct nf_queue_entry {
>  	unsigned int		id;
>  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	struct net_device	*bridge_dev;
>  	struct net_device	*physin;
>  	struct net_device	*physout;
>  #endif
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 57b450024a99..73363ceedebe 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -68,6 +68,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>  		nf_queue_sock_put(state->sk);
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	dev_put(entry->bridge_dev);
>  	dev_put(entry->physin);
>  	dev_put(entry->physout);
>  #endif
> @@ -84,6 +85,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>  {
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  	const struct sk_buff *skb = entry->skb;
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net_device *dev = NULL;
>  
>  	if (nf_bridge_info_exists(skb)) {
>  		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
> @@ -92,6 +95,16 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>  		entry->physin = NULL;
>  		entry->physout = NULL;
>  	}
> +
> +	if (entry->state.pf == NFPROTO_BRIDGE &&
> +	    dst && (dst->flags & DST_FAKE_RTABLE))
> +		dev = dst_dev_rcu(dst);
> +
> +	/* Must hold a reference on the bridge device: dst_hold() protects
> +	 * the dst itself, but the fake rtable is embedded in bridge-private
> +	 * storage that netdevice teardown can free independently.
> +	 */
> +	entry->bridge_dev = dev;
>  #endif
>  }
>  
> @@ -108,6 +121,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
>  	dev_hold(state->out);
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	dev_hold(entry->bridge_dev);
>  	dev_hold(entry->physin);
>  	dev_hold(entry->physout);
>  #endif
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 60ab88d45096..1c73c511a682 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1214,6 +1214,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
>  
>  	if (physinif == ifindex || physoutif == ifindex)
>  		return 1;
> +
> +	if (entry->bridge_dev && entry->bridge_dev->ifindex == ifindex)
> +		return 1;
>  #endif
>  	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
>  		return 1;

Hi, is there any follow up about this patch?
