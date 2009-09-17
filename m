From: Patrick McHardy <kaber@trash.net>
Subject: netfilter -stable 04/04: ebt_ulog: fix checkentry return value
Date: Thu, 17 Sep 2009 13:58:30 +0200 (MEST)
Message-ID: <20090917115828.12728.63548.sendpatchset@x2.localnet>
References: <20090917115823.12728.87778.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: stable@kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090917115823.12728.87778.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 0ca92f7712ddfd00f47417ff66edbb27c4740fec
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Sep 17 13:31:35 2009 +0200

    netfilter: ebt_ulog: fix checkentry return value
    
    Upstream commit 8a56df0a:
    
    Commit 19eda87 (netfilter: change return types of check functions for
    Ebtables extensions) broke the ebtables ulog module by missing a return
    value conversion.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 133eeae..ce50688 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -266,7 +266,7 @@ static bool ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
 		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
 
-	return 0;
+	return true;
 }
 
 static struct xt_target ebt_ulog_tg_reg __read_mostly = {
