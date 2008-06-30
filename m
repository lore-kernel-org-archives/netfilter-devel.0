From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Fwd: [PATCH] nf_nat_core: eliminate find_appropriate_src call if range is set IP_NAT_RANGE_PROTO_RANDOM bit on
Date: Mon, 30 Jun 2008 16:00:43 +0800
Message-ID: <412e6f7f0806300100t6bc37635pc922405705f1784d@mail.gmail.com>
References: <412e6f7f0806292132l18c747d6h982c64ce7c9d9c85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:48203 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYF3IAp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:00:45 -0400
Received: by ti-out-0910.google.com with SMTP id b6so734204tic.23
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2008 01:00:43 -0700 (PDT)
In-Reply-To: <412e6f7f0806292132l18c747d6h982c64ce7c9d9c85@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---------- Forwarded message ----------
From: Changli Gao <xiaosuo@gmail.com>
Date: 2008/6/30
Subject: [PATCH] nf_nat_core: eliminate find_appropriate_src call if
range is set IP_NAT_RANGE_PROTO_RANDOM bit on
To: netfilter-devel@lists.netfilter.org
Cc: Changli Gao <xiaosuo@gmail.com>


Eliminate find_appropriate_src call if range is set
IP_NAT_RANGE_PROTO_RANDOM bit on.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 nf_nat_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- net/ipv4/netfilter/nf_nat_core.c.orig       2008-06-30
11:12:26.000000000 +0800
+++ net/ipv4/netfilter/nf_nat_core.c    2008-06-30 12:22:23.000000000 +0800
@@ -240,12 +240,12 @@
          This is only required for source (ie. NAT/masq) mappings.
          So far, we don't do local source mappings, so multiple
          manips not an issue.  */
-       if (maniptype == IP_NAT_MANIP_SRC) {
+       if (maniptype == IP_NAT_MANIP_SRC &&
+           !(range->flags & IP_NAT_RANGE_PROTO_RANDOM)) {
               if (find_appropriate_src(orig_tuple, tuple, range)) {
                       pr_debug("get_unique_tuple: Found current src map\n");
-                       if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
-                               if (!nf_nat_used_tuple(tuple, ct))
-                                       return;
+                       if (!nf_nat_used_tuple(tuple, ct))
+                               return;
               }
       }

--
Regards，
Changli Gao(xiaosuo@gmail.com)



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
