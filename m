From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/13] ip[6]tables: only call target's parse function when option char is in range
Date: Sat,  8 Jan 2011 16:20:09 +0100
Message-ID: <1294500015-10691-9-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32898 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1AHPUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:25 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same as previous commit. Doing this actually allows to remove code
that is no longer needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    2 ++
 iptables.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 4ca4bfe..d4c2339 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1706,6 +1706,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		default:
 			if (target == NULL || target->parse == NULL ||
+			    c < target->option_offset ||
+			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
 			    !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
diff --git a/iptables.c b/iptables.c
index bcacd49..b45211a 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1738,6 +1738,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		default:
 			if (target == NULL || target->parse == NULL ||
+			    c < target->option_offset ||
+			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
 			    !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-- 
1.7.1

