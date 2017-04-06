From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: nat: Correct the return value
 check for nat mangled packet
Date: Thu, 6 Apr 2017 21:18:19 +0200
Message-ID: <20170406191819.GA3749@salvia>
References: <1490627528-32491-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753922AbdDFTSd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 15:18:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9FC811E58A
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:18:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA6F2DA807
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:18:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCE89DA848
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:18:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490627528-32491-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 27, 2017 at 11:12:08PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The return value type of function nf_nat_mangle_tcp/udp_packet is
> int, but actually it is used as bool type. And most codes follow
> this rule, for example, the sip, h323, and ftp. But some codes treat
> the return value as NF_ACCEPT and NF_DROP, like amanda and irc.
> 
> Now use the bool type instead of the int to make it clear.

One spot still not converted.

I'm going to collapse this patch to yours. Please review so you don't
have to send a v3.
