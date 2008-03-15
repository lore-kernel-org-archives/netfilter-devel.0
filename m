From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] NETFILTER: Use non-deprecated __RW_LOCK_UNLOCKED macro.
Date: Sat, 15 Mar 2008 14:35:36 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0803151434070.25221@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:32814 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYCOSfk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Mar 2008 14:35:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  not compile tested, but fairly obvious, no?


 net/bridge/netfilter/ebtable_broute.c |    2 +-
 net/bridge/netfilter/ebtable_filter.c |    2 +-
 net/bridge/netfilter/ebtable_nat.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index be6f186..246626b 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -46,7 +46,7 @@ static struct ebt_table broute_table =
 	.name		= "broute",
 	.table		= &initial_table,
 	.valid_hooks	= 1 << NF_BR_BROUTING,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(broute_table.lock),
 	.check		= check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index fb81090..690bc3a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -55,7 +55,7 @@ static struct ebt_table frame_filter =
 	.name		= "filter",
 	.table		= &initial_table,
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(frame_filter.lock),
 	.check		= check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index bc71273..5b495fe 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -55,7 +55,7 @@ static struct ebt_table frame_nat =
 	.name		= "nat",
 	.table		= &initial_table,
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(frame_nat.lock),
 	.check		= check,
 	.me		= THIS_MODULE,
 };

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
