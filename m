From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8] Add sanity checkings for ICMP
Date: Mon, 05 Dec 2005 12:20:59 +0100
Message-ID: <4394229B.5030506@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020302020409040204020504"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------020302020409040204020504
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020302020409040204020504
Content-Type: text/plain;
 name="11.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="11.patch"

Add proper checkings to avoid possible malformed ICMP conntracks. And return 
to userspace -EINVAL in case of error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-12-04 03:35:50.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-12-04 03:37:24.000000000 +0100
@@ -288,10 +288,14 @@ nfattr_failure:
 static int icmp_nfattr_to_tuple(struct nfattr *tb[],
 				struct ip_conntrack_tuple *tuple)
 {
+	if (tuple->dst.u.icmp.type >= sizeof(valid_new)
+	    || !valid_new[tuple->dst.u.icmp.type])
+		return -EINVAL;
+
 	if (!tb[CTA_PROTO_ICMP_TYPE-1]
 	    || !tb[CTA_PROTO_ICMP_CODE-1]
 	    || !tb[CTA_PROTO_ICMP_ID-1])
-		return -1;
+		return -EINVAL;
 
 	tuple->dst.u.icmp.type = 
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);

--------------020302020409040204020504--
