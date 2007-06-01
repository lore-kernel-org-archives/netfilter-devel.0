From: Amin Azez <azez@ufomechanic.net>
Subject: [PATCH] add direction match to conntrack match
Date: Fri, 01 Jun 2007 17:25:42 +0100
Message-ID: <46604886.4080400@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070603030405030505010609"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070603030405030505010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This adds the virtual states ORIGINAL and REPLY to the conntrack match,
making it possible to tell if the packet being compared is part of the
original flow or the reply flow.

e.g.

iptables -t mangle -A PREROUTING -m conntrack --ctstate REPLY

The patch is against kernel 2.6.17 and iptables 1.3.6, but it is simple
enough.

Signed-off by: Sam Liddicott <azez@ufomechanic.net>




--------------070603030405030505010609
Content-Type: text/x-patch;
 name="ctstate-dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctstate-dir.patch"

--- ./include/linux/netfilter_ipv4/ipt_conntrack.h.old	2007-06-01 16:17:36.000000000 +0100
+++ ./include/linux/netfilter_ipv4/ipt_conntrack.h	2007-06-01 16:18:08.000000000 +0100
@@ -28,6 +28,8 @@
 #define IPT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
 #define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
 #define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
+#define IPT_CONNTRACK_STATE_ORIGINAL (1 << (IP_CT_NUMBER + 4))
+#define IPT_CONNTRACK_STATE_REPLY (1 << (IP_CT_NUMBER + 5))
 
 /* flags, invflags: */
 #define IPT_CONNTRACK_STATE	0x01
--- ./extensions/libipt_conntrack.man.old	2007-06-01 16:12:43.000000000 +0100
+++ ./extensions/libipt_conntrack.man	2007-06-01 16:14:00.000000000 +0100
@@ -25,6 +25,12 @@
 .B DNAT
 A virtual state, matching if the original destination differs from the
 reply source.
+.B ORIGINAL
+A virtual state, matching if the packet being compared is part of the
+original flow that created the conntrack.
+.B REPLY
+A virtual state, matching if the packet being compared is part of the
+reply flow.
 .TP
 .BI "--ctproto " "proto"
 Protocol to match (by number or name)
--- ./extensions/libipt_conntrack.c.old	2007-06-01 16:14:12.000000000 +0100
+++ ./extensions/libipt_conntrack.c	2007-06-01 16:16:39.000000000 +0100
@@ -24,7 +24,7 @@
 {
 	printf(
 "conntrack match v%s options:\n"
-" [!] --ctstate [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT][,...]\n"
+" [!] --ctstate [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT|ORIGINAL|REPLY][,...]\n"
 "				State(s) to match\n"
 " [!] --ctproto	proto		Protocol to match; by number or name, eg. `tcp'\n"
 "     --ctorigsrc  [!] address[/mask]\n"
@@ -73,6 +73,10 @@
 		sinfo->statemask |= IPT_CONNTRACK_STATE_SNAT;
 	else if (strncasecmp(state, "DNAT", strlen) == 0)
 		sinfo->statemask |= IPT_CONNTRACK_STATE_DNAT;
+	else if (strncasecmp(state, "ORIGINAL", strlen) == 0)
+		sinfo->statemask |= IPT_CONNTRACK_STATE_ORIGINAL;
+	else if (strncasecmp(state, "REPLY", strlen) == 0)
+		sinfo->statemask |= IPT_CONNTRACK_STATE_REPLY;
 	else
 		return 0;
 	return 1;
@@ -376,6 +380,14 @@
 		printf("%sDNAT", sep);
 		sep = ",";
 	}
+	if (statemask & IPT_CONNTRACK_STATE_ORIGINAL) {
+		printf("%sORIGINAL", sep);
+		sep = ",";
+	}
+	if (statemask & IPT_CONNTRACK_STATE_REPLY) {
+		printf("%sREPLY", sep);
+		sep = ",";
+	}
 	printf(" ");
 }
 

--------------070603030405030505010609
Content-Type: text/x-patch;
 name="ctstate-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctstate-kernel.patch"

Index: linux-2.6.17.1/include/linux/netfilter/xt_conntrack.h
===================================================================
--- linux-2.6.17.1.orig/include/linux/netfilter/xt_conntrack.h
+++ linux-2.6.17.1/include/linux/netfilter/xt_conntrack.h
@@ -14,6 +14,9 @@
 #define XT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
 #define XT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
 #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
+/* match on direction of packet */
+#define XT_CONNTRACK_STATE_ORIGINAL (1 << (IP_CT_NUMBER + 4))
+#define XT_CONNTRACK_STATE_REPLY (1 << (IP_CT_NUMBER + 5))
 
 /* flags, invflags: */
 #define XT_CONNTRACK_STATE	0x01
Index: linux-2.6.17.1/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.17.1.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6.17.1/net/netfilter/xt_conntrack.c
@@ -63,6 +63,11 @@ match(const struct sk_buff *skb,
 			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=
 			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip)
 				statebit |= XT_CONNTRACK_STATE_DNAT;
+
+			if(CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+				statebit |= XT_CONNTRACK_STATE_ORIGINAL;
+			else
+				statebit |= XT_CONNTRACK_STATE_REPLY;
 		}
 
 		if (FWINV((statebit & sinfo->statemask) == 0, XT_CONNTRACK_STATE))
@@ -150,6 +155,11 @@ match(const struct sk_buff *skb,
 			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip !=
 			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip)
 				statebit |= XT_CONNTRACK_STATE_DNAT;
+
+			if(CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+				statebit |= XT_CONNTRACK_STATE_ORIGINAL;
+			else
+				statebit |= XT_CONNTRACK_STATE_REPLY;
 		}
 
 		if (FWINV((statebit & sinfo->statemask) == 0, XT_CONNTRACK_STATE))

--------------070603030405030505010609--
