From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion
Date: Wed, 24 Sep 2008 18:07:23 +0200
Message-ID: <48DA65BB.6080605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030804070901020400070800"
To: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXQHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:07:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030804070901020400070800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

the following netfilter patch is intended for 2.6.27. According to
Yasuyuki, it fixes a potential security problem that is currently
not an issue because userspace is sufficiently broken so the feature
can't be used, but once we fix userspace it might be used on old
kernels and the problem will be an issue. So I agree with Yasuyuki
that this should go in 2.6.27 (and -stable afterwards).

Please apply, thanks.


--------------030804070901020400070800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit dbc35b57f311d95d3480f006805e2284f083dbcf
Author: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date:   Wed Sep 24 17:29:30 2008 +0200

    netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion
    
    The current code ignores rules for internal options in HBH/DST options
    header in packet processing if 'Not strict' mode is specified (which is not
    implemented). Clearly it is not expected by user.
    
    Kernel should reject HBH/DST rule insertion with 'Not strict' mode
    in the first place.
    
    Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

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
 

--------------030804070901020400070800--
