From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/41]: bridge netfilter: use non-deprecated __RW_LOCK_UNLOCKED macro.
Date: Mon, 14 Apr 2008 12:16:23 +0200 (MEST)
Message-ID: <20080414101620.32717.40711.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36240 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYDNKQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:25 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: bridge netfilter: use non-deprecated __RW_LOCK_UNLOCKED macro.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8d2a75d2ec1d4b66a9401235cfca89e4f0c488a6
tree 606c0fa5f5199becf65778ffc4acf31a08438236
parent 28c0a96112ab07947d3070b0d81ab63d8f7bb3a2
author Robert P. J. Day <rpjday@crashcourse.ca> Mon, 14 Apr 2008 12:10:39 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:39 +0200

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
