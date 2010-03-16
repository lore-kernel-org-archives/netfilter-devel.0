From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] netfilter: ebt_ip6: add principal maintainer in a MODULE_AUTHOR tag
Date: Tue, 16 Mar 2010 02:32:12 +0100
Message-ID: <1268703135-2622-9-git-send-email-jengelh@medozas.de>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49810 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965922Ab0CPBcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:32 -0400
In-Reply-To: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc: Kuo-Lang Tseng <kuo-lang.tseng@intel.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_ip6.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 4cb60f1..05d0d0c 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -139,4 +139,5 @@ static void __exit ebt_ip6_fini(void)
 module_init(ebt_ip6_init);
 module_exit(ebt_ip6_fini);
 MODULE_DESCRIPTION("Ebtables: IPv6 protocol packet match");
+MODULE_AUTHOR("Kuo-Lang Tseng <kuo-lang.tseng@intel.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.0.2

