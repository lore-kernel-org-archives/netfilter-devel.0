From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/12] libxt_conntrack: resolve erroneous rev-2 port range message
Date: Fri, 13 May 2011 02:47:35 +0200
Message-ID: <1305247657-29158-12-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54349 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043Ab1EMAti (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:38 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  --ctorigdstport 13
ip6tables-restore v1.4.10: conntrack rev 2 does not support port ranges

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 0262b01..ed0bd93 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -534,6 +534,10 @@ static void conntrack1_mt_parse(struct xt_option_call *cb)
 
 	memset(&up, 0, sizeof(up));
 	cinfo_transform(&up, info);
+	up.origsrc_port_high = up.origsrc_port;
+	up.origdst_port_high = up.origdst_port;
+	up.replsrc_port_high = up.replsrc_port;
+	up.repldst_port_high = up.repldst_port;
 	cb->data = &up;
 	conntrack_mt_parse(cb, 3);
 	if (up.origsrc_port != up.origsrc_port_high ||
@@ -556,6 +560,10 @@ static void conntrack2_mt_parse(struct xt_option_call *cb)
 
 	memset(&up, 0, sizeof(up));
 	memcpy(&up, info, sizeof(*info));
+	up.origsrc_port_high = up.origsrc_port;
+	up.origdst_port_high = up.origdst_port;
+	up.replsrc_port_high = up.replsrc_port;
+	up.repldst_port_high = up.repldst_port;
 	cb->data = &up;
 	conntrack_mt_parse(cb, 3);
 	if (up.origsrc_port != up.origsrc_port_high ||
-- 
1.7.1

