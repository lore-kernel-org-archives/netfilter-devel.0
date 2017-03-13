From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: fix crash when inputting an incomplete set add
 command
Date: Mon, 13 Mar 2017 12:12:10 +0100
Message-ID: <20170313111210.GA4326@salvia>
References: <1489206011-43843-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752676AbdCMLM1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 07:12:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72D8AE633
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:12:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 512D9DA795
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:12:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0419BDA84D
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:12:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489206011-43843-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 11, 2017 at 12:20:11PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After inputting the following nft command, set->keytype is not initialized
> but we try to destroy it, so NULL pointer dereference will happen:
>   # nft add set t s
>   Segmentation fault (core dumped)
>   #0  dtype_free (dtype=0x0) at datatype.c:1049
>   #1  set_datatype_destroy (dtype=0x0) at datatype.c:1051
>   #2  0x0000000000407f1a in set_free (set=0x838790) at rule.c:213
>   #3  0x000000000042ff70 in nft_parse (scanner=scanner@entry=0x8386a0,
>     state=state@entry=0x7ffc313ea670) at parser_bison.c:9355
>   #4  0x000000000040727d in nft_run (scanner=scanner@entry=0x8386a0,
>     state=state@entry=0x7ffc313ea670, msgs=msgs@entry=0x7ffc313ea660)
>     at main.c:237
>   #5  0x0000000000406e4a in main (argc=<optimized out>, argv=<optimized
>     out>) at main.c:376

Applied, thanks.
