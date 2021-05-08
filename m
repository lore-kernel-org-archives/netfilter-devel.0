Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE85C433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 01:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD1261421
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 01:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhEHBB6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 21:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhEHBB6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 21:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620435657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsFKwqNGgD6WvXNV+HBez94DSlWHQ58FDDDv8dfnrFc=;
        b=R8UygX5cIPUkLZ7yAZrR9qNJazVzyotc72kVg6NKhK64ERyxF/18Axn98QQTxU8M+LwKsR
        4AlxOMiaAEOuWqHlK1RabywOPDGQgtwK4EtSmdjHw9YJVtT/a2Lh9rvhZ0WKrdRLfa24Hs
        I8k36+jo2F1/JiBGXsjVQUbvvKLRyoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-r0rhRVLAO4KsCbJ8S0rIng-1; Fri, 07 May 2021 21:00:56 -0400
X-MC-Unique: r0rhRVLAO4KsCbJ8S0rIng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B2D864157;
        Sat,  8 May 2021 01:00:55 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EC1F1F6;
        Sat,  8 May 2021 01:00:54 +0000 (UTC)
Date:   Sat, 8 May 2021 03:00:52 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <20210508030052.0e188683@redhat.com>
In-Reply-To: <20210507125247.445aaa92@elisabeth>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
        <20210507103523.GA19649@breakpoint.cc>
        <20210507125247.445aaa92@elisabeth>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 May 2021 12:52:47 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Fri, 7 May 2021 12:35:23 +0200
> Florian Westphal <fw@strlen.de> wrote:
> 
> > Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:  
> > > Hi there,
> > > 
> > > I got this backtrace in one of my servers. I wonder if it is known or fixed
> > > already in a later version.
> > > 
> > > My versions:
> > > * kernel 5.10.24
> > > * nft 0.9.6
> > > 
> > > Also, find attached the ruleset that triggered this.
> > > 
> > > [Thu May  6 16:20:21 2021] ------------[ cut here ]------------
> > > [Thu May  6 16:20:21 2021] WARNING: CPU: 3 PID: 456 at
> > > arch/x86/kernel/fpu/core.c:129 kernel_fpu_begin_mask+0xc9/0xe0
> > > [Thu May  6 16:20:21 2021] Modules linked in: binfmt_misc nft_nat    
> > 
> > Hmm, I suspect this is needed (not even compile tested).
> > 
> > diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> > --- a/net/netfilter/nft_set_pipapo_avx2.c
> > +++ b/net/netfilter/nft_set_pipapo_avx2.c
> > @@ -1105,6 +1105,18 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
> >  	return true;
> >  }
> >  
> > +static void nft_pipapo_avx_begin(void)
> > +{
> > +	local_bh_disable();
> > +	kernel_fpu_begin();
> > +}
> >
> > [...]
> > 
> > kernel_fpu_begin() disables preemption, but we can still reenter via
> > softirq.  
> 
> Right... if that's enough (I'm quite convinced), and the overhead is
> negligible (not as much... I'll test), I would prefer this to the
> fallback option on !irq_fpu_usable() -- it's simpler.

Hmm, wait, the overhead is actually negligible, but I don't think
calling local_bh_disable() from the lookup function would actually
help: crc32c_pcl_intel_update() runs from a kthread, and while it's
using the FPU the softirq triggers, not the other way around... right?

I think we really need to check that the FPU isn't already in use by
the kernel with irq_fpu_usable() instead, just like
crc32c_pcl_intel_update() does.

Arturo, there's one thing confusing me here: checking 5.10.24, we're
hitting:

	WARN_ON_FPU(this_cpu_read(in_kernel_fpu));

at line 129 of arch/x86/kernel/fpu/core.c, but not:

	WARN_ON_FPU(!irq_fpu_usable());

at line 128? Those should be equivalent in this situation, because
irq_fpu_usable() checks:

	!in_interrupt() -> false (softirq here) ||

	interrupted_user_mode() -> false (judging from backtrace) ||

	interrupted_kernel_fpu_idle()
		== !!this_cpu_read(in_kernel_fpu);
		-> must be true if warning at line 129 triggers

...I see from tainted flags that some warning was already printed,
could it be that you have a warning from arch/x86/kernel/fpu/core.c:128
in your logs, before this one?

Florian, now that set back-ends are built-in, I'd simply go with
something like (oink):

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 528a2d7ca991..dce866d93fee 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -408,8 +408,8 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
  *
  * Return: true on match, false otherwise.
  */
-static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-                             const u32 *key, const struct nft_set_ext **ext)
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+                      const u32 *key, const struct nft_set_ext **ext)
 {
        struct nft_pipapo *priv = nft_set_priv(set);
        unsigned long *res_map, *fill_map;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 25a75591583e..d84afb8fa79a 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -178,6 +178,8 @@ struct nft_pipapo_elem {
 
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
                  union nft_pipapo_map_bucket *mt, bool match_only);
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+                      const u32 *key, const struct nft_set_ext **ext);
 
 /**
  * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index d65ae0e23028..eabdb8d552ee 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1131,6 +1131,9 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
        bool map_index;
        int i, ret = 0;
 
+       if (unlikely(!irq_fpu_usable()))
+               return nft_pipapo_lookup(net, set, key, ext);
+
        m = rcu_dereference(priv->match);
 
        /* This also protects access to all data related to scratch maps */


-- 
Stefano

