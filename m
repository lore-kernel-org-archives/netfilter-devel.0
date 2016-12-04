From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_log: do not assume ethernet header
 in netdev family
Date: Sun, 4 Dec 2016 20:44:04 +0100
Message-ID: <20161204194404.GA3516@salvia>
References: <1479134365-18623-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbcLDToJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 14:44:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F137511E588
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0334DA848
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA381DA853
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479134365-18623-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 14, 2016 at 10:39:25PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> In netdev family, we will handle non ethernet packets, so using
> eth_hdr(skb)->h_proto is incorrect.
> 
> Meanwhile, we can use socket(AF_PACKET...) to sending packets, so
> skb->protocol is not always set in bridge family.
> 
> Add an extra parameter into nf_log_l2packet to solve this issue.

Applied, thanks Liping.
