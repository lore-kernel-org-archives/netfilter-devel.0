From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: convert htonl to ntohl
 properly
Date: Sun, 4 Dec 2016 21:14:02 +0100
Message-ID: <20161204201402.GA32587@salvia>
References: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbcLDUOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:14:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DC80B6C76
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FA5FDA85F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AC70DA85F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:14:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 23, 2016 at 10:12:20PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Acctually ntohl and htonl are identical, so this doesn't affect
> anything, but it is conceptually wrong.

Applied, thanks Liping.
