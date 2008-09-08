From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4]: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insersion
Date: Mon, 08 Sep 2008 15:32:34 +0900 (JST)
Message-ID: <200809080632.m886WYtt016710@toshiba.co.jp>
References: <20080908.151349.84890575.kozakai@isl.rdc.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:63475 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYIHGci (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2008 02:32:38 -0400
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id m886WZWX029570
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Sep 2008 15:32:35 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id m886WZ4P001947
	for netfilter-devel@vger.kernel.org; Mon, 8 Sep 2008 15:32:35 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id m886WZiK008456
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Sep 2008 15:32:35 +0900 (JST)
In-Reply-To: <20080908.151349.84890575.kozakai@isl.rdc.toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is for 2.4 kernel (build test with 2.4.37-rc1, I have no environment
to run 2.4, sorry).



[NETFILTER]: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

The current code ignores rules for internal options in HBH/DST options
header in packet processing if 'Not strict' mode is specified (which is not
implemented). Clearly it is not expected by user.

Kernel should reject HBH/DST rule insertion with 'Not strict' mode
in the first place.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv6/netfilter/ip6t_dst.c |    6 ++++--
 net/ipv6/netfilter/ip6t_hbh.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index 65213e9..35ba724 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -172,8 +172,6 @@ match(const struct sk_buff *skb,
        hdrlen -= 2;
        if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
 	       return ret;
-	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
-		DEBUGP("Not strict - not implemented");
 	} else {
 		DEBUGP("Strict ");
 		DEBUGP("#%d ",optinfo->optsnr);
@@ -253,6 +251,10 @@ checkentry(const char *tablename,
                       optsinfo->invflags);
               return 0;
        }
+	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
+		DEBUGP("ip6t_opts: Not strict - not implemented");
+		return 0;
+	}
 
        return 1;
 }
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index b37e4ce..720cb8d 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -172,8 +172,6 @@ match(const struct sk_buff *skb,
        hdrlen -= 2;
        if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
 	       return ret;
-	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
-		DEBUGP("Not strict - not implemented");
 	} else {
 		DEBUGP("Strict ");
 		DEBUGP("#%d ",optinfo->optsnr);
@@ -253,6 +251,10 @@ checkentry(const char *tablename,
                       optsinfo->invflags);
               return 0;
        }
+	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
+		DEBUGP("ip6t_opts: Not strict - not implemented");
+		return 0;
+	}
 
        return 1;
 }
-- 
1.5.3.6

