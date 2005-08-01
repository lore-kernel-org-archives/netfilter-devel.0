From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 4/7] Add ctnetlink_change_protoinfo
Date: Mon, 01 Aug 2005 19:05:12 +0200
Message-ID: <42EE5648.6020402@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050704010009080100090209"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------050704010009080100090209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Implement a function to change the private protocol information stored 
in a conntrack.

--------------050704010009080100090209
Content-Type: text/x-patch;
 name="04change-protoinfo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04change-protoinfo.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:06.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:13.000000000 +0200
@@ -948,6 +948,36 @@
 	return 0;
 }
 
+static inline int
+ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
+{
+	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
+	struct ip_conntrack_protocol *proto;
+	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	int err;
+
+	if (nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr) < 0)
+		goto nfattr_failure;
+
+	proto = ip_conntrack_proto_find_get(npt);
+	if (!proto)
+		return -EINVAL;
+
+	if (proto->from_nfattr) {
+		err = proto->from_nfattr(tb, ct);
+		if (err < 0) {
+			ip_conntrack_proto_put(proto);
+			return -EINVAL;
+		}
+	}
+	ip_conntrack_proto_put(proto);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
 static int
 ctnetlink_change_conntrack(struct ip_conntrack *ct, struct nfattr *cda[])
 {
@@ -973,6 +1003,12 @@
 			return err;
 	}
 
+	if (cda[CTA_PROTOINFO-1]) {
+		err = ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	DEBUGP("all done\n");
 	return 0;
 }
@@ -1002,6 +1038,12 @@
 	if (err < 0)
 		goto err;
 
+	if (cda[CTA_PROTOINFO-1]) {
+		err = ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	ct->helper = ip_conntrack_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);

--------------050704010009080100090209--
