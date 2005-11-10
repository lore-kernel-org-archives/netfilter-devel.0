From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH  2/4] attribute sizes are size_t instead of int
Date: Thu, 10 Nov 2005 02:04:07 +0100
Message-ID: <43729C87.8030902@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070106030300010000040202"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------070106030300010000040202
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Make gcc-4.x happy. Use size_t instead of int. Thanks to Patrick Mchardy
for the hint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070106030300010000040202
Content-Type: text/plain;
 name="05-size_t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-size_t.patch"

Make gcc-4.x happy. Use size_t instead of int. Thanks to Patrick Mchardy for
the hint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-08 19:29:21.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-08 19:30:15.000000000 +0100
@@ -467,7 +467,7 @@ out:	
 }
 #endif
 
-static const int cta_min_ip[CTA_IP_MAX] = {
+static const size_t cta_min_ip[CTA_IP_MAX] = {
 	[CTA_IP_V4_SRC-1]	= sizeof(u_int32_t),
 	[CTA_IP_V4_DST-1]	= sizeof(u_int32_t),
 };
@@ -497,7 +497,7 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 	return 0;
 }
 
-static const int cta_min_proto[CTA_PROTO_MAX] = {
+static const size_t cta_min_proto[CTA_PROTO_MAX] = {
 	[CTA_PROTO_NUM-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_SRC_PORT-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_DST_PORT-1]	= sizeof(u_int16_t),
@@ -576,7 +576,7 @@ ctnetlink_parse_tuple(struct nfattr *cda
 }
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
-static const int cta_min_protonat[CTA_PROTONAT_MAX] = {
+static const size_t cta_min_protonat[CTA_PROTONAT_MAX] = {
 	[CTA_PROTONAT_PORT_MIN-1]	= sizeof(u_int16_t),
 	[CTA_PROTONAT_PORT_MAX-1]	= sizeof(u_int16_t),
 };

--------------070106030300010000040202--
