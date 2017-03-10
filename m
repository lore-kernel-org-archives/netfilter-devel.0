From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] libxtables: avoid returning duplicate address for
 host resolution
Date: Fri, 10 Mar 2017 19:22:19 +0100
Message-ID: <20170310182219.GA26144@salvia>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162658.5697-1-jengelh@inai.de>
 <20170308162658.5697-4-jengelh@inai.de>
 <20170308164502.GA4076@salvia>
 <alpine.LSU.2.20.1703081753170.6259@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932610AbdCJSW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 13:22:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C5261B8407
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:22:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AE2CDA809
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:22:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53F91DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:22:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1703081753170.6259@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 05:56:43PM +0100, Jan Engelhardt wrote:
> On Wednesday 2017-03-08 17:45, Pablo Neira Ayuso wrote:
> 
> >On Wed, Mar 08, 2017 at 05:26:58PM +0100, Jan Engelhardt wrote:
> >> A long-standing problem has been that `iptables -s any_host_here`
> >> could yield multiple rules with the same address if the DNS was
> >> indeed so populated.
> >
> >When did anyone report this problem out of the localhost case?
> 
> It's been a long time. I think the issue was actually that one can 
> specify multiple host names, and if those hostnames happen to resolve to 
> the same address in the end, iptables would emit two rules of which one 
> is essentially redundant.
> 
>   iptables -A INPUT -s www2.company.com,www3.company.com

Got me thinking, are you sure we want to fix this?

I think this rule expansion based on DNS is probably one of the most
creepy features that we have in iptables... Probably if we leave it
broken this will just scare people away from using this :).

But your call.
