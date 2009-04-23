From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 049/100] netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection
Date: Thu, 23 Apr 2009 00:21:09 -0700
Message-ID: <20090423072602.697761388@sous-sol.org>
References: <20090423072020.428683652@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:50372 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756386AbZDWHaN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:13 -0400
Content-Disposition: inline; filename=netfilter-ip-ip6-arp-_tables-fix-incorrect-loop-detection.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

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

