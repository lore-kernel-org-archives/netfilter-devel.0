From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix possible oops when dumping
 stateful objects
Date: Mon, 16 Jan 2017 14:26:53 +0100
Message-ID: <20170116132653.GA20971@salvia>
References: <1483793510-30865-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdAPN1C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:27:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07A24392E0A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:27:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC469A7BF3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:27:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEB05A7BF4
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:26:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1483793510-30865-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 07, 2017 at 08:51:50PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When dumping nft stateful objects, if NFTA_OBJ_TABLE and NFTA_OBJ_TYPE
> attributes are not specified either, filter will become NULL, so oops
> will happen(actually nft utility will always set NFTA_OBJ_TABLE attr,
> so I write a test program to make this happen):
> 
>   BUG: unable to handle kernel NULL pointer dereference at (null)
>   IP: nf_tables_dump_obj+0x17c/0x330 [nf_tables]
>   [...]
>   Call Trace:
>   ? nf_tables_dump_obj+0x5/0x330 [nf_tables]
>   ? __kmalloc_reserve.isra.35+0x31/0x90
>   ? __alloc_skb+0x5b/0x1e0
>   netlink_dump+0x124/0x2a0
>   __netlink_dump_start+0x161/0x190
>   nf_tables_getobj+0xe8/0x280 [nf_tables]

Also applied, thanks.
