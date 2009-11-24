From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] iptables: take masks into consideration for replace command
Date: Tue, 24 Nov 2009 16:07:32 +0100
Message-ID: <1259075255-25781-2-git-send-email-jengelh@medozas.de>
References: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36323 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbZKXPHc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:32 -0500
In-Reply-To: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The two commands:

-A OUPUT -d 10.11.12.13/32 -j LOG
-R OUTPUT 1 -j LOG -d 10.11.12.13

will replace 10.11.12.13/32 by 10.11.12.13/0, which is not right.
(No regression, this problem was there forever.)

Reported-by: Werner Pawlitschko <werner.pawlitschko@arcor.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   10 ++++++----
 iptables.c  |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index f6daa51..e2359df 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -758,13 +758,15 @@ static int
 replace_entry(const ip6t_chainlabel chain,
 	      struct ip6t_entry *fw,
 	      unsigned int rulenum,
-	      const struct in6_addr *saddr,
-	      const struct in6_addr *daddr,
+	      const struct in6_addr *saddr, const struct in6_addr *smask,
+	      const struct in6_addr *daddr, const struct in6_addr *dmask,
 	      int verbose,
 	      struct ip6tc_handle *handle)
 {
 	fw->ipv6.src = *saddr;
 	fw->ipv6.dst = *daddr;
+	fw->ipv6.smsk = *smask;
+	fw->ipv6.dmsk = *dmask;
 
 	if (verbose)
 		print_firewall_line(fw, handle);
@@ -1947,8 +1949,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
-				    saddrs, daddrs, options&OPT_VERBOSE,
-				    *handle);
+				    saddrs, smasks, daddrs, dmasks,
+				    options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
diff --git a/iptables.c b/iptables.c
index a69aab3..08eb134 100644
--- a/iptables.c
+++ b/iptables.c
@@ -760,13 +760,15 @@ static int
 replace_entry(const ipt_chainlabel chain,
 	      struct ipt_entry *fw,
 	      unsigned int rulenum,
-	      const struct in_addr *saddr,
-	      const struct in_addr *daddr,
+	      const struct in_addr *saddr, const struct in_addr *smask,
+	      const struct in_addr *daddr, const struct in_addr *dmask,
 	      int verbose,
 	      struct iptc_handle *handle)
 {
 	fw->ip.src.s_addr = saddr->s_addr;
 	fw->ip.dst.s_addr = daddr->s_addr;
+	fw->ip.smsk.s_addr = smask->s_addr;
+	fw->ip.dmsk.s_addr = dmask->s_addr;
 
 	if (verbose)
 		print_firewall_line(fw, handle);
@@ -1988,8 +1990,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
-				    saddrs, daddrs, options&OPT_VERBOSE,
-				    *handle);
+				    saddrs, smasks, daddrs, dmasks,
+				    options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
-- 
1.6.5.2

