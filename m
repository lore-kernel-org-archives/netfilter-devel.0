From: Patrick McHardy <kaber@trash.net>
Subject: [Fwd: [PATCH 2.4]: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insersion]
Date: Wed, 08 Oct 2008 14:32:34 +0200
Message-ID: <48ECA862.1010204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Willy Tarreau <w@1wt.eu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYJHMcg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:32:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Willy,

This patch from Yasuyuki fixes a problem in the hbh/dst matches which
is currently hidden by broken userspace, but will be exposed once
we've fixed userspace. Unfortunately neither of us has a working
2.4 environment, so all I can do is forward the patch. The upstream
commit ID is 8ca31ce52.

Please apply as you see fit. Thanks!

-------- Original Message --------
Subject: [PATCH 2.4]: ip6t_{hbh,dst}: Rejects not-strict mode on rule 
insersion
Date: Mon, 08 Sep 2008 15:32:34 +0900 (JST)
From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: kaber@trash.net
CC: netfilter-devel@vger.kernel.org
References: <20080908.151349.84890575.kozakai@isl.rdc.toshiba.co.jp>


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

--
To unsubscribe from this list: send the line "unsubscribe 
netfilter-devel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

