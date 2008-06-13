From: Jan Engelhardt <jengelh@medozas.de>
Subject: Line numbering broken since bb34082d
Date: Fri, 13 Jun 2008 11:14:58 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806131107340.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: henrik@henriknordstrom.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47829 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYFMJO7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:14:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


`iptables -nvL --lin`, starting with bb34082de, gives a wrong count:

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               
destination         
2        0     0 LOG        all  --  *      *       0.0.0.0/0            
0.0.0.0/0           LOG flags 0 level 4 


Yes, it starts with '2'. The offending part is 
because now you increased num before calling print_firewal.

-                       print_firewall(i,
-                                      ip6tc_get_target(i, handle),
-                                      num++,
-                                      format,
-                                      *handle);
+                       num++;
+                       if (!rulenum || num == rulenum)
+                               print_firewall(i,
+                                              ip6tc_get_target(i, handle),
+                                              num,
+                                              format,
+                                              *handle);

Moving down incrementing num solves the problem for me, but does it 
still do the right thing for num==rulenum? BTW, in the first iteration,
num==rulenum  is 1==0!

=====
commit 372dc8c92e1deae8d5942e889090347f415813d0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 13 11:14:45 2008 +0200

    iptables: fix printing of line numbers with --line-numbers arg
    
    Commit bb34082d ("iptables --list chain rulenum") broke the line
    numbering, starting with printing an offset of 2.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    2 +-
 iptables.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 8e135f1..54b8c4d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1092,7 +1092,6 @@ list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
 
 		num = 0;
 		while (i) {
-			num++;
 			if (!rulenum || num == rulenum)
 				print_firewall(i,
 					       ip6tc_get_target(i, handle),
@@ -1100,6 +1099,7 @@ list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
 					       format,
 					       *handle);
 			i = ip6tc_next_rule(i, handle);
+			++num;
 		}
 		found = 1;
 	}
diff --git a/iptables.c b/iptables.c
index cff8cf4..6b113ad 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1095,7 +1095,6 @@ list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
 
 		num = 0;
 		while (i) {
-			num++;
 			if (!rulenum || num == rulenum)
 				print_firewall(i,
 					       iptc_get_target(i, handle),
@@ -1103,6 +1102,7 @@ list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
 					       format,
 					       *handle);
 			i = iptc_next_rule(i, handle);
+			++num;
 		}
 		found = 1;
 	}
