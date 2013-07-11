From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_addrtype: fix trivial typo
Date: Thu, 11 Jul 2013 12:06:58 -0700
Message-ID: <20130711190658.GA25378@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39260 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3GKTG7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:06:59 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so7787841pdj.3
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 12:06:59 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix typo in error message.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-addrtype-typo

diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 68ff29f..fab6eea 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -202,7 +202,7 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 			return -EINVAL;
 		}
 		if ((info->source | info->dest) >= XT_ADDRTYPE_PROHIBIT) {
-			pr_err("ipv6 PROHIBT (THROW, NAT ..) matching not supported\n");
+			pr_err("ipv6 PROHIBIT (THROW, NAT ..) matching not supported\n");
 			return -EINVAL;
 		}
 		if ((info->source | info->dest) & XT_ADDRTYPE_BROADCAST) {

--EeQfGwPcQSOJBaQU--
