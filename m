From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: nft removes required payload protocol
 expressions
Date: Fri, 7 Apr 2017 00:50:26 +0200
Message-ID: <20170406225026.GA2663@salvia>
References: <20170323081156.17727-1-fw@strlen.de>
 <20170406164100.GA7143@salvia>
 <20170406184547.GA10969@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdDFWud (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:50:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BCAD137B8A
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:50:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE6C6DA7E9
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:50:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F338EDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:50:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170406184547.GA10969@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 06, 2017 at 08:45:47PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Mar 23, 2017 at 09:11:56AM +0100, Florian Westphal wrote:
> > > This test fails with
> > > 'ip protocol tcp tcp dport 22' mismatches 'tcp dport 22'
> > > 
> > > ip protocol tcp tcp dport 22 is *ONLY* identical to
> > > 'tcp dport 22' in the ip family.
> > > 
> > > For netdev/inet/bridge, the dependency is required because
> > > we only want to match ipv4 packets.
> > 
> > This needs the C chunk to fix this, right? so I let you decide if you
> > want to push out this test now or make it together with the fix.
> 
> I have no fix at the moment.
> 
> I will thus probably push this test when I get home so we don't forget
> about it.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
