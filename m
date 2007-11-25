From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/4] iptables: fix check_inverse() call
Date: Sun, 25 Nov 2007 02:05:38 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35699 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXKYBFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:05:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Fix a typo in call to check_inverse().

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_conntrack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: iptables/extensions/libipt_conntrack.c
===================================================================
--- iptables.orig/extensions/libipt_conntrack.c
+++ iptables/extensions/libipt_conntrack.c
@@ -204,7 +204,7 @@ static int conntrack_parse(int c, char *
 		break;
 
 	case '3':
-		check_inverse(optarg, &invert, &optind, 9);
+		check_inverse(optarg, &invert, &optind, 0);
 
 		if (invert)
 			sinfo->invflags |= IPT_CONNTRACK_ORIGSRC;

