From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 6/8] Fix ICMP id type
Date: Tue, 08 Nov 2005 02:44:53 +0100
Message-ID: <43700315.5000607@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080809010504080202050703"
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
--------------080809010504080202050703
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

ICMP_ID is u_int16_t not u_int8_t. Handle this properly.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------080809010504080202050703
Content-Type: text/plain;
 name="05-fix-type-icmp-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-fix-type-icmp-id.patch"

ICMP_ID is u_int16_t not u_int8_t. Handle this properly.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-11-06 19:59:55.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-11-06 19:59:56.000000000 +0100
@@ -305,7 +305,7 @@ static int icmp_nfattr_to_tuple(struct n
 	tuple->dst.u.icmp.code =
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
 	tuple->src.u.icmp.id =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 
 	return 0;
 }

--------------080809010504080202050703--
