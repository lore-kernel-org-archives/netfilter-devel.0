From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/8] iptables: use variable as shortcut in parse loop
Date: Fri,  4 Feb 2011 14:08:49 +0100
Message-ID: <1296824935-4606-4-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36766 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1BDNI7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:08:59 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"m" is around, so use it, cut the code.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   17 ++++++++---------
 iptables.c  |   17 ++++++++---------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index f581509..caee730 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1714,17 +1714,16 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					       &fw, &target->t))
 				break;
 			for (matchp = matches; matchp; matchp = matchp->next) {
-				if (matchp->completed ||
-				    matchp->match->parse == NULL)
+				m = matchp->match;
+
+				if (matchp->completed || m->parse == NULL)
 					continue;
-				if (c < matchp->match->option_offset ||
-				    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+				if (c < m->option_offset ||
+				    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
 					continue;
-				if (matchp->match->parse(c - matchp->match->option_offset,
-					     argv, invert,
-					     &matchp->match->mflags,
-					     &fw,
-					     &matchp->match->m)) {
+				if (m->parse(c - matchp->match->option_offset,
+					     argv, invert, &m->mflags, &fw,
+					     &m->m)) {
 					stop = true;
 					break;
 				}
diff --git a/iptables.c b/iptables.c
index b957e66..db8e136 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1746,17 +1746,16 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					       &fw, &target->t))
 				break;
 			for (matchp = matches; matchp; matchp = matchp->next) {
-				if (matchp->completed ||
-				    matchp->match->parse == NULL)
+				m = matchp->match;
+
+				if (matchp->completed || m->parse == NULL)
 					continue;
-				if (c < matchp->match->option_offset ||
-				    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+				if (c < m->option_offset ||
+				    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
 					continue;
-				if (matchp->match->parse(c - matchp->match->option_offset,
-					     argv, invert,
-					     &matchp->match->mflags,
-					     &fw,
-					     &matchp->match->m)) {
+				if (m->parse(c - matchp->match->option_offset,
+					     argv, invert, &m->mflags, &fw,
+					     &m->m)) {
 					stop = true;
 					break;
 				}
-- 
1.7.1

