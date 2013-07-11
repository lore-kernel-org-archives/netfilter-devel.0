From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_pkttype: IPv6 has no broadcast
Date: Thu, 11 Jul 2013 12:03:43 -0700
Message-ID: <20130711190343.GA25293@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52755 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3GKTDp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:03:45 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa11so8167107pad.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 12:03:45 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As stated in RFC 4291:

   There are no broadcast addresses in IPv6, their function being
   superseded by multicast addresses.

As such, the pkttype match should not allow IPv6 rules to be added
which attempt to match broadcast packets.  The addrtype match already
rejects such attempts.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipv6-no-broadcast

diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 5b645cb..4c0b0e1 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -42,13 +42,29 @@ pkttype_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return (type == info->pkttype) ^ info->invert;
 }
 
+static int pkttype_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct xt_pkttype_info *info = par->matchinfo;
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	if (par->family == NFPROTO_IPV6) {
+		if (info->pkttype == PACKET_BROADCAST) {
+			pr_err("IPv6 does not support BROADCAST packets\n");
+			return -EINVAL;
+		}
+	}
+#endif
+	return 0;
+}
+
 static struct xt_match pkttype_mt_reg __read_mostly = {
-	.name      = "pkttype",
-	.revision  = 0,
-	.family    = NFPROTO_UNSPEC,
-	.match     = pkttype_mt,
-	.matchsize = sizeof(struct xt_pkttype_info),
-	.me        = THIS_MODULE,
+	.name		= "pkttype",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.checkentry	= pkttype_mt_checkentry,
+	.match		= pkttype_mt,
+	.matchsize	= sizeof(struct xt_pkttype_info),
+	.me		= THIS_MODULE,
 };
 
 static int __init pkttype_mt_init(void)

--qMm9M+Fa2AknHoGS--
