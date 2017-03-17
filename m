From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] net, netfilter refcounter conversions
Date: Fri, 17 Mar 2017 12:50:41 +0100
Message-ID: <20170317115041.GA4979@salvia>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
 <20170315130213.GA30233@salvia>
 <2236FBA76BA1254E88B949DDB74E612B41C59A26@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdCQLwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 07:52:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4870DBDF55
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:50:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38D7EFB46A
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:50:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 658D8EBACC
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:50:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C59A26@IRSMSX102.ger.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 07:52:19AM +0000, Reshetova, Elena wrote:
> 
> > On Wed, Mar 15, 2017 at 01:10:38PM +0200, Elena Reshetova wrote:
> > > This series, for the netfilter subsystem, replaces atomic_t reference
> > > counters with the new refcount_t type and API (see include/linux/refcount.h).
> > > By doing this we prevent intentional or accidental
> > > underflows or overflows that can led to use-after-free vulnerabilities.
> > >
> > > Please take the series to your tree if there are no run-time issues.
> > 
> > Could you collapse all of your patches into one single? They are all
> > part of the same logical change to me.
> > 
> > >  21 files changed, 85 insertions(+), 75 deletions(-)
> > 
> > The diffstat is small enough to do what I'm asking.
> 
> Sure. The reason why they are separated is that it is easier to
> review them this way IMO and find mistakes (I found many after I
> split all networking patches into one per variable).  But I guess
> for merge, it is easier to have them collapsed, so I am going to
> send you a new version shortly.

In my particular case, collapsing them is good so the Netfilter batch
I pass up to David becomes smaller. Thanks!
