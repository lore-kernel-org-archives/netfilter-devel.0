From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net: netfilter: Replace explicit NULL comparison with !
 operator
Date: Tue, 4 Apr 2017 19:56:00 +0200
Message-ID: <20170404175600.GB1154@salvia>
References: <20170329101406.GA29770@arushi-HP-Pavilion-Notebook>
 <20170404174111.GB7257@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wensong@linux-vs.org, Simon Horman <horms@verge.net.au>,
        outreachy-kernel@googlegroups.com, Julian Anastasov <ja@ssi.bg>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        davem@davemloft.net, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753188AbdDDR4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 13:56:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6406FF2D2
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2017 19:56:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D462C9D699
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2017 19:56:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A3A49D692
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2017 19:56:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170404174111.GB7257@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 04, 2017 at 01:41:11PM -0400, Simon Horman wrote:
> On Wed, Mar 29, 2017 at 03:45:01PM +0530, Arushi Singhal wrote:
> > Replace explicit NULL comparison with ! operator to simplify code.
> > 
> > Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> > ---
> >  net/netfilter/ipvs/ip_vs_ctl.c         |  8 ++---
> >  net/netfilter/ipvs/ip_vs_proto.c       |  8 ++---
> 
> I count 18 instances of "!= NULL in net/netfilter/ipvs/ip_vs_proto but this
> patch only seems to update 8 of them. I would prefer to fix all or none of
> them.

Agreed.

Please address all instances and resubmit.
