From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_LOG: Add translation to nft
Date: Tue, 5 Jan 2016 23:32:29 +0530
Message-ID: <20160105180229.GA7080@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33364 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbcAESCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 13:02:37 -0500
Received: by mail-pf0-f171.google.com with SMTP id q63so187882381pfb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 10:02:37 -0800 (PST)
Received: from gmail.com ([106.215.172.60])
        by smtp.gmail.com with ESMTPSA id c27sm103722237pfd.50.2016.01.05.10.02.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 05 Jan 2016 10:02:35 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for options log-level and log-prefix of LOG target
to nftables.
Full translation of this target awaits the support for the options
log-tcp-sequence, log-tcp-options, log-ip-options, log-uid and
log-macdecode in nftables.

Examples:

$ sudo iptables-translate -A FORWARD -p tcp -j LOG --log-level error
nft add rule ip filter FORWARD ip protocol tcp counter log level err

$ sudo iptables-translate -A FORWARD -p tcp -j LOG --log-prefix "Random prefix"
nft add rule ip filter FORWARD ip protocol tcp counter log prefix \"Random prefix\" level warn

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_LOG.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 77f16d1..f2beee3 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -63,6 +63,11 @@ struct ipt_log_names {
 	unsigned int level;
 };
 
+struct ipt_log_xlate {
+	const char *name;
+	unsigned int level;
+};
+
 static const struct ipt_log_names ipt_log_names[]
 = { { .name = "alert",   .level = LOG_ALERT },
     { .name = "crit",    .level = LOG_CRIT },
@@ -166,6 +171,37 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --log-macdecode");
 }
 
+static const struct ipt_log_xlate ipt_log_xlate_names[] = {
+	{"alert",	LOG_ALERT },
+	{"crit",	LOG_CRIT },
+	{"debug",	LOG_DEBUG },
+	{"emerg",	LOG_EMERG },
+	{"err",		LOG_ERR },
+	{"info",	LOG_INFO },
+	{"notice",	LOG_NOTICE },
+	{"warn",	LOG_WARNING }
+};
+
+static int LOG_xlate(const struct xt_entry_target *target,
+		     struct xt_buf *buf, int numeric)
+{
+	unsigned int i = 0;
+	const struct ipt_log_info *loginfo =
+			(const struct ipt_log_info *)target->data;
+
+	xt_buf_add(buf, "log ");
+	if (strcmp(loginfo->prefix, "") != 0)
+		xt_buf_add(buf, "prefix \\\"%s\\\" ", loginfo->prefix);
+
+	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
+		if (loginfo->level == ipt_log_xlate_names[i].level) {
+			xt_buf_add(buf, "level %s ",
+				   ipt_log_xlate_names[i].name);
+			break;
+		}
+
+	return 1;
+}
 static struct xtables_target log_tg_reg = {
 	.name          = "LOG",
 	.version       = XTABLES_VERSION,
@@ -178,6 +214,7 @@ static struct xtables_target log_tg_reg = {
 	.save          = LOG_save,
 	.x6_parse      = LOG_parse,
 	.x6_options    = LOG_opts,
+	.xlate	       = LOG_xlate,
 };
 
 void _init(void)
-- 
1.9.1

