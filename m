From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: fix build failure with CONNTRACK=n
 NF_DEFRAG=y
Date: Tue, 6 Dec 2016 11:16:09 +0100
Message-ID: <20161206101609.GA2311@salvia>
References: <201612050556.WPB56g03%fengguang.wu@intel.com>
 <1480891042-6731-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41854 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbcLFKWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:22:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CFB6B8CD66
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:16:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCAA1A7D44
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:16:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DFD8A7D45
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:16:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480891042-6731-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 04, 2016 at 11:37:22PM +0100, Florian Westphal wrote:
> conntrack depends on defrag support, but not vice versa, so we cannot
> place defrag_ipv4/6 into netns->ct:
> 
> net/ipv4/netfilter/nf_defrag_ipv4.c:110:9: error: 'struct net' has no member named 'ct'
> 
> Move it into net->nf.

Applied, thanks Florian.
