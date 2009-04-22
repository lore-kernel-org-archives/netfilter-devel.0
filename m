From: chrisw@sous-sol.org
Subject: patch netfilter-ip-ip6-arp-_tables-fix-incorrect-loop-detection.patch queued to 2.6.29-stable tree
Date: Tue, 21 Apr 2009 17:05:02 -0700
Message-ID: <200904220005.n3M052k5012161@x200.localdomain>
References: <49DA2051.5030507@trash.net>
Cc: stable@kernel.org, stable-commits@vger.kernel.org
To: kaber@trash.net, chrisw@sous-sol.org, davem@davemloft.net,
	Francis_Dupont@isc.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:45511 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753852AbZDVALm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:11:42 -0400
In-Reply-To: <49DA2051.5030507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection

to the 2.6.29-stable tree.  Its filename is

     netfilter-ip-ip6-arp-_tables-fix-incorrect-loop-detection.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Mon Apr  6 15:33:13 2009
Message-ID: <49DA2051.5030507@trash.net>
Date: Mon, 06 Apr 2009 17:31:29 +0200
From: Patrick McHardy <kaber@trash.net>
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,         "David S. Miller" <davem@davemloft.net>
Subject: netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection

upstream commit: 1f9352ae2253a97b07b34dcf16ffa3b4ca12c558

Commit e1b4b9f ([NETFILTER]: {ip,ip6,arp}_tables: fix exponential worst-case
search for loops) introduced a regression in the loop detection algorithm,
causing sporadic incorrectly detected loops.

When a chain has already been visited during the check, it is treated as
having a standard target containing a RETURN verdict directly at the
beginning in order to not check it again. The real target of the first
rule is then incorrectly treated as STANDARD target and checked not to
contain invalid verdicts.

Fix by making sure the rule does actually contain a standard target.

Based on patch by Francis Dupont <Francis_Dupont@isc.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
---
 net/ipv4/netfilter/arp_tables.c |    4 +++-
 net/ipv4/netfilter/ip_tables.c  |    4 +++-
 net/ipv6/netfilter/ip6_tables.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -374,7 +374,9 @@ static int mark_source_chains(struct xt_
 			    && unconditional(&e->arp)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    ARPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -496,7 +496,9 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ip)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+			    		    IPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -525,7 +525,9 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ipv6)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    IP6T_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);


Patches currently in stable-queue which might be from kaber@trash.net are

queue-2.6.29/netfilter-ip-ip6-arp-_tables-fix-incorrect-loop-detection.patch
