Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17EEC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Nov 2022 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKYQMq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 11:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiKYQMn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 11:12:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCF10FCD
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2022 08:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EBPb/QQ01VPtimA179jFso+bc4iqGLMMXAxVi6owxt4=; b=VoqI558YNoABrCl55/z+oH6zq7
        23MF72JOKHSc3uE7IoUU3JikwjyvFND8khGEI+wN0Y7NupwvFHk7rDTn387a5cfjRZ+5aL6Uyk9c9
        eXftnZEy+kRS3975TL29S1T6w4snr0gG+yc21cNhA7ev9SE50lXxu5zKeYOKA5oRemfMXOWlSJoRa
        juBvNU4HljvsJ6M5XqE4I1ajqpbXZv59WN0tzCZkhgEvsbrnITYU506GE3EEO9mZL56FSveYksvmH
        GZnsGrwrdjIaMXSDfzibnWg9IepczO6NC3A4gfQuLFrygJJU4GkjVmS4VFiHz4zuCMjSTyW55hWTo
        X3K/go4w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oybJe-0006Z0-Gj; Fri, 25 Nov 2022 17:12:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 1/4] libxtables: xt_xlate_add() to take care of spacing
Date:   Fri, 25 Nov 2022 17:12:26 +0100
Message-Id: <20221125161229.18406-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Try to eliminate most of the whitespace issues by separating strings
from separate xt_xlate_add() calls by whitespace if needed.

Cover the common case of consecutive range, list or MAC/IP address
printing by inserting whitespace only if the string to be appended
starts with an alphanumeric character or a brace. The latter helps to
make spacing in anonymous sets consistent.

Provide *_nospc() variants which disable the auto-spacing for the
mandatory exception to the rule.

Make things round by dropping any trailing whitespace before returning
the buffer via xt_xlate_get().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_dccp.txlate      |  2 +-
 extensions/libxt_hashlimit.c      |  2 +-
 extensions/libxt_hashlimit.txlate |  4 +--
 extensions/libxt_multiport.txlate |  2 +-
 extensions/libxt_tcp.c            |  7 ++--
 extensions/libxt_time.txlate      |  6 ++--
 include/xtables.h                 |  3 ++
 libxtables/xtables.c              | 58 +++++++++++++++++++++++++++----
 8 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/extensions/libxt_dccp.txlate b/extensions/libxt_dccp.txlate
index ea853f6acf627..be950bcb6dbda 100644
--- a/extensions/libxt_dccp.txlate
+++ b/extensions/libxt_dccp.txlate
@@ -14,7 +14,7 @@ iptables-translate -A INPUT -p dccp -m dccp --dccp-types INVALID
 nft add rule ip filter INPUT dccp type 10-15 counter
 
 iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK,INVALID
-nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack, 10-15} counter
+nft add rule ip filter INPUT dccp dport 100 dccp type { request, response, data, ack, dataack, closereq, close, sync, syncack, 10-15 } counter
 
 iptables-translate -A INPUT -p dccp -m dccp --sport 200 --dport 100
 nft add rule ip filter INPUT dccp sport 200 dccp dport 100 counter
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 93ee1c32e54c3..24e784ab1ab10 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -1270,7 +1270,7 @@ static void hashlimit_print_subnet_xlate(struct xt_xlate *xl,
 			}
 		}
 
-		xt_xlate_add(xl, fmt, acm);
+		xt_xlate_add_nospc(xl, fmt, acm);
 		if (nblocks > 0)
 			xt_xlate_add(xl, "%c", sep);
 	}
diff --git a/extensions/libxt_hashlimit.txlate b/extensions/libxt_hashlimit.txlate
index 6c8d07f113d26..251a30d371db4 100644
--- a/extensions/libxt_hashlimit.txlate
+++ b/extensions/libxt_hashlimit.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip --hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes} ct state new  counter drop
+nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes } ct state new  counter drop
 
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} ct state new  counter drop
+nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets } ct state new  counter drop
diff --git a/extensions/libxt_multiport.txlate b/extensions/libxt_multiport.txlate
index bced1b84c447e..bf0152650d79e 100644
--- a/extensions/libxt_multiport.txlate
+++ b/extensions/libxt_multiport.txlate
@@ -1,5 +1,5 @@
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
-nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept
+nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81 } counter accept
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
 nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 043382d47b8ba..2ef842990a4e8 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -380,10 +380,9 @@ static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 
 		for (i = 0; (flags & tcp_flag_names_xlate[i].flag) == 0; i++);
 
-		if (have_flag)
-			xt_xlate_add(xl, ",");
-
-		xt_xlate_add(xl, "%s", tcp_flag_names_xlate[i].name);
+		xt_xlate_add(xl, "%s%s",
+			     have_flag ? "," : "",
+			     tcp_flag_names_xlate[i].name);
 		have_flag = 1;
 
 		flags &= ~tcp_flag_names_xlate[i].flag;
diff --git a/extensions/libxt_time.txlate b/extensions/libxt_time.txlate
index ff4a7b88a8742..2083ab94f4c24 100644
--- a/extensions/libxt_time.txlate
+++ b/extensions/libxt_time.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --weekdays Sa,Su -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta day {6,0} counter reject
+nft add rule ip filter INPUT icmp type echo-request  meta day { 6,0 } counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestart 12:00 -j REJECT
 nft add rule ip filter INPUT icmp type echo-request  meta hour "12:00:00"-"23:59:59" counter reject
@@ -20,7 +20,7 @@ iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart
 nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"23:59:59" counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {1,2,3,4,5} counter reject
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 1,2,3,4,5 } counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2020-01-29T00:00:00 --timestart 12:00 --timestop 19:00 ! --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
-nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day {6,0} counter reject
+nft add rule ip filter INPUT icmp type echo-request meta time "2020-01-29 00:00:00"-"2038-01-19 03:14:07" meta hour "12:00:00"-"19:00:00" meta day { 6,0 } counter reject
diff --git a/include/xtables.h b/include/xtables.h
index 9eba4f619d351..dad1949e55370 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -621,8 +621,11 @@ extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 struct xt_xlate *xt_xlate_alloc(int size);
 void xt_xlate_free(struct xt_xlate *xl);
 void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
+void xt_xlate_add_nospc(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
 #define xt_xlate_rule_add xt_xlate_add
+#define xt_xlate_rule_add_nospc xt_xlate_add_nospc
 void xt_xlate_set_add(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
+void xt_xlate_set_add_nospc(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
 void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment);
 const char *xt_xlate_get_comment(struct xt_xlate *xl);
 void xl_xlate_set_family(struct xt_xlate *xl, uint8_t family);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 479dbae078156..e3e444acbbaa2 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2490,16 +2490,39 @@ void xt_xlate_free(struct xt_xlate *xl)
 	free(xl);
 }
 
+static bool isbrace(char c)
+{
+	switch (c) {
+	case '(':
+	case ')':
+	case '{':
+	case '}':
+	case '[':
+	case ']':
+		return true;
+	}
+	return false;
+}
+
 static void __xt_xlate_add(struct xt_xlate *xl, enum xt_xlate_type type,
-			   const char *fmt, va_list ap)
+			   bool space, const char *fmt, va_list ap)
 {
 	struct xt_xlate_buf *buf = &xl->buf[type];
+	char tmpbuf[1024] = "";
 	int len;
 
-	len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
-	if (len < 0 || len >= buf->rem)
+	len = vsnprintf(tmpbuf, 1024, fmt, ap);
+	if (len < 0 || len >= buf->rem - 1)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
+	if (space && buf->off &&
+	    !isspace(buf->data[buf->off - 1]) &&
+	    (isalnum(tmpbuf[0]) || isbrace(tmpbuf[0]))) {
+		buf->data[buf->off] = ' ';
+		buf->off++;
+		buf->rem--;
+	}
+	sprintf(buf->data + buf->off, "%s", tmpbuf);
 	buf->rem -= len;
 	buf->off += len;
 }
@@ -2509,7 +2532,16 @@ void xt_xlate_rule_add(struct xt_xlate *xl, const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	__xt_xlate_add(xl, XT_XLATE_RULE, fmt, ap);
+	__xt_xlate_add(xl, XT_XLATE_RULE, true, fmt, ap);
+	va_end(ap);
+}
+
+void xt_xlate_rule_add_nospc(struct xt_xlate *xl, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__xt_xlate_add(xl, XT_XLATE_RULE, false, fmt, ap);
 	va_end(ap);
 }
 
@@ -2518,7 +2550,16 @@ void xt_xlate_set_add(struct xt_xlate *xl, const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	__xt_xlate_add(xl, XT_XLATE_SET, fmt, ap);
+	__xt_xlate_add(xl, XT_XLATE_SET, true, fmt, ap);
+	va_end(ap);
+}
+
+void xt_xlate_set_add_nospc(struct xt_xlate *xl, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__xt_xlate_add(xl, XT_XLATE_SET, false, fmt, ap);
 	va_end(ap);
 }
 
@@ -2545,7 +2586,12 @@ uint8_t xt_xlate_get_family(struct xt_xlate *xl)
 
 const char *xt_xlate_get(struct xt_xlate *xl)
 {
-	return xl->buf[XT_XLATE_RULE].data;
+	struct xt_xlate_buf *buf = &xl->buf[XT_XLATE_RULE];
+
+	while (buf->off && isspace(buf->data[buf->off - 1]))
+		buf->data[--buf->off] = '\0';
+
+	return buf->data;
 }
 
 const char *xt_xlate_set_get(struct xt_xlate *xl)
-- 
2.38.0

