Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB634C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 20:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B72320859
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 20:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c966+HI/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfE0U7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 16:59:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50304 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfE0U7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 16:59:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so635638wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2019 13:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=c7oenANALCVGGlZ+exuF+5GflWghU3LiwUFufIbdAOg=;
        b=c966+HI/dUTaqlgwBzX/aEHW3mn7v0Iv+qWAQQvqDxotoQt9d2FzOaDXsWwGdn2ImN
         tLLV9LHTtMnyTPdCuAz6p4vRCTDoNRbUpojY01yifj1OEhKUJm6TfMHVs8NNzxm1RyGj
         E6pH18ywoxk5uEOgxkD1ypG+PWqepyqDq1CiGAZq5wv918QR+ErBra0o0UZObRs/fusN
         l6sl8N8zdtS9t+lHbvDWYWdB4nO2pRD85iUCkVgtCpD7BFS1HmQzNu9qrbAP39pcWhqu
         QW/P5dyoC5feQhdYLLqZPzatxMiNAOvPXiJxOTPFWKkAeF255YJTtQxYsnQsbAiuMhtp
         l2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=c7oenANALCVGGlZ+exuF+5GflWghU3LiwUFufIbdAOg=;
        b=qX+Gtg7U7WAPWndd5rDzdpWAS+2GdwxtRrhekLrw7OwYVjqRtq9UVndc6w01EKKdd2
         /oQfu48nbrUns6u17PEve5DfDaRni8cXbSScjMe4myUTl5r0w4sTZaJ8veXeJ4Ohnl4m
         5nKq86eA8yWqff8kgMA2beRk1RuFGD1e6aJvrFZaiPUBnXPz/rudG6vID7IR8NnGEKJ/
         02CWeL0L2gIHh9AlV89CI0iyyK8GVMHZjKO9kazF+qU/M84RUp22ol3vqOYo93aBMBe3
         I5R7vjkdeKfnAzcUuLYqMfZoB+R1zLvyPtrMTSMkEs9vMUyxTNso8kxTZlvfaXEpfsO2
         flEQ==
X-Gm-Message-State: APjAAAVRkKT66surcrWzAMNI++I905GBYxaPpEGZVZCqF+AZ/W85Hbru
        ydjMRTuAr4H5nYp27VGxTopv2hzd
X-Google-Smtp-Source: APXvYqyBp06od9CSTQG690IIzjf1nh9svRJJHhU8h2P1he28t153NysVi9eIzlIi8HWZLqxlzpgkiA==
X-Received: by 2002:a1c:ef05:: with SMTP id n5mr579864wmh.149.1558990784973;
        Mon, 27 May 2019 13:59:44 -0700 (PDT)
Received: from ash-clevo (80.104.199.146.dyn.plus.net. [146.199.104.80])
        by smtp.gmail.com with ESMTPSA id l18sm32106516wrh.54.2019.05.27.13.59.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 13:59:44 -0700 (PDT)
Date:   Mon, 27 May 2019 21:59:43 +0100
From:   Ash Hughes <sehguh.hsa@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] conntrackd: Use strdup in lexer
Message-ID: <20190527205943.GA16450@ash-clevo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use strdup in the config file lexer to copy strings to yylval.string. This should solve the "[ERROR] unknown layer 3 protocol" problem here: https://www.spinics.net/lists/netfilter/msg58628.html

Signed-off-by: Ash Hughes <sehguh.hsa@gmail.com>
---
 src/read_config_lex.l |  8 +++---
 src/read_config_yy.y  | 57 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 120bc00..b0d9e61 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -142,9 +142,9 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 {is_off}		{ return T_OFF; }
 {integer}		{ yylval.val = atoi(yytext); return T_NUMBER; }
 {signed_integer}	{ yylval.val = atoi(yytext); return T_SIGNED_NUMBER; }
-{ip4}			{ yylval.string = yytext; return T_IP; }
-{ip6}			{ yylval.string = yytext; return T_IP; }
-{path}			{ yylval.string = yytext; return T_PATH_VAL; }
+{ip4}			{ yylval.string = strdup(yytext); return T_IP; }
+{ip6}			{ yylval.string = strdup(yytext); return T_IP; }
+{path}			{ yylval.string = strdup(yytext); return T_PATH_VAL; }
 {alarm}			{ return T_ALARM; }
 {persistent}		{ dlog(LOG_WARNING, "Now `persistent' mode "
 			       "is called `alarm'. Please, update "
@@ -156,7 +156,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 			       "your conntrackd.conf file.\n");
 			  return T_FTFW; }
 {notrack}		{ return T_NOTRACK; }
-{string}		{ yylval.string = yytext; return T_STRING; }
+{string}		{ yylval.string = strdup(yytext); return T_STRING; }
 
 {comment}	;
 {ws}		;
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 1d510ed..1cb9cce 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -117,6 +117,7 @@ logfile_bool : T_LOG T_OFF
 logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+    free($2);
 };
 
 syslog_bool : T_SYSLOG T_ON
@@ -152,8 +153,10 @@ syslog_facility : T_SYSLOG T_STRING
 	else {
 		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
 		     "ignoring", $2);
+        free($2);
 		break;
 	}
+    free($2);
 
 	if (conf.stats.syslog_facility != -1 &&
 	    conf.syslog_facility != conf.stats.syslog_facility)
@@ -164,6 +167,7 @@ syslog_facility : T_SYSLOG T_STRING
 lock : T_LOCK T_PATH_VAL
 {
 	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+    free($2);
 };
 
 refreshtime : T_REFRESH T_NUMBER
@@ -225,6 +229,7 @@ multicast_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
 
@@ -235,6 +240,7 @@ multicast_option : T_IPV4_ADDR T_IP
 		break;
 	}
 
+    free($2);
 	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
 };
 
@@ -247,6 +253,7 @@ multicast_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.mcast.in);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+        free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
@@ -257,6 +264,7 @@ multicast_option : T_IPV6_ADDR T_IP
 		dlog(LOG_WARNING, "your multicast address is IPv6 but "
 		     "is binded to an IPv4 interface? "
 		     "Surely this is not what you want");
+        free($2);
 		break;
 	}
 
@@ -269,12 +277,14 @@ multicast_option : T_IPV6_ADDR T_IP
 		idx = if_nametoindex($2);
 		if (!idx) {
 			dlog(LOG_WARNING, "%s is an invalid interface", $2);
+            free($2);
 			break;
 		}
 
 		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
 		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
 	}
+    free($2);
 };
 
 multicast_option : T_IPV4_IFACE T_IP
@@ -283,8 +293,10 @@ multicast_option : T_IPV4_IFACE T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.ifa)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
+    free($2);
 
         if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
 		dlog(LOG_WARNING, "your multicast interface is IPv4 but "
@@ -299,6 +311,7 @@ multicast_option : T_IPV4_IFACE T_IP
 multicast_option : T_IPV6_IFACE T_IP
 {
 	dlog(LOG_WARNING, "`IPv6_interface' not required, ignoring");
+    free($2);
 }
 
 multicast_option : T_IFACE T_STRING
@@ -312,6 +325,7 @@ multicast_option : T_IFACE T_STRING
 	idx = if_nametoindex($2);
 	if (!idx) {
 		dlog(LOG_WARNING, "%s is an invalid interface", $2);
+		free($2);
 		break;
 	}
 
@@ -319,6 +333,8 @@ multicast_option : T_IFACE T_STRING
 		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
 		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
 	}
+
+    free($2);
 };
 
 multicast_option : T_GROUP T_NUMBER
@@ -390,8 +406,10 @@ udp_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.server.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
+    free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
 };
 
@@ -404,12 +422,14 @@ udp_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.udp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+        free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+    free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
 };
 
@@ -419,8 +439,10 @@ udp_option : T_IPV4_DEST_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.client)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
+    free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
 };
 
@@ -433,12 +455,14 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 			&conf.channel[conf.channel_num].u.udp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+        free($2);
 		break;
 	} else {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+    free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
 };
 
@@ -452,9 +476,12 @@ udp_option : T_IFACE T_STRING
 	idx = if_nametoindex($2);
 	if (!idx) {
 		dlog(LOG_WARNING, "%s is an invalid interface", $2);
+		free($2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.server.ipv6.scope_id = idx;
+
+    free($2);
 };
 
 udp_option : T_PORT T_NUMBER
@@ -530,8 +557,10 @@ tcp_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.server.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
+    free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
 };
 
@@ -544,12 +573,14 @@ tcp_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.tcp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+        free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+    free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -559,8 +590,10 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.client)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+        free($2);
 		break;
 	}
+    free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
 };
 
@@ -573,12 +606,14 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 			&conf.channel[conf.channel_num].u.tcp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+        free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+    free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -592,9 +627,12 @@ tcp_option : T_IFACE T_STRING
 	idx = if_nametoindex($2);
 	if (!idx) {
 		dlog(LOG_WARNING, "%s is an invalid interface", $2);
+        free($2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
+
+    free($2);
 };
 
 tcp_option : T_PORT T_NUMBER
@@ -652,6 +690,7 @@ unix_options:
 unix_option : T_PATH T_PATH_VAL
 {
 	strncpy(conf.local.path, $2, PATH_MAX);
+    free($2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
@@ -739,6 +778,7 @@ expect_list:
 expect_item: T_STRING
 {
 	exp_filter_add(STATE(exp_filter), $1);
+    free($1);
 }
 
 sync_mode_alarm: T_SYNC_MODE T_ALARM '{' sync_mode_alarm_list '}'
@@ -988,6 +1028,8 @@ scheduler_line : T_TYPE T_STRING
 		dlog(LOG_ERR, "unknown scheduler `%s'", $2);
 		exit(EXIT_FAILURE);
 	}
+
+    free($2);
 };
 
 scheduler_line : T_PRIO T_NUMBER
@@ -1065,8 +1107,10 @@ filter_protocol_item : T_STRING
 	if (pent == NULL) {
 		dlog(LOG_WARNING, "getprotobyname() cannot find "
 		     "protocol `%s' in /etc/protocols", $1);
+        free($1);
 		break;
 	}
+    free($1);
 	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
 
 	__kernel_filter_start();
@@ -1163,12 +1207,14 @@ filter_address_item : T_IPV4_ADDR T_IP
 		if (cidr > 32) {
 			dlog(LOG_WARNING, "%s/%d is not a valid network, "
 			     "ignoring", $2, cidr);
+            free($2);
 			break;
 		}
 	}
 
 	if (!inet_aton($2, &ip.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
+        free($2);
 		break;
 	}
 
@@ -1194,6 +1240,7 @@ filter_address_item : T_IPV4_ADDR T_IP
 				     "ignore pool!");
 		}
 	}
+    free($2);
 	__kernel_filter_start();
 
 	/* host byte order */
@@ -1223,6 +1270,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 		if (cidr > 128) {
 			dlog(LOG_WARNING, "%s/%d is not a valid network, "
 			     "ignoring", $2, cidr);
+            free($2);
 			break;
 		}
 	}
@@ -1230,6 +1278,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 	err = inet_pton(AF_INET6, $2, &ip.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
+        free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
@@ -1256,6 +1305,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 				     "ignore pool!");
 		}
 	}
+    free($2);
 	__kernel_filter_start();
 
 	/* host byte order */
@@ -1326,6 +1376,7 @@ stat_logfile_bool : T_LOG T_OFF
 stat_logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+    free($2);
 };
 
 stat_syslog_bool : T_SYSLOG T_ON
@@ -1361,8 +1412,10 @@ stat_syslog_facility : T_SYSLOG T_STRING
 	else {
 		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
 		     "ignoring.", $2);
+        free($2);
 		break;
 	}
+    free($2);
 
 	if (conf.syslog_facility != -1 &&
 	    conf.stats.syslog_facility != conf.syslog_facility)
@@ -1398,6 +1451,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 		dlog(LOG_ERR, "unknown layer 3 protocol");
 		exit(EXIT_FAILURE);
 	}
+    free($3);
 
 	if (strcmp($4, "tcp") == 0)
 		l4proto = IPPROTO_TCP;
@@ -1407,6 +1461,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 		dlog(LOG_ERR, "unknown layer 4 protocol");
 		exit(EXIT_FAILURE);
 	}
+    free($4);
 
 #ifdef BUILD_CTHELPER
 	helper = helper_find(CONNTRACKD_LIB_DIR, $2, l4proto, RTLD_NOW);
@@ -1418,6 +1473,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	dlog(LOG_ERR, "Helper support is disabled, recompile conntrackd");
 	exit(EXIT_FAILURE);
 #endif
+    free($2);
 
 	helper_inst = calloc(1, sizeof(struct ctd_helper_instance));
 	if (helper_inst == NULL)
@@ -1526,6 +1582,7 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 
 	policy = (struct ctd_helper_policy *) &e->data;
 	strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
+    free($2);
 	policy->name[CTD_HELPER_NAME_LEN-1] = '\0';
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
-- 
2.21.0

