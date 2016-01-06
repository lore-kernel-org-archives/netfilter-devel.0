From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_LOG: Add translation to nft
Date: Wed, 6 Jan 2016 11:55:21 +0530
Message-ID: <20160106062520.GA3339@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33764 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbcAFGZ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jan 2016 01:25:27 -0500
Received: by mail-pf0-f174.google.com with SMTP id q63so197476487pfb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 22:25:27 -0800 (PST)
Received: from gmail.com ([223.176.134.198])
        by smtp.gmail.com with ESMTPSA id 6sm74776075pfm.46.2016.01.05.22.25.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 05 Jan 2016 22:25:26 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for options log-level and log-prefix of LOG target
to nftables.
Full translation of this target awaits the support for the options
log-tcp-sequence, log-tcp-options, log-ip-options, log-uid and
log-macdecode in nftables

Examples:

$ sudo ip6tables-translate -A FORWARD -p tcp -j LOG --log-level debug
nft add rule ip6 filter FORWARD ip6 nexthdr tcp counter log level debug

$ sudo ip6tables-translate -A FORWARD -p tcp -j LOG --log-prefix "Checking log"
nft add rule ip6 filter FORWARD ip6 nexthdr tcp counter log prefix \"Checking log\" level warn

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_LOG.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 4639268..9df86fd 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -63,6 +63,11 @@ struct ip6t_log_names {
 	unsigned int level;
 };
 
+struct ip6t_log_xlate {
+	const char *name;
+	unsigned int level;
+};
+
 static const struct ip6t_log_names ip6t_log_names[]
 = { { .name = "alert",   .level = LOG_ALERT },
     { .name = "crit",    .level = LOG_CRIT },
@@ -166,6 +171,37 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --log-macdecode");
 }
 
+static const struct ip6t_log_xlate ip6t_log_xlate_names[] = {
+	{"alert",       LOG_ALERT },
+	{"crit",        LOG_CRIT },
+	{"debug",       LOG_DEBUG },
+	{"emerg",       LOG_EMERG },
+	{"err",         LOG_ERR },
+	{"info",        LOG_INFO },
+	{"notice",      LOG_NOTICE },
+	{"warn",        LOG_WARNING }
+};
+
+static int LOG_xlate(const struct xt_entry_target *target,
+		     struct xt_buf *buf, int numeric)
+{
+	unsigned int i = 0;
+	const struct ip6t_log_info *loginfo =
+			(const struct ip6t_log_info *)target->data;
+
+	xt_buf_add(buf, "log ");
+	if (strcmp(loginfo->prefix, "") != 0)
+		xt_buf_add(buf, "prefix \\\"%s\\\" ", loginfo->prefix);
+
+	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
+		if (loginfo->level == ip6t_log_xlate_names[i].level) {
+			xt_buf_add(buf, "level %s",
+				   ip6t_log_xlate_names[i].name);
+			break;
+		}
+
+	return 1;
+}
 static struct xtables_target log_tg6_reg = {
 	.name          = "LOG",
 	.version       = XTABLES_VERSION,
@@ -178,6 +214,7 @@ static struct xtables_target log_tg6_reg = {
 	.save          = LOG_save,
 	.x6_parse      = LOG_parse,
 	.x6_options    = LOG_opts,
+	.xlate	       = LOG_xlate,
 };
 
 void _init(void)
-- 
1.9.1

