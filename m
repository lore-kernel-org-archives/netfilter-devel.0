From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 5/8] Check for ICMP_ID in icmp_nfattr_to_tuple
Date: Tue, 08 Nov 2005 02:44:39 +0100
Message-ID: <43700307.6090001@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070405080405030008010809"
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
--------------070405080405030008010809
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch fixes an userspace triggered oops. If there is no ICMP_ID
info the reference to attr will be NULL.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070405080405030008010809
Content-Type: text/plain;
 name="04-icmp-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-icmp-id.patch"

This patch fixes an userspace triggered oops. If there is no ICMP_ID
info the reference to attr will be NULL.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-11-06 02:17:29.000000000 +0100
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-11-06 02:18:45.000000000 +0100
@@ -296,7 +296,8 @@
 				struct ip_conntrack_tuple *tuple)
 {
 	if (!tb[CTA_PROTO_ICMP_TYPE-1]
-	    || !tb[CTA_PROTO_ICMP_CODE-1])
+	    || !tb[CTA_PROTO_ICMP_CODE-1]
+	    || !tb[CTA_PROTO_ICMP_ID-1])
 		return -1;
 
 	tuple->dst.u.icmp.type = 

--------------070405080405030008010809--
