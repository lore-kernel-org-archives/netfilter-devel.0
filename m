From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/6] Make arp related key optionnal.
Date: Wed, 26 Mar 2008 23:49:06 +0100
Message-ID: <12065717513034-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36533 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754026AbYCZWtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:13 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arp related key have to be optionnal to be able to use the IP2STR module
for flow display.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 54e7d94... 9f36d60... M	filter/ulogd_filter_IP2STR.c
 filter/ulogd_filter_IP2STR.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 54e7d94..9f36d60 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -89,12 +89,12 @@ static struct ulogd_key ip2str_inp[] = {
 	},
 	[KEY_ARP_SPA] = {
 		.type = ULOGD_RET_IPADDR,
-		.flags = ULOGD_RETF_NONE,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name = "arp.saddr",
 	},
 	[KEY_ARP_TPA] = {
 		.type = ULOGD_RET_IPADDR,
-		.flags = ULOGD_RETF_NONE,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name = "arp.daddr",
 	},
 };
-- 
1.5.2.5

