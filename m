From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf] netfilter: don't track fragmented packets
Date: Wed, 8 Mar 2017 18:30:46 +0100
Message-ID: <20170308173046.GA8605@salvia>
References: <20170303204400.21565-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35480 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753930AbdCHRjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 12:39:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73BBB1B2B6E
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 18:30:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66BEFDA729
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 18:30:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7689BDA80C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 18:30:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170303204400.21565-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 03, 2017 at 09:44:00PM +0100, Florian Westphal wrote:
> Andrey reports syzkaller splat caused by
> 
> NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));
> 
> in ipv4 nat.  But this assertion (and the comment) are wrong, this function
> does see fragments when IP_NODEFRAG setsockopt is used.
> 
> As conntrack doesn't track packets without complete l4 header, only the
> first fragment is tracked.
> 
> Because applying nat to first packet but not the rest makes no sense this
> also turns off tracking of all fragments.

Applied, thanks Florian.
