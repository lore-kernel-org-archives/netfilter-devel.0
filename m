From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 2/6] add ip_nat_h245()
Date: Wed, 11 May 2005 00:51:54 +0200
Message-ID: <20050510225154.GB5720@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/WwmFnJnmDyWGHa4"
Cc: laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050510225019.GA5102@roonstrasse.net>
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


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-02-add_ip_nat_h245.patch
- add ip_nat_h245(), separate fro ip_nat_h225()


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-02-add_ip_nat_h245.patch"

Tue Apr 19 22:45:33 CEST 2005  max@duempel.org
  * ip_nat_h245_hook has its own implementation, ip_nat_h245()
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_nat_h323.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_nat_h323.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_nat_h323.c	2005-05-10 23:48:25.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_nat_h323.c	2005-05-10 23:48:26.000000000 +0200
@@ -126,6 +126,54 @@
 	return NF_ACCEPT;
 }
 
+static int ip_nat_h245(struct sk_buff **pskb,
+		       enum ip_conntrack_info ctinfo,
+		       unsigned int offset,
+		       struct ip_conntrack_expect *exp)
+{
+	u_int16_t port;
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
+	int dir = CTINFO2DIR(ctinfo);
+	struct ip_conntrack *ct = exp->master;
+	int ret;
+
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newdata.ip = ct->tuplehash[!dir].tuple.dst.ip;
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn = ip_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
+		exp->tuple.dst.u.tcp.port = htons(port);
+		if (ip_conntrack_expect_related(exp) == 0)
+			break;
+	}
+
+	if (port == 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
+	}
+
+	newdata.port = htons(port);
+
+	/* now mangle packet */
+	ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				       offset,
+				       sizeof(newdata),
+				       (const char*)&newdata, sizeof(newdata));
+	if (!ret)
+		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
 static int __init init(void)
 {
 	BUG_ON(ip_nat_h225_hook != NULL);
@@ -133,7 +181,7 @@
 
 	ip_nat_h225_hook = ip_nat_h225;
 	ip_nat_h225_signal_hook = ip_nat_h225_signal;
-	ip_nat_h245_hook = ip_nat_h225;
+	ip_nat_h245_hook = ip_nat_h245;
 
 	return 0;
 }


--/WwmFnJnmDyWGHa4--
