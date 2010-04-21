From: Vincent Bernat <bernat@luffy.cx>
Subject: [PATCH] iprange: fix xt_iprange v0 parsing
Date: Wed, 21 Apr 2010 14:09:18 +0200
Message-ID: <1271851758-12108-1-git-send-email-bernat@luffy.cx>
Cc: Vincent Bernat <bernat@luffy.cx>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ftmxout01ba.infra.b2.fti.net ([193.252.121.124]:39358 "EHLO
	ftmxout01ba.infra.b2.fti.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab0DUMTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:19:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iprange_parse() was incomplete and did not include parsed ranges into
ipt_iprange_info structure resulting in always adding range
0.0.0.0-0.0.0.0 in the kernel.

Moreover, when using --dst-range, error messages may display
--src-range instead. Fix this too.

Signed-off-by: Vincent Bernat <bernat@luffy.cx>
---
 extensions/libxt_iprange.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index b28a635..55a2f84 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -108,7 +108,8 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
 		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
-
+		info->src.min_ip = range[0].ip;
+		info->src.max_ip = range[1].ip;
 		break;
 
 	case '2':
@@ -122,8 +123,9 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
 
-		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
-
+		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--dst-range");
+		info->dst.min_ip = range[0].ip;
+		info->dst.max_ip = range[1].ip;
 		break;
 
 	default:
-- 
1.7.0.4

