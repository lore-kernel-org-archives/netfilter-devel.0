From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 net] net: free ip_vs_dest structs when refcnt=0
Date: Fri, 27 Jan 2017 13:21:11 +0100
Message-ID: <20170127122111.GA2495@salvia>
References: <1485228269-21758-1-git-send-email-dwindsor@gmail.com>
 <alpine.LFD.2.11.1701262241280.3892@ja.home.ssi.bg>
 <20170127080738.GD21195@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julian Anastasov <ja@ssi.bg>, David Windsor <dwindsor@gmail.com>,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        wensong@linux-vs.org, keescook@chromium.org,
        elena.reshetova@intel.com, ishkamiel@gmail.com
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932762AbdA0MV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 07:21:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D98916B285
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:21:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18F8710078E
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:21:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29064A7E9A
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:21:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170127080738.GD21195@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 27, 2017 at 09:07:38AM +0100, Simon Horman wrote:
> On Thu, Jan 26, 2017 at 10:49:10PM +0200, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Mon, 23 Jan 2017, David Windsor wrote:
> > 
> > > Currently, the ip_vs_dest cache frees ip_vs_dest objects when their
> > > reference count becomes < 0.  Aside from not being semantically sound,
> > > this is problematic for the new type refcount_t, which will be introduced
> > > shortly in a separate patch. refcount_t is the new kernel type for
> > > holding reference counts, and provides overflow protection and a
> > > constrained interface relative to atomic_t (the type currently being
> > > used for kernel reference counts).
> > > 
> > > Per Julian Anastasov: "The problem is that dest_trash currently holds
> > > deleted dests (unlinked from RCU lists) with refcnt=0."  Changing
> > > dest_trash to hold dest with refcnt=1 will allow us to free ip_vs_dest
> > > structs when their refcnt=0, in ip_vs_dest_put_and_free().
> > > 
> > > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > 
> > 	Thanks! I tested the first version and this one
> > just adds the needed changes in comments, so
> > 
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > 
> > 	Simon and Pablo, this is more appropriate for
> > ipvs-next/nf-next. Please apply!
> 
> Pablo, would you mind taking this one directly into nf-next?
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>

Sure, no problem. I'll take it. Thanks!
