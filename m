From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [xt_RAWNAT 1/3] Make room in the hook priority list
Date: Sun, 13 Jan 2008 17:09:38 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801131709030.21665@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48339 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYAMQJj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:09:39 -0500
In-Reply-To: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

origin git://computergmbh.de/linux patchomatic
commit 03e306db0e3a74d9bca91191afbd955be6b7c632
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 9 18:37:37 2008 +0100

    [NETFILTER]: Make room in the hook priority list
    
    A few hook priorites related to conntrack are currently assigned
    values at the end of the priority list, making it impossible to add
    priorities in-between or after these. Renumber NF_IP_PRI_* so that
    this becomes possible.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 9a10092..7378d17 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -62,9 +62,9 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_FILTER = 0,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
-	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
-	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
-	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
+	NF_IP_PRI_CONNTRACK_HELPER = 500,
+	NF_IP_PRI_NAT_SEQ_ADJUST = 520,
+	NF_IP_PRI_CONNTRACK_CONFIRM = 540,
 	NF_IP_PRI_LAST = INT_MAX,
 };
 
