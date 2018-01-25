From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_match()
Date: Thu, 25 Jan 2018 01:13:36 +0100
Message-ID: <20180125001336.ilboagwlcpck54ip@salvia>
References: <1516834188.3715.35.camel@gmail.com>
 <20180124231952.GC14192@breakpoint.cc>
 <20180124235056.ahubcyqostttvtbx@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932293AbeAYANm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 19:13:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB4021BFA8A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 01:13:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC1FFB7FE3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 01:13:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180124235056.ahubcyqostttvtbx@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 25, 2018 at 12:50:56AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 25, 2018 at 12:19:52AM +0100, Florian Westphal wrote:
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > It looks like syzbot found its way into netfilter territory.
> > 
> > Excellent.  This will sure allow to find and fix more bugs :-)
> > 
> > > Issue here is that @name comes from user space and might
> > > not be null terminated.
> > 
> > Indeed, thanks for fixing this Eric.
> > 
> > xt_find_target() and xt_find_table_lock() might have similar issues.
> 
> I'm going to keep back this patch then, it would be good if we can
> find this in one single patch.

s/find/fix/

Sorry.
