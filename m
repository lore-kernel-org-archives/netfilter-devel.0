From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 1/2 nf] netfilter: bridge: do not initialize statics to 0 or NULL
Date: Thu, 30 Jul 2015 06:06:12 +0200
Message-ID: <1438229172-25925-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.135]:11638 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbbG2XRr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jul 2015 19:17:47 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id B9054605BA
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2015 01:17:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix checkpatch.pl "ERROR: do not initialise statics to 0 or NULL" for
all statics explicitly initialized to 0.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
 net/bridge/br_netfilter_hooks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index c8b9bcf..624e1f2 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -49,9 +49,9 @@ static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
 static int brnf_call_ip6tables __read_mostly = 1;
 static int brnf_call_arptables __read_mostly = 1;
-static int brnf_filter_vlan_tagged __read_mostly = 0;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
-static int brnf_pass_vlan_indev __read_mostly = 0;
+static int brnf_filter_vlan_tagged __read_mostly;
+static int brnf_filter_pppoe_tagged __read_mostly;
+static int brnf_pass_vlan_indev __read_mostly;
 #else
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
-- 
1.7.10.4

