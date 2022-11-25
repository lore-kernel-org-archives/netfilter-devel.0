Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39553C43217
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Nov 2022 16:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKYQMs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 11:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKYQMq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 11:12:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6367111452
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2022 08:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hwEYK8xl+2l9KsBsKOkVcZH7k/Rvwltq8weXgq03nnI=; b=CcwU4KsyFxfuEXtiABHWXtwfNo
        pSuLufRXkei++k+W+boN8KxyKk+Yar89WBQRG0QDX3x3dQVAyxgNTL+fPHZbjgx+Q/iawCYxWWsuP
        8tf5OdedzB4/1n8lCOmYD3K3E28ANMEhGXNGHy4rxDC47pAWDD0cs3QM/uE7cWKFhsTBEZYuEXi9J
        SOIhyVBnilhZffH3awMBhyNFYGRoWEbMtRw5rgn0or/W9eCRiUYXnFX3t4PUj16gxOS4ySNJQumhT
        eDIdLEPxOODPS563QJ6vfFiIaWY3L/PP2hBVNzLxsDNBFwxWIySmdUs3C3u1Yjna8HRItKll1ofSX
        prdVJgow==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oybJj-0006ZC-Qj; Fri, 25 Nov 2022 17:12:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 4/4] extensions: xlate: Format sets consistently
Date:   Fri, 25 Nov 2022 17:12:29 +0100
Message-Id: <20221125161229.18406-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125161229.18406-1-phil@nwl.cc>
References: <20221125161229.18406-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print a space after separating commas.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_multiport.c      |  4 ++--
 extensions/libxt_multiport.txlate |  2 +-
 extensions/libxt_time.c           | 12 ++++--------
 extensions/libxt_time.txlate      |  6 +++---
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 6b0c8190a1020..f3136d8a1ff56 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -497,7 +497,7 @@ static int __multiport_xlate(struct xt_xlate *xl,
 		xt_xlate_add(xl, "{ ");
 
 	for (i = 0; i < multiinfo->count; i++)
-		xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->ports[i]);
+		xt_xlate_add(xl, "%s%u", i ? ", " : "", multiinfo->ports[i]);
 
 	if (multiinfo->count > 1)
 		xt_xlate_add(xl, "}");
@@ -560,7 +560,7 @@ static int __multiport_xlate_v1(struct xt_xlate *xl,
 		xt_xlate_add(xl, "{ ");
 
 	for (i = 0; i < multiinfo->count; i++) {
-		xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->ports[i]);
+		xt_xlate_add(xl, "%s%u", i ? ", " : "", multiinfo->ports[i]);
 		if (multiinfo->pflags[i])
 			xt_xlate_add(xl, "-%u", multiinfo->ports[++i]);
 	}
diff --git a/extensions/libxt_multiport.txlate b/extensions/libxt_multiport.txlate
index bf0152650d79e..4f0c9c020f865 100644
--- a/extensions/libxt_multiport.txlate
+++ b/extensions/libxt_multiport.txlate
@@ -1,5 +1,5 @@
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81 } counter accept
+nft add rule ip filter INPUT ip protocol tcp tcp dport { 80, 81 } counter accept
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
 nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index d27d84caf546e..580861d3a940a 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -466,9 +466,10 @@ static int time_xlate(struct xt_xlate *xl,
 	const struct xt_time_info *info =
 		(const struct xt_time_info *)params->match->data;
 	unsigned int h, m, s,
-		     i, sep, mask, count;
+		     i, mask, count;
 	time_t tt_start, tt_stop;
 	struct tm *t_start, *t_stop;
+	const char *sep = "";
 
 	if (info->date_start != 0 ||
 	    info->date_stop != INT_MAX) {
@@ -498,7 +499,6 @@ static int time_xlate(struct xt_xlate *xl,
 	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS)
 		return 0;
 	if (info->weekdays_match != XT_TIME_ALL_WEEKDAYS) {
-		sep = 0;
 		mask = info->weekdays_match;
 		count = time_count_weekdays(mask);
 
@@ -507,12 +507,8 @@ static int time_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, "{");
 		for (i = 1; i <= 7; ++i)
 			if (mask & (1 << i)) {
-				if (sep)
-					xt_xlate_add(xl, ",%u", i%7);
-				else {
-					xt_xlate_add(xl, "%u", i%7);
-					++sep;
-				}
+				xt_xlate_add(xl, "%s%u", sep, i%7);
+				sep = ", ";
 			}
 		if (count > 1)
 			xt_xlate_add(xl, "}");
diff --git a/extensions/libxt_time.txlate b/extensions/libxt_time.txlate
index 6aea2aed5fa22..5577c6ca4cbd1 100644
--- a/extensions/libxt_time.txlate
+++ b/extensions/libxt_time.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --weekdays Sa,Su -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta day { 6,0 } counter reject
+nft add rule ip filter INPUT icmp type echo-request meta day { 6, 0 } counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestart 12:00 -j REJECT
 nft add rule ip filter INPUT icmp type echo-request meta hour "12:00:00"-"23:59:59" counter reject
@@ -20,7 +20,7 @@ iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart
 nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"23:59:59" counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 1,2,3,4,5 } counter reject
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 1, 2, 3, 4, 5 } counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 ! --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 6,0 } counter reject
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 6, 0 } counter reject
-- 
2.38.0

