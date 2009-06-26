From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/10] iptables: allow for parse-less extensions
Date: Fri, 26 Jun 2009 21:19:46 +0200
Message-ID: <1246043992-379-5-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39663 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761312AbZFZTUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:09 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This means we can do some code removal in extensions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    9 +++++----
 iptables.c  |    9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 31c4b45..71ff46f 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1699,13 +1699,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			if (!target
-			    || !(target->parse(c - target->option_offset,
+			if (target == NULL || target->parse == NULL ||
+			    !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t))) {
+					       &fw, &target->t)) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed)
+					if (matchp->completed ||
+					    matchp->match->parse == NULL)
 						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
diff --git a/iptables.c b/iptables.c
index 7c075da..cc17576 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1727,13 +1727,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			exit_tryhelp(2);
 
 		default:
-			if (!target
-			    || !(target->parse(c - target->option_offset,
+			if (target == NULL || target->parse == NULL ||
+			    !target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t))) {
+					       &fw, &target->t)) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed)
+					if (matchp->completed ||
+					    matchp->match->parse == NULL)
 						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
-- 
1.6.3.2

