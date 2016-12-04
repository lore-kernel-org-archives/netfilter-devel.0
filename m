From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 1/1] netfilter: xt_multiport: Fix wrong
 unmatch result with multiple ports
Date: Sun, 4 Dec 2016 21:13:17 +0100
Message-ID: <20161204201317.GA32558@salvia>
References: <1480048327-11209-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDUN2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:13:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 263A5B6C6B
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:13:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 186A6DA85F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:13:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF293DA862
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:13:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480048327-11209-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 12:32:07PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> I lost one test case in the last commit for xt_multiport.
> For example, the rule is "-m multiport --dports 22,80,443".
> When first port is unmatched and the second is matched, the curent codes
> could not return the right result.
> It would return false directly when the first port is unmatched.

Applied.
