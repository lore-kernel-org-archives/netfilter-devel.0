From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 1/8] Fix return value at nfattr_bad_size
Date: Tue, 08 Nov 2005 02:44:16 +0100
Message-ID: <437002F0.3020704@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070800070304050801060102"
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
--------------070800070304050801060102
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Return -EINVAL if the size isn't OK instead of -EPERM.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070800070304050801060102
Content-Type: text/plain;
 name="00-bad-size-return.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="00-bad-size-return.patch"

Return -EINVAL if the size isn't OK instead of -EPERM.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 04:58:00.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 04:58:31.000000000 +0100
@@ -593,7 +593,7 @@ static int ctnetlink_parse_nat_proto(str
 	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
-		return -1;
+		return -EINVAL;
 
 	npt = ip_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
 	if (!npt)

--------------070800070304050801060102--
