From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter spurious ELOOP
Date: Wed, 25 Mar 2009 19:41:49 +0100
Message-ID: <49CA7AED.3050705@trash.net>
References: <200903242302.n2ON25u4024288@givry.fdupont.fr> <20090324.162808.114465835.davem@davemloft.net> <49CA64D8.9040602@trash.net> <20090325173742.3C509E601C@farside.isc.org> <49CA741D.3080705@trash.net> <49CA7A19.8040805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070508080107010306050803"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37019 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700AbZCYSl5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:41:57 -0400
In-Reply-To: <49CA7A19.8040805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070508080107010306050803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> The same bug was also present in ip6_tables and arp_tables.
> This is the patch I've committed:

Thomas, I think this is likely to fix the ELOOP problem you reported
in 2007 that we've never managed to track down:


--------------070508080107010306050803
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 1f9352ae2253a97b07b34dcf16ffa3b4ca12c558
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Mar 25 19:26:35 2009 +0100

    netfilter: {ip,ip6,arp}_tables: fix incorrect loop detection
    
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
index 4b35dba..4f454ce 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -388,7 +388,9 @@ static int mark_source_chains(struct xt_table_info *newinfo,
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
index 41c59e3..82ee7c9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -488,7 +488,9 @@ mark_source_chains(struct xt_table_info *newinfo,
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
index e59662b..e89cfa3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -517,7 +517,9 @@ mark_source_chains(struct xt_table_info *newinfo,
 			    && unconditional(&e->ipv6)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    IP6T_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);

--------------070508080107010306050803--
