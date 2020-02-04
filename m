Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F53C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 10:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB738217BA
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 10:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="F+MwY9Cb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBDKYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 05:24:43 -0500
Received: from mx1.riseup.net ([198.252.153.129]:32882 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgBDKYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 05:24:43 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 48BgmT4lw9zDr9s
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 02:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1580811881; bh=XXX8e1u0L6CK88ic/z37gVeRSvBTq7fjc7sdrhbjsL0=;
        h=From:To:Subject:Date:From;
        b=F+MwY9CbW+b1SERq+KzgppJZsCmxu5+gBlPo8PaHeGtsZ/+zxkMu6DGEktt8NKaHw
         p8zrC923e1v1XaXwGpjYH+IACoELSz6lviZ2Br3Q0DpAXkQvoyr2z80LawAHm4oqeq
         kn/lcMOODf9PVUyxckrMsrJ8xPSvNYpDefwbWnyA=
X-Riseup-User-ID: 19B6F26EE7D0B4DEDE929698D8A1F3DA8436E81D1A383851EE4ACEB8CAF00B89
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 48BgmT062dz8vMw
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 02:24:40 -0800 (PST)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] extensions: time: add translation and tests
Date:   Tue,  4 Feb 2020 11:24:16 +0100
Message-Id: <20200204102416.981-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Translation capabilities for xtables time match. Different time values
(hour and datetime) are translated into ranges.

These time match options can be translated now

	--timestart value
	--timestop value
	[!] --weekdays listofdays
	--datestart date
	--datestop date

The option --monthdays can't be translated into nft as of now.

Examples can be found inside libxt_time.txlate

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 extensions/libxt_time.c      | 72 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_time.txlate | 26 +++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 extensions/libxt_time.txlate

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index d001f5b7..d27d84ca 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -258,6 +258,16 @@ static unsigned int time_parse_weekdays(const char *arg)
 	return ret;
 }
 
+static unsigned int time_count_weekdays(unsigned int weekdays_mask)
+{
+	unsigned int ret;
+
+	for (ret = 0; weekdays_mask; weekdays_mask >>= 1)
+		ret += weekdays_mask & 1;
+
+	return ret;
+}
+
 static void time_parse(struct xt_option_call *cb)
 {
 	struct xt_time_info *info = cb->data;
@@ -450,6 +460,67 @@ static void time_check(struct xt_fcheck_call *cb)
 			"time: --contiguous only makes sense when stoptime is smaller than starttime");
 }
 
+static int time_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
+{
+	const struct xt_time_info *info =
+		(const struct xt_time_info *)params->match->data;
+	unsigned int h, m, s,
+		     i, sep, mask, count;
+	time_t tt_start, tt_stop;
+	struct tm *t_start, *t_stop;
+
+	if (info->date_start != 0 ||
+	    info->date_stop != INT_MAX) {
+		tt_start = (time_t) info->date_start;
+		tt_stop = (time_t) info->date_stop;
+
+		xt_xlate_add(xl, "meta time ");
+		t_start = gmtime(&tt_start);
+		xt_xlate_add(xl, "\"%04u-%02u-%02u %02u:%02u:%02u\"",
+			     t_start->tm_year + 1900, t_start->tm_mon + 1,
+			     t_start->tm_mday, t_start->tm_hour,
+			     t_start->tm_min, t_start->tm_sec);
+		t_stop = gmtime(&tt_stop);
+		xt_xlate_add(xl, "-\"%04u-%02u-%02u %02u:%02u:%02u\"",
+			     t_stop->tm_year + 1900, t_stop->tm_mon + 1,
+			     t_stop->tm_mday, t_stop->tm_hour,
+			     t_stop->tm_min, t_stop->tm_sec);
+	}
+	if (info->daytime_start != XT_TIME_MIN_DAYTIME ||
+	    info->daytime_stop != XT_TIME_MAX_DAYTIME) {
+		divide_time(info->daytime_start, &h, &m, &s);
+		xt_xlate_add(xl, " meta hour \"%02u:%02u:%02u\"", h, m, s);
+		divide_time(info->daytime_stop, &h, &m, &s);
+		xt_xlate_add(xl, "-\"%02u:%02u:%02u\"", h, m, s);
+	}
+	/* nft_time does not support --monthdays */
+	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS)
+		return 0;
+	if (info->weekdays_match != XT_TIME_ALL_WEEKDAYS) {
+		sep = 0;
+		mask = info->weekdays_match;
+		count = time_count_weekdays(mask);
+
+		xt_xlate_add(xl, " meta day ");
+		if (count > 1)
+			xt_xlate_add(xl, "{");
+		for (i = 1; i <= 7; ++i)
+			if (mask & (1 << i)) {
+				if (sep)
+					xt_xlate_add(xl, ",%u", i%7);
+				else {
+					xt_xlate_add(xl, "%u", i%7);
+					++sep;
+				}
+			}
+		if (count > 1)
+			xt_xlate_add(xl, "}");
+	}
+
+	return 1;
+}
+
 static struct xtables_match time_match = {
 	.name          = "time",
 	.family        = NFPROTO_UNSPEC,
@@ -463,6 +534,7 @@ static struct xtables_match time_match = {
 	.x6_parse      = time_parse,
 	.x6_fcheck     = time_check,
 	.x6_options    = time_opts,
+	.xlate	       = time_xlate,
 };
 
 void _init(void)
diff --git a/extensions/libxt_time.txlate b/extensions/libxt_time.txlate
new file mode 100644
index 00000000..ff4a7b88
--- /dev/null
+++ b/extensions/libxt_time.txlate
@@ -0,0 +1,26 @@
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --weekdays Sa,Su -j REJECT
+nft add rule ip filter INPUT icmp type echo-request  meta day {6,0} counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestart 12:00 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request  meta hour "12:00:00"-"23:59:59" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestop 12:00 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request  meta hour "00:00:00"-"12:00:00" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2021 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "2021-01-01 00:00:00"-"2038-01-19 03:14:07" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestop 2021 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-01 00:00:00" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestop 2021-01-29T00:00:00 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "1970-01-01 00:00:00"-"2021-01-29 00:00:00" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"23:59:59" counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {1,2,3,4,5} counter reject
+
+iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 ! --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {6,0} counter reject
-- 
2.23.0

