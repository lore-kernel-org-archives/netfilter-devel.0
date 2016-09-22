From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next V2] netfilter: nft_queue: add _SREG_QNUM attr to
 select the queue number
Date: Thu, 22 Sep 2016 17:11:07 +0200
Message-ID: <20160922151107.GA17587@salvia>
References: <1473867706-50854-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933580AbcIVPLU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:11:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0297BC106E
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:11:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E50E8DA846
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:11:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8BFCBDA81A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:11:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473867706-50854-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 14, 2016 at 11:41:46PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Currently, the user can specify the queue numbers by _QUEUE_NUM and
> _QUEUE_TOTAL attributes, this is enough in most situations.
> 
> But acctually, it is not very flexible, for example:
>   tcp dport 80 mapped to queue0
>   tcp dport 81 mapped to queue1
>   tcp dport 82 mapped to queue2
> In order to do this thing, we must add 3 nft rules, and more
> mapping meant more rules ...
> 
> So take one register to select the queue number, then we can add one
> simple rule to mapping queues, maybe like this:
>   queue num tcp dport map { 80:0, 81:1, 82:2 ... }
> 
> Florian Westphal also proposed wider usage scenarios:
>   queue num jhash ip saddr . ip daddr mod ...
>   queue num meta cpu ...
>   queue num meta mark ...
> 
> The last point is how to load a queue number from sreg, although we can
> use *(u16*)&regs->data[reg] to load the queue number, just like nat expr
> to load its l4port do.
> 
> But we will cooperate with hash expr, meta cpu, meta mark expr and so on.
> They all store the result to u32 type, so cast it to u16 pointer and
> dereference it will generate wrong result in the big endian system.
> 
> So just keep it simple, we treat queue number as u32 type, although u16
> type is already enough.

Applied, thanks Liping.
