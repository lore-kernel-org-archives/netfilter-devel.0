From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/8] libipt_ECN: set proper option flags
Date: Sat, 19 Feb 2011 20:04:18 +0100
Message-ID: <1298142259-11213-9-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42370 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab1BSTEm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:42 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When specifying --ecn-tcp-remove, *flags will be set to 1, which leads
to the ECN bits being removed from the IPv4 header, but in fact not
the TCP header.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_ECN.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index e1f29b6..2aa1a00 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -53,7 +53,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		einfo->operation = IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR;
 		einfo->proto.tcp.ece = 0;
 		einfo->proto.tcp.cwr = 0;
-		*flags = 1;
+		*flags |= IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR;
 		break;
 	case 'G':
 		if (*flags & IPT_ECN_OP_SET_CWR)
-- 
1.7.1

