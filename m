From: Hans Schillstrom <hans@schillstrom.com>
Subject: [PATCH 1/1] libxt_HMARK: remove -set fix spi syntax and add hton{s,l}
Date: Tue, 17 Jul 2012 14:25:49 +0200
Message-ID: <1342527949-17589-1-git-send-email-hans@schillstrom.com>
Cc: Hans Schillstrom <hans@schillstrom.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:33916 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2GQM0F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:26:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Correct a number of errors introduced by Pablos rework

-set removed in all commands, iptables-save syntax must be valid.
xxx-set also removed in print commands.
Mix of spi and spi-mask fixed.
Added ntohX again for all ports and spi values.
Restore of spi / port  validation.

Remove --hmark-offset as mandatory.

Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
---
 extensions/libxt_HMARK.c |   45 ++++++++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_HMARK.c b/extensions/libxt_HMARK.c
index 736a671..9065226 100644
--- a/extensions/libxt_HMARK.c
+++ b/extensions/libxt_HMARK.c
@@ -26,16 +26,16 @@ static void HMARK_help(void)
 "  --hmark-tuple [src|dst|sport|dport|spi|proto|ct][,...]\n"
 "  --hmark-mod value		    nfmark modulus value\n"
 "  --hmark-offset value		    Last action add value to nfmark\n\n"
-"  --hmark-rnd			    Random seed for hashing\n"
+"  --hmark-rnd			    Random see for hashing\n"
 " Alternatively, fine tuning of what will be included in hash calculation\n"
 "  --hmark-src-prefix length	    Source address mask CIDR prefix\n"
 "  --hmark-dst-prefix length	    Dest address mask CIDR prefix\n"
 "  --hmark-sport-mask value	    Mask src port with value\n"
 "  --hmark-dport-mask value	    Mask dst port with value\n"
 "  --hmark-spi-mask value	    For esp and ah AND spi with value\n"
-"  --hmark-sport-set value	    OR src port with value\n"
-"  --hmark-dport-set value	    OR dst port with value\n"
-"  --hmark-spi-set value	    For esp and ah OR spi with value\n"
+"  --hmark-sport value		    OR src port with value\n"
+"  --hmark-dport value		    OR dst port with value\n"
+"  --hmark-spi value		    For esp and ah OR spi with value\n"
 "  --hmark-proto-mask value	    Mask Protocol with value\n");
 }
 
@@ -218,20 +218,29 @@ static void HMARK_parse(struct xt_option_call *cb, int plen)
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_DADDR_MASK);
 		break;
 	case O_HMARK_SPI:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPI_MASK);
+		info->port_set.v32 = htonl(cb->val.u32);
+		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPI);
 		break;
 	case O_HMARK_SPORT:
+		info->port_set.p16.src = htons(cb->val.u16);
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPORT);
 		break;
 	case O_HMARK_DPORT:
+		info->port_set.p16.dst = htons(cb->val.u16);
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_DPORT);
 		break;
 	case O_HMARK_SPORT_MASK:
+		info->port_mask.p16.src = htons(cb->val.u16);
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPORT_MASK);
 		break;
 	case O_HMARK_DPORT_MASK:
+		info->port_mask.p16.dst = htons(cb->val.u16);
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_DPORT_MASK);
 		break;
+	case O_HMARK_SPI_MASK:
+		info->port_mask.v32 = htonl(cb->val.u32);
+		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPI_MASK);
+		break;
 	case O_HMARK_PROTO_MASK:
 		info->flags |= XT_HMARK_FLAG(XT_HMARK_PROTO_MASK);
 		break;
@@ -267,8 +276,8 @@ static void HMARK_check(struct xt_fcheck_call *cb)
 	if (!(cb->xflags & (1 << O_HMARK_RND)))
 		xtables_error(PARAMETER_PROBLEM, "--hmark-rnd is mandatory");
 	if (cb->xflags & (1 << O_HMARK_SPI_MASK) &&
-	    (cb->xflags & (1 << O_HMARK_SPORT_MASK ||
-	     cb->xflags & (1 << O_HMARK_DPORT_MASK))))
+	    (cb->xflags & ((1 << O_HMARK_SPORT_MASK) |
+			   (1 << O_HMARK_DPORT_MASK))))
 		xtables_error(PARAMETER_PROBLEM, "you cannot use "
 				"--hmark-spi-mask and --hmark-?port-mask,"
 				"at the same time");
@@ -276,8 +285,6 @@ static void HMARK_check(struct xt_fcheck_call *cb)
 	       cb->xflags & (1 << O_HMARK_CT)))
 		xtables_error(PARAMETER_PROBLEM, "you have to specify "
 				"--hmark-tuple at least");
-	if (!(cb->xflags & (1 << O_HMARK_OFFSET)))
-		xtables_error(PARAMETER_PROBLEM, "--hmark-offset is mandatory");
 }
 
 static void HMARK_print(const struct xt_hmark_info *info)
@@ -286,14 +293,14 @@ static void HMARK_print(const struct xt_hmark_info *info)
 		printf("sport-mask 0x%x ", htons(info->port_mask.p16.src));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
 		printf("dport-mask 0x%x ", htons(info->port_mask.p16.dst));
-	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
+	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
 		printf("spi-mask 0x%x ", htonl(info->port_mask.v32));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
-		printf("sport-set 0x%x ", htons(info->port_set.p16.src));
+		printf("sport 0x%x ", htons(info->port_set.p16.src));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
-		printf("dport-set 0x%x ", htons(info->port_set.p16.dst));
-	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
-		printf("spi-set 0x%x ", htonl(info->port_set.v32));
+		printf("dport 0x%x ", htons(info->port_set.p16.dst));
+	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
+		printf("spi 0x%x ", htonl(info->port_set.v32));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_PROTO_MASK))
 		printf("proto-mask 0x%x ", info->proto_mask);
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_RND))
@@ -351,17 +358,17 @@ static void HMARK_save(const struct xt_hmark_info *info)
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
 		printf(" --hmark-dport-mask 0x%04x",
 		       htons(info->port_mask.p16.dst));
-	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
+	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
 		printf(" --hmark-spi-mask 0x%08x",
 		       htonl(info->port_mask.v32));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
-		printf(" --hmark-sport-set 0x%04x",
+		printf(" --hmark-sport 0x%04x",
 		       htons(info->port_set.p16.src));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
-		printf(" --hmark-dport-set 0x%04x",
+		printf(" --hmark-dport 0x%04x",
 		       htons(info->port_set.p16.dst));
-	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
-		printf(" --hmark-spi-set 0x%08x", htonl(info->port_set.v32));
+	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
+		printf(" --hmark-spi 0x%08x", htonl(info->port_set.v32));
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_PROTO_MASK))
 		printf(" --hmark-proto-mask 0x%02x", info->proto_mask);
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_RND))
-- 
1.7.7.6

