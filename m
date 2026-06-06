Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50939257855
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jun 2026 03:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780717104; cv=none; b=WEc+nb6q5ETwz6oOou9wUeMtGDNqo1LrFwglRwQbXxnkKL7PeDFiRkzn6sFSYV51K8myI0Ijf24gAoz/b6YWPR6001I2pLd7fwWWNGwgVjSQb0apC5HSAYXVtH11HPAtAsjQ5SzJSt9sBZnSKZ6ZPu5WHouO4tDd286TiIKX3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780717104; c=relaxed/simple;
	bh=JhWdXKRIUiSyaWiBJRfxh3E9gm3q5NK4Di6Xwr+Sr2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WrL70fc7vxap//KaH5GupPBBoMoJPIrqdFLKNq59hPjux9rMVu2J5auh2Aq17Fvelbl4U1+cEGMbbP+0r2EF0sQ2JUxAH6r7KKUwwTXk+bAxKcqhDa+QwVW3qxUfSTyaOdF3llyGjBeLpgxXMI1bSnP5GynjccmtYZsOk5XrSo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FR50HCFq; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FR50HCFq"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-842848fd613so2082786b3a.3
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jun 2026 20:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780717102; x=1781321902; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzoS3NR1vM3+Z+hNvLGJgXbXjhEqEQwWixYPZtOejiw=;
        b=FR50HCFq6aJkf05agWpyk6/VWETa6gXGYQDww3VHIU7XdvaTafZJbPWoY4RaExtCji
         y8hJDtd2t2WZGswVmd/Z4OU2G6v6CE+BbycyYS/ZxVwuwCUhAnbgYimo+ESEBLst+RpY
         8DH14TqppZn9fXQ0yFB0POD0VrYuuyhqPjFt04cKYv8+fcQzoif6A4l+XrkNjEIfo41z
         zo5avbHxZRfi4mLQXh0WJHinj7XVXxYihmqUPuH8tOi7Xlrt4vkgGBpALMII06Xkcq4c
         oylQMS88z9eShwEipRNb3IAQrdq8eGLp5XPmuBBRmS/y4aJGpJrvG8T0B9uWmfFZjLCr
         0o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780717102; x=1781321902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzoS3NR1vM3+Z+hNvLGJgXbXjhEqEQwWixYPZtOejiw=;
        b=MToueqRZIUUyCMPRhctWTeGriC5dNuzLolCsdkNL+SHxeE0aI1imNFgFZzECTCvMjI
         G2dVueIzd/qq4QPVKTmSX/LcRRWBKSb/NkEUfxdbbsm4v6HXjRrlChTAiQBFyRmIbvVB
         1SSNQ5++mnBxaIiCkFRjx7HCaBz61hLQgO+ThoLV2j0EBZBjT8sWfd2CEk/PQ2RP775I
         iVELJ3zy5OrZbcWZQf7L4Jv5FiYzbSYznxhR0ZCE23hdcqOeedltMh6sEEkZYc/6SeCU
         9/RtkScN2BAcFWAhv8B5aEWEnbV/BBJiSr2juVXqgLPicSsplVD7I22gCuLauJ0SzDTS
         8jCA==
X-Gm-Message-State: AOJu0Yw6T2TKJ0fynND8N5daGvemgZiHIkmVZUKhmgMfHs1SLheGlpu3
	HbKRJcFvDVWHWH9PEHrv1dEe/HkV4r0rC7JN8FNL0CUL/xEiD23RwZvA
X-Gm-Gg: Acq92OHJuibD4XEUgGQ+p7ZJayCzrZh26VpfwBfNlGx5JeNIkKV8j85RycnsOWhqYKi
	gRp2BdOVRp6B0lxYzXD9deK6ZVHczemUYiRb4ovTxEezGb43uYf8zXV03E8ZDsZqIWqsRonal4X
	WsFYX45g2WGSdiRZyah7J6HdhA7tFcb/PzZ31LX2UqNfKZ5j+wmEXGJSwVGtBGZTEVKPfIenH3c
	gl4RC0GcfmDL+Hyttinae8WXPUo/JPleBl0Y4z5ef32uuGFaB9jr/gvL+eJvZF6nQTuxnPlD1Bm
	2ATNS4HfPjmhpmpfGlnINWV1pai7yJm6bUztogV7ydVHBixczlGskRHXCuEYGPvrH1kIDQ84R0/
	yQrU/qrEzc18dbbGm1p0Au/Q5WseEVy7b6PVKYFMcVMVIrz8wwU8LGs2uWBZ5e3kgVGl0V7/nZO
	K7Y+cX93JOOAbfJEDpaw==
X-Received: by 2002:a05:6a00:298d:b0:842:2f09:fde9 with SMTP id d2e1a72fcca58-842b0eacffamr6947929b3a.8.1780717102501;
        Fri, 05 Jun 2026 20:38:22 -0700 (PDT)
Received: from [0.0.0.0] ([64.118.136.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428222263dsm12025728b3a.2.2026.06.05.20.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 20:38:22 -0700 (PDT)
Message-ID: <1a9efdce-ad63-40a4-8ca0-217d37aecd7e@gmail.com>
Date: Sat, 6 Jun 2026 11:38:15 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn
References: <fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com>
 <aiIMC2RP7pB2mFDk@strlen.de>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <aiIMC2RP7pB2mFDk@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/2026 7:36 AM, Florian Westphal wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
>> The bridge netfilter fake rtable is embedded in struct net_bridge and is
>> attached to bridged packets with skb_dst_set_noref(). If such a packet is
>> queued to NFQUEUE, __nf_queue() upgrades that fake dst with
>> skb_dst_force().
> 
> Ok, I think I understand why this mess exists. Ideally we could rip out
> the fake rtable and alloc it as separate object with distinct lifetime,
> this FAKE_RTABLE crap needs to die...  But I understand its more
> intrusive / harder to fix it that way (performance considerations don't
> matter however, br_netfilter can be pessimized).
> 
>> +#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>> +static struct net_device *nf_queue_bridge_dev(const struct sk_buff *skb,
>> +					      const struct nf_hook_state *state)
>> +{
>> +	struct dst_entry *dst = skb_dst(skb);
>> +	struct net_device *dev;
>> +
>> +	if (state->pf != NFPROTO_BRIDGE || !nf_bridge_info_exists(skb))
>> +		return NULL;
>> +
> 
> I guess what you are saying is that if br_netfilter hack is on,
> skb->dst can be fake rtable while packet is sent to nfnetlink_queue
> from a *bridge* family hook where in/outdev are the physical ports
> yet skb->dev isn't the bridge device either.  The forced ref on the
> dst is useless in that case, because netdevice_removal frees the
> net_device regardless of the fake rtable dst entries refcounts.
> 
> If thats correct, could you please streamline this patch slightly?
> 
> Something like this (totally untested and misses dev_put part); and
> that comment might be a bit more verbose.
> 
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -84,6 +84,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>  {
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>         const struct sk_buff *skb = entry->skb;
> +       struct dst_entry *dst = skb_dst(skb);
> +       struct net_device *dev = NULL;
>  
>         if (nf_bridge_info_exists(skb)) {
>                 entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
> @@ -92,6 +94,17 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>                 entry->physin = NULL;
>                 entry->physout = NULL;
>         }
> +
> +       if (dst && (dst->flags & DST_FAKE_RTABLE)) {
> +               dev = dst_dev_rcu(dst);
> +               if (dev == blackhole_netdev) [ Q: Is that really needed? I don't think so ]
> +                       dev = NULL;
> +       }
> +
> +       /* Must hold reference on the bridge device: the fake rtable
> +        * is embedded within, dst_hold() is not sufficient.
> +        */
> +       entry->br_dev = dev;
>  #endif
>  }
>  
> @@ -108,6 +121,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
>         dev_hold(state->out);
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +       dev_hold(entry->br_dev);
>         dev_hold(entry->physin);
>         dev_hold(entry->physout);
>  #endif
> 
> Thanks!

Hi Florian,

Thanks for the suggestion. I reworked the patch accordingly for v4 and it
passed tests.

This version keeps the same fix direction as v3, but streamlines the
implementation in the way you suggested. Compared with your sketch, I kept
two small differences in this version:

- I kept the bridge-only gating around the fake-dst lookup, so the extra
  device pin stays limited to the bridge-netfilter fake-dst case.
- I also kept the queue-entry field name as bridge_dev rather than renaming
  it to br_dev.

Something like this in the current diff:

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -18,6 +18,7 @@ struct nf_queue_entry {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+       struct net_device       *bridge_dev;
        struct net_device       *physin;
        struct net_device       *physout;
 #endif

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -92,6 +95,11 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
                entry->physin = NULL;
                entry->physout = NULL;
        }
+
+       if (entry->state.pf == NFPROTO_BRIDGE &&
+           nf_bridge_info_exists(skb) &&
+           dst && (dst->flags & DST_FAKE_RTABLE))
+               dev = dst_dev_rcu(dst);
+
+       entry->bridge_dev = dev;

I will send v4 later.

