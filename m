From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.6]: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insersion
Date: Mon, 08 Sep 2008 15:13:49 +0900 (JST)
Message-ID: <200809080613.m886DnGY021233@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:53390 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYIHGqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2008 02:46:02 -0400
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id m886Jrs4007791
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Sep 2008 15:19:54 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id m886DobO013598
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Sep 2008 15:13:50 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id m886Dofl007102
	for netfilter-devel@vger.kernel.org; Mon, 8 Sep 2008 15:13:50 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id m886DoK2003936
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Sep 2008 15:13:50 +0900 (JST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Patrick,

Please apply the following patch. The option IP6T_OPTS_NSTRICT causes to
ignore rules for options in HBH/DST header.

I think this issue affects few users. Because fortunately (?) man page and
'ip6tables -m hbh --help' does not show --hbh-not-strict option, and
'ip6tables ... --hbh-not-strict' does not work due to incorrect has_arg
value in userland libip6t_hbh.c ;)

I will implement not-strict mode, so the patch leaves the definition of
IP6T_OPTS_NSTRICT. The strict mode is too strict (the specified options
have to be included in order in HBH/DST header) and would be useless
in most senarios.

Regards,


[NETFILTER]: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

The current code ignores rules for internal options in HBH/DST options
header in packet processing if 'Not strict' mode is specified (which is not
implemented). Clearly it is not expected by user.

Kernel should reject HBH/DST rule insertion with 'Not strict' mode
in the first place.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv6/netfilter/ip6t_hbh.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 62e39ac..26654b2 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -97,8 +97,6 @@ hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
 	hdrlen -= 2;
 	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
 		return ret;
-	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
-		pr_debug("Not strict - not implemented");
 	} else {
 		pr_debug("Strict ");
 		pr_debug("#%d ", optinfo->optsnr);
@@ -177,6 +175,12 @@ hbh_mt6_check(const char *tablename, const void *entry,
 		pr_debug("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
 		return false;
 	}
+
+	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
+		pr_debug("ip6t_opts: Not strict - not implemented");
+		return false;
+	}
+
 	return true;
 }
 
-- 
1.5.3.6

