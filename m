From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 6/6] ipset: Add iptreemap to the list of supported set types
Date: Sun, 29 Jun 2008 19:45:03 +0200
Message-ID: <1214761503-1713-7-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44962 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYF2RpU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:20 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 patchlets/set/help |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patchlets/set/help b/patchlets/set/help
index 305498f..9940ce8 100644
--- a/patchlets/set/help
+++ b/patchlets/set/help
@@ -3,8 +3,8 @@ IP sets; the match depends on whether a checked source or destination
 address/network address/port has its bit set in/added to the given set.
 It also provides a SET target, which can be used to add or remove the 
 addresses/ports of a packet to/from a set. The currently supported types 
-of the sets are: ipmap, macipmap, portmap, iphash, nethash, ipporthash
-and iptree. 
+of the sets are: ipmap, macipmap, portmap, iphash, nethash, ipporthash,
+iptree and iptreemap. 
 
 It is possible to chain sets together by binding.
 
-- 
1.5.6.1

