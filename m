From: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 10:25:53 +0000
Message-ID: <20150212102553.0bd25767@bother.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sidious.london.02.net ([82.132.130.152]:59254 "EHLO
	mail.o2.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbbBLKcT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 05:32:19 -0500
Received: from bother.homenet (82.132.232.222) by mail.o2.co.uk (8.5.140.03)
        id 54DB28DA00581385 for netfilter-devel@vger.kernel.org; Thu, 12 Feb 2015 10:25:53 +0000
Received: from bother.homenet (localhost [127.0.0.1])
	by bother.homenet (Postfix) with ESMTP id 162708CC32
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2015 10:25:53 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Loading 'recent' xtables match support for iptables fails where the
following sample rule is appended with SSH_TRIES set to 4:

  iptables -A SSH_CHAIN -m conntrack --ctstate NEW \
    -m recent --update --seconds $SSH_LOGIN_PERIOD --hitcount $SSH_TRIES -j DROP

It fails with this message:

  kernel: xt_recent: hitcount (4) is larger than packets to be
  remembered (4) for table DEFAULT

This appears to be due to an off-by-one error in testing the hit count in
recent_mt_check().  This occurs because nstamp_mask is set to one less than
the value of ip_pkt_list_tot (if any) or of hit_count rounded up to a power
of two value.  When that hit count boundary is actually reached nstamp_mask
is therefore exceeded by one.

I can't say I fully understand the heuristics of nstamp_mask, but the
patch below deals with this and works for me(TM).

Signed-of-by: Chris Vine <vine.chris@gmail.com>

--- linux-3.19.0/net/netfilter/xt_recent.c~	2015-02-10 09:18:44.657376355 +0000
+++ linux-3.19.0/net/netfilter/xt_recent.c	2015-02-11 17:58:33.311608835 +0000
@@ -378,7 +378,7 @@
 	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(recent_net, info->name);
 	if (t != NULL) {
-		if (info->hit_count > t->nstamps_max_mask) {
+		if (info->hit_count > t->nstamps_max_mask + 1) {
 			pr_info("hitcount (%u) is larger than packets to be remembered (%u) for table %s\n",
 				info->hit_count, t->nstamps_max_mask + 1,
 				info->name);
