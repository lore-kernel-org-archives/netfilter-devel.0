Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE51C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 18:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKBSRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 14:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKBSRM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 14:17:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A0D31DF08
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 11:17:12 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:17:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [PATCH v2] netfilter: ipset: enforce documented limit to prevent
 allocating huge memory
Message-ID: <Y2K0I2ttzKlKCbvN@salvia>
References: <20221102094047.460574-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221102094047.460574-1-kadlec@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 02, 2022 at 10:40:47AM +0100, Jozsef Kadlecsik wrote:
> Daniel Xu reported that the hash:net,iface type of the ipset subsystem does
> not limit adding the same network with different interfaces to a set, which
> can lead to huge memory usage or allocation failure.
> 
> The quick reproducer is
> 
> $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
> $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done
> 
> The backtrace when vmalloc fails:
> 
>         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
>         <...>
>         [Tue Oct 25 00:13:08 2022] Call Trace:
>         [Tue Oct 25 00:13:08 2022]  <TASK>
>         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
>         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
>         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
>         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
>         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
>         <...>
> 
> The fix is to enforce the limit documented in the ipset(8) manpage:
> 
> >  The internal restriction of the hash:net,iface set type is that the same
> >  network prefix cannot be stored with more than 64 different interfaces
> >  in a single set.

Applied, thanks
