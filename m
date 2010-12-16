From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH][RESEND] libxt_time: fix random --datestart skips
Date: Thu, 16 Dec 2010 16:28:48 +0100
Message-ID: <1292513328-19072-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-62.dex002.intermedia.net ([64.78.20.11]:38936 "EHLO
	dhost002-62.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449Ab0LPP1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:27:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Frank Lichtenheld points out that -m time --datestart ...
sometimes messes up --datestart:

$ iptables -A INPUT -m time --datestart 2010-11-24T16:50:00 -j ACCEPT
$ iptables-save | grep 11
-A INPUT -m time --datestart 2010-11-24T16:50:00 -j ACCEPT
$ iptables-save | iptables-restore
$ iptables-save | grep 11
-A INPUT -m time --datestart 2010-11-24T15:50:00 -j ACCEPT

--datestart moved by one hour.

As the --timestart option does not care about DST, always set
dst=0 when parsing --starttime input.

Reported-by: Frank Lichtenheld <flichtenheld@astaro.com>
Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/libxt_time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 5462d93..b2e6ffa 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -139,6 +139,7 @@ static time_t time_parse_date(const char *s, bool end)
 	tm.tm_hour = hour;
 	tm.tm_min  = minute;
 	tm.tm_sec  = second;
+	tm.tm_isdst = 0;
 	ret = mktime(&tm);
 	if (ret >= 0)
 		return ret;
-- 
1.7.2.2

