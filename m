From: Florian Westphal <fw@strlen.de>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 12:52:02 +0100
Message-ID: <20150212115202.GD22887@breakpoint.cc>
References: <20150212102553.0bd25767@bother.homenet>
 <20150212105145.5e0177c0@bother.homenet>
 <20150212110931.6db17d7c@bother.homenet>
 <20150212113643.GA13795@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Vine <chris@cvine.freeserve.co.uk>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45411 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302AbbBLLwD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 06:52:03 -0500
Content-Disposition: inline
In-Reply-To: <20150212113643.GA13795@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> I'll see if we can fix this in a better way.

What about this, it will transparently grow the table as needed,
we simply have to take the lock and make sure we zap all existing
entries (needed since those entries don't have enough room for
the larger nstamp_mask entry count)?

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -378,12 +378,11 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(recent_net, info->name);
 	if (t != NULL) {
-		if (info->hit_count > t->nstamps_max_mask) {
-			pr_info("hitcount (%u) is larger than packets to be remembered (%u) for table %s\n",
-				info->hit_count, t->nstamps_max_mask + 1,
-				info->name);
-			ret = -EINVAL;
-			goto out;
+		if (nstamp_mask > t->nstamps_max_mask) {
+			spin_lock_bh(&recent_lock);
+			recent_table_flush(t);
+			t->nstamps_max_mask = nstamp_mask;
+			spin_unlock_bh(&recent_lock);
 		}
 
 		t->refcnt++;
