From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3 0/7] switch l4 dependency to meta l4proto
Date: Tue, 23 May 2017 23:21:46 +0200
Message-ID: <20170523212146.GA8918@salvia>
References: <20170519201111.7402-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033373AbdEWVWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:22:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FA4AE122E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:21:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 011A6FF2E2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:21:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E49D318521
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:21:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519201111.7402-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 10:11:04PM +0200, Florian Westphal wrote:
> Currently nft inserts different types of dependencies for l4 protocols,
> depending on the family.
> 
> For inet, nft inserts 'meta l4proto' to e.g. check for tcp, for
> ip, nft uses 'ip protocol'. Both are fine.  The ip6 family however
> uses 'ip6 nexthdr', and thats a problem because e.g. tcp dport 22 will
> not match packets that use ipv6 extension headers.
> 
> The series switches both ipv6 and ipv4 to use meta l4 instead
> so ipv6 will always check the last transport header value.
> 
> We could ignore ip as only ipv6 uses extension headers.
> However, switching ipv4 as well makes things a bit simpler because nft
> then creates the same l4 dependency for all families.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
