From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: LOG: add log flags translation to nft
Date: Sun, 27 Nov 2016 20:08:29 +0800
Message-ID: <1480248509-21828-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:41715 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753576AbcK0MJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 07:09:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

For example:
 # iptables-translate -A OUTPUT -j LOG --log-uid
 nft add rule ip filter OUTPUT counter log flags skuid

 # iptables-translate -A OUTPUT -j LOG --log-tcp-sequence \
 --log-tcp-options
 nft add rule ip filter OUTPUT counter log flags tcp sequence,options

 # iptables-translate -A OUTPUT -j LOG --log-level debug --log-uid
 nft add rule ip filter OUTPUT counter log level debug flags skuid

 # ip6tables-translate -A OUTPUT -j LOG --log-ip-options --log-macdecode
 nft add rule ip6 filter OUTPUT counter log flags ip options flags ether

 # ip6tables-translate -A OUTPUT -j LOG --log-ip-options --log-uid \
 --log-tcp-sequence --log-tcp-options --log-macdecode
 nft add rule ip6 filter OUTPUT counter log flags all

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 extensions/libip6t_LOG.c | 30 ++++++++++++++++++++++++++----
 extensions/libipt_LOG.c  | 30 ++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index af77b9a..40adc69 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -189,22 +189,44 @@ static int LOG_xlate(struct xt_xlate *xl,
 		(const struct ip6t_log_info *)params->target->data;
 	unsigned int i = 0;
 
-	xt_xlate_add(xl, "log ");
+	xt_xlate_add(xl, "log");
 	if (strcmp(loginfo->prefix, "") != 0) {
 		if (params->escape_quotes)
-			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
 		else
-			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
 		if (loginfo->level == ip6t_log_xlate_names[i].level &&
 		    loginfo->level != LOG_DEFAULT_LEVEL) {
-			xt_xlate_add(xl, "level %s",
+			xt_xlate_add(xl, " level %s",
 				   ip6t_log_xlate_names[i].name);
 			break;
 		}
 
+	if ((loginfo->logflags & IP6T_LOG_MASK) == IP6T_LOG_MASK) {
+		xt_xlate_add(xl, " flags all");
+	} else {
+		if (loginfo->logflags & (IP6T_LOG_TCPSEQ | IP6T_LOG_TCPOPT)) {
+			const char *delim = " ";
+
+			xt_xlate_add(xl, " flags tcp");
+			if (loginfo->logflags & IP6T_LOG_TCPSEQ) {
+				xt_xlate_add(xl, " sequence");
+				delim = ",";
+			}
+			if (loginfo->logflags & IP6T_LOG_TCPOPT)
+				xt_xlate_add(xl, "%soptions", delim);
+		}
+		if (loginfo->logflags & IP6T_LOG_IPOPT)
+			xt_xlate_add(xl, " flags ip options");
+		if (loginfo->logflags & IP6T_LOG_UID)
+			xt_xlate_add(xl, " flags skuid");
+		if (loginfo->logflags & IP6T_LOG_MACDECODE)
+			xt_xlate_add(xl, " flags ether");
+	}
+
 	return 1;
 }
 static struct xtables_target log_tg6_reg = {
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 2784d9b..36e2e73 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -189,22 +189,44 @@ static int LOG_xlate(struct xt_xlate *xl,
 		(const struct ipt_log_info *)params->target->data;
 	unsigned int i = 0;
 
-	xt_xlate_add(xl, "log ");
+	xt_xlate_add(xl, "log");
 	if (strcmp(loginfo->prefix, "") != 0) {
 		if (params->escape_quotes)
-			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
 		else
-			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
 		if (loginfo->level != LOG_DEFAULT_LEVEL &&
 		    loginfo->level == ipt_log_xlate_names[i].level) {
-			xt_xlate_add(xl, "level %s ",
+			xt_xlate_add(xl, " level %s",
 				   ipt_log_xlate_names[i].name);
 			break;
 		}
 
+	if ((loginfo->logflags & IPT_LOG_MASK) == IPT_LOG_MASK) {
+		xt_xlate_add(xl, " flags all");
+	} else {
+		if (loginfo->logflags & (IPT_LOG_TCPSEQ | IPT_LOG_TCPOPT)) {
+			const char *delim = " ";
+
+			xt_xlate_add(xl, " flags tcp");
+			if (loginfo->logflags & IPT_LOG_TCPSEQ) {
+				xt_xlate_add(xl, " sequence");
+				delim = ",";
+			}
+			if (loginfo->logflags & IPT_LOG_TCPOPT)
+				xt_xlate_add(xl, "%soptions", delim);
+		}
+		if (loginfo->logflags & IPT_LOG_IPOPT)
+			xt_xlate_add(xl, " flags ip options");
+		if (loginfo->logflags & IPT_LOG_UID)
+			xt_xlate_add(xl, " flags skuid");
+		if (loginfo->logflags & IPT_LOG_MACDECODE)
+			xt_xlate_add(xl, " flags ether");
+	}
+
 	return 1;
 }
 static struct xtables_target log_tg_reg = {
-- 
2.5.5


