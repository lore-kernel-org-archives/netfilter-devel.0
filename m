From: Patrick McHardy <kaber@trash.net>
Subject: netfilter -stable: {ip,ip6,arp}_tables: fix incorrect loop detection
Date: Mon, 06 Apr 2009 17:31:29 +0200
Message-ID: <49DA2051.5030507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070500090408040407080504"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48936 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZDFPbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:31:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070500090408040407080504
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a long-standing regression in the *tables loop
checking algorithm, causing false positives. The regression has
been introduced around 2.6.20.

Please apply, thanks.


--------------070500090408040407080504
Content-Type: text/x-patch;
 name="loop-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="loop-fix.diff"

commit 2a95edbf4d9827b047c00169947d13fde210dc1d
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Apr 6 17:27:51 2009 +0200

    netfilter: {ip,ip6,arp}_tables: fix incorrect loop detection
    
    Upstream commit 1f9352ae:
    
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

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7ea88b6..39879ae 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -374,7 +374,9 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 			    && unconditional(&e->arp)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    ARPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index ef8b6ca..ec362a3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -496,7 +496,9 @@ mark_source_chains(struct xt_table_info *newinfo,
 			    && unconditional(&e->ip)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+			    		    IPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a33485d..def375b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -525,7 +525,9 @@ mark_source_chains(struct xt_table_info *newinfo,
 			    && unconditional(&e->ipv6)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    IP6T_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);

--------------070500090408040407080504--
