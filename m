From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_fib_ipv4: initialize *dest to zero
Date: Sun, 4 Dec 2016 21:14:14 +0100
Message-ID: <20161204201413.GB32587@salvia>
References: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
 <1479910341-40744-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbcLDUOW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:14:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11670B6C6F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01866DA849
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 140F4DA848
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479910341-40744-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 23, 2016 at 10:12:21PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, if fib lookup fail, *dest will be filled with garbage value,
> so reverse path filtering will not work properly:
>  # nft add rule x prerouting fib saddr oif eq 0 drop

Also applied, thanks.
