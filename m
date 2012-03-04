From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c
 execution
Date: Sun, 4 Mar 2012 12:01:51 +0100
Message-ID: <20120304110151.GA22404@1984>
References: <4F50E30B.6000704@gmail.com>
 <20120303133002.GA18802@1984>
 <jitp0d$4lv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Cc: netfilter-devel@vger.kernel.org
To: Kerin Millar <kerframil@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46572 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2CDLBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Mar 2012 06:01:55 -0500
Content-Disposition: inline
In-Reply-To: <jitp0d$4lv$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kerin,

On Sat, Mar 03, 2012 at 06:47:27PM +0000, Kerin Millar wrote:
> Hi,
> 
> On 03/03/2012 13:30, Pablo Neira Ayuso wrote:
> >I just posted another patch to the ML that is a relative fix to
> >Jozsef's patch. You have to apply that as well.
> 
> I've now tested 3.3-rc5 with the addition of the above mentioned
> follow-on patch. The behaviour during conntrackd -c execution is
> clearly much improved - in so far as it doesn't generate much noise
> - but the crash that follows remains. Here's a netconsole capture:-
> 
> http://paste.pocoo.org/raw/560439/

Great to know :-).

Regarding your previous email, I'm sorry, by reading your email I
thought you were using 2.6.32 which was not the case, your
configuration is perfectly reasonable.

It seems we still have problems regarding early_drop, but this time
with reliable event delivery enabled (15 seconds is the time that
is required to retry sending the destroy event).

If you can test the following patch, I'll appreciate.

Thank you.

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_conntrack-fix-early_drop-with-reliable-.patch"

>From 1320c099d618a278fa17715127d6fecca2786a36 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 4 Mar 2012 11:34:06 +0100
Subject: [PATCH] netfilter: nf_conntrack: fix early_drop with reliable event
 delivery

With reliable event delivery is enabled, if we fail to deliver the
destroy event in early_drop, we put out one entry that is still in
the dying list.

Reported-by: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ed86a3b..7d2d641 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -635,6 +635,11 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 
 	if (del_timer(&ct->timeout)) {
 		death_by_timeout((unsigned long)ct);
+		/* Check if we indeed killed this entry. Reliable event
+		   delivery may insert this into the dying list. */
+		if (!test_bit(IPS_DYING_BIT, &ct->status))
+			return dropped;
+
 		dropped = 1;
 		NF_CT_STAT_INC_ATOMIC(net, early_drop);
 	}
-- 
1.7.7.3


--lrZ03NoBR/3+SXJZ--
