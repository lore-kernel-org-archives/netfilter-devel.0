From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: init all_locks to avoid debug
 warning
Date: Fri, 29 Apr 2016 11:27:42 +0200
Message-ID: <20160429092742.GA14700@salvia>
References: <1461453434-4271-1-git-send-email-fw@strlen.de>
 <20160429092307.GA13111@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58938 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbcD2J1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:27:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE795C9ECE
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:27:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A2D41100A4E
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:27:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D6355100A73
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:27:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160429092307.GA13111@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 29, 2016 at 11:23:07AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Apr 24, 2016 at 01:17:14AM +0200, Florian Westphal wrote:
> > Else we get 'BUG: spinlock bad magic on CPU#' on resize when
> > spin lock debugging is enabled.
> 
> Applied, thanks Florian.

Wait, probably better this?

--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

commit 70d72b7e060e0a16b9ded9d0fbd3dff109743de3
Author: Florian Westphal <fw@strlen.de>
Date:   Sun Apr 24 01:17:14 2016 +0200

    netfilter: conntrack: init all_locks to avoid debug warning
    
    Else we get 'BUG: spinlock bad magic on CPU#' on resize when
    spin lock debugging is enabled.
    
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index afde5f5..895d11d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(nf_conntrack_expect_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 
-static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
+static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)

--Kj7319i9nmIyA2yE--
