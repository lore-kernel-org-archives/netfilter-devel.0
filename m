From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 3/3] netfilter: cttimeout: unlink timeout objs in the
 unconfirmed ct lists
Date: Thu, 25 Aug 2016 12:58:56 +0200
Message-ID: <20160825105856.GD5242@salvia>
References: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
 <1471874298-20503-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51108 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757935AbcHYK7D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 06:59:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93DD7F9465
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:59:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 996DE10219F
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:59:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC034FC61C
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:58:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471874298-20503-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 09:58:18PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> KASAN reported this bug:
>   BUG: KASAN: use-after-free in icmp_packet+0x25/0x50 [nf_conntrack_ipv4] at
>   addr ffff880002db08c8
>   Read of size 4 by task lt-nf-queue/19041
>   Call Trace:
>   <IRQ>  [<ffffffff815eeebb>] dump_stack+0x63/0x88
>   [<ffffffff813386f8>] kasan_report_error+0x528/0x560
>   [<ffffffff81338cc8>] kasan_report+0x58/0x60
>   [<ffffffffa07393f5>] ? icmp_packet+0x25/0x50 [nf_conntrack_ipv4]
>   [<ffffffff81337551>] __asan_load4+0x61/0x80
>   [<ffffffffa07393f5>] icmp_packet+0x25/0x50 [nf_conntrack_ipv4]
>   [<ffffffffa06ecaa0>] nf_conntrack_in+0x550/0x980 [nf_conntrack]
>   [<ffffffffa06ec550>] ? __nf_conntrack_confirm+0xb10/0xb10 [nf_conntrack]
>   [ ... ]
> 
> The main reason is that we missed to unlink the timeout objects in the
> unconfirmed ct lists, so we will access the timeout objects that have
> already been freed.

Applied, thanks.
