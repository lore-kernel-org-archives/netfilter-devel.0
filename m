From: Max Kellermann <max@duempel.org>
Subject: [PATCH iptables] print warnings to stderr
Date: Wed, 17 Oct 2007 17:06:52 +0200
Message-ID: <20071017150652.GA4748@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([81.209.165.42]:43593 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760118AbXJQPO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:14:27 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

iptables prints some of its error messages and warnings to stdout.
This patch applies to svn r7075 and will make iptables print
diagnostic messages to stderr instead.

Signed-off-by: Max Kellermann <max@duempel.org>

 ip6tables.c |   14 ++++++++------
 iptables.c  |    7 ++++---
 xtables.c   |    7 ++++---
 3 files changed, 16 insertions(+), 12 deletions(-)

Index: xtables.c
===================================================================
--- xtables.c	(revision 7075)
+++ xtables.c	(working copy)
@@ -246,9 +246,10 @@
 			if (vianame[i] == ':' ||
 			    vianame[i] == '!' ||
 			    vianame[i] == '*') {
-				printf("Warning: weird character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
+				fprintf(stderr,
+					"Warning: weird character in interface"
+					" `%s' (No aliases, :, ! or *).\n",
+					vianame);
 				break;
 			}
 		}
Index: iptables.c
===================================================================
--- iptables.c	(revision 7075)
+++ iptables.c	(working copy)
@@ -1818,7 +1818,7 @@
 				optarg[0] = '\0';
 				continue;
 			}
-			printf("Bad argument `%s'\n", optarg);
+			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
 		default:
@@ -1990,8 +1990,9 @@
 		}
 
 		if (target && iptc_is_chain(jumpto, *handle)) {
-			printf("Warning: using chain %s, not extension\n",
-			       jumpto);
+			fprintf(stderr,
+				"Warning: using chain %s, not extension\n",
+				jumpto);
 
 			if (target->t)
 				free(target->t);
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 7075)
+++ ip6tables.c	(working copy)
@@ -1592,9 +1592,10 @@
 			
 			if (is_exthdr(fw.ipv6.proto)
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO) == 0)
-				printf("Warning: never matched protocol: %s. "
-				       "use extension match instead.\n",
-				       protocol);
+				fprintf(stderr,
+					"Warning: never matched protocol: %s. "
+					"use extension match instead.\n",
+					protocol);
 			break;
 
 		case 's':
@@ -1753,7 +1754,7 @@
 				optarg[0] = '\0';
 				continue;
 			}
-			printf("Bad argument `%s'\n", optarg);
+			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
 		default:
@@ -1926,8 +1927,9 @@
 		}
 
 		if (target && ip6tc_is_chain(jumpto, *handle)) {
-			printf("Warning: using chain %s, not extension\n",
-			       jumpto);
+			fprintf(stderr,
+				"Warning: using chain %s, not extension\n",
+				jumpto);
 
 			if (target->t)
 				free(target->t);

