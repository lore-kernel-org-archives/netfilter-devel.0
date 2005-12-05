From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] Remove bogus checking in ICMP
Date: Mon, 05 Dec 2005 12:20:55 +0100
Message-ID: <43942297.6050807@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040706000404020608030606"
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
--------------040706000404020608030606
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040706000404020608030606
Content-Type: text/plain;
 name="10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.patch"

Remove bogus checkings in the ICMP protocol handler at dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-11-12 14:32:38.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-12-04 03:35:50.000000000 +0100
@@ -279,10 +279,6 @@ static int icmp_tuple_to_nfattr(struct s
 	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
 		&t->dst.u.icmp.code);
 
-	if (t->dst.u.icmp.type >= sizeof(valid_new) 
-	    || !valid_new[t->dst.u.icmp.type])
-		return -EINVAL;
-
 	return 0;
 
 nfattr_failure:

--------------040706000404020608030606--
