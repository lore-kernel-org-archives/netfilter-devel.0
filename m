Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AF1C43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352E220673
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfFUPo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 11:44:26 -0400
Received: from mail.us.es ([193.147.175.20]:54002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfFUPoZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 11:44:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D90BEDB0D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:44:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C888DA709
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:44:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62196DA702; Fri, 21 Jun 2019 17:44:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E747DA702;
        Fri, 21 Jun 2019 17:44:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 17:44:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0D7014265A31;
        Fri, 21 Jun 2019 17:44:20 +0200 (CEST)
Date:   Fri, 21 Jun 2019 17:44:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipvs: defer hook registration to avoid leaks
Message-ID: <20190621154419.lx5aw255h4rd5gli@salvia>
References: <20190604185635.16823-1-ja@ssi.bg>
 <20190620133929.mzzeexyk7yaaslh5@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620133929.mzzeexyk7yaaslh5@verge.net.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 03:39:31PM +0200, Simon Horman wrote:
> On Tue, Jun 04, 2019 at 09:56:35PM +0300, Julian Anastasov wrote:
> > syzkaller reports for memory leak when registering hooks [1]
> > 
> > As we moved the nf_unregister_net_hooks() call into
> > __ip_vs_dev_cleanup(), defer the nf_register_net_hooks()
> > call, so that hooks are allocated and freed from same
> > pernet_operations (ipvs_core_dev_ops).
> > 
> > [1]
> > BUG: memory leak
> > unreferenced object 0xffff88810acd8a80 (size 96):
> >  comm "syz-executor073", pid 7254, jiffies 4294950560 (age 22.250s)
> >  hex dump (first 32 bytes):
> >    02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
> >    00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
> >  backtrace:
> >    [<0000000013db61f1>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
> >    [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >    [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
> >    [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0 mm/slab.c:3597
> >    [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
> >    [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
> >    [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
> >    [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
> >    [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
> >    [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
> >    [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60 net/netfilter/core.c:61
> >    [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270 net/netfilter/core.c:128
> >    [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170 net/netfilter/core.c:337
> >    [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0 net/netfilter/core.c:464
> >    [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0 net/netfilter/core.c:480
> >    [<000000002ea868e0>] __ip_vs_init+0xe8/0x170 net/netfilter/ipvs/ip_vs_core.c:2280
> >    [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
> >    [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
> >    [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
> >    [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:107
> >    [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
> >    [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150 kernel/fork.c:2035
> >    [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
> >    [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369
> > 
> > Reported-by: syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com
> > Fixes: 719c7d563c17 ("ipvs: Fix use-after-free in ip_vs_in")
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> 
> Thanks Julian.
> 
> Pablo, please consider applying this to nf.
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks!
