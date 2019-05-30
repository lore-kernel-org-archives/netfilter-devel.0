Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293F7C28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 20:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB6823F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 20:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jgR5t5KU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfE3UuB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 16:50:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46617 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3UuB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 16:50:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so5032382wrr.13
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Ds/8Q3nzhjRti10SXcnceadSOxIF9RIfstp/zQ3mPDE=;
        b=jgR5t5KUAD5bPBrPDAwwq3YOe0kBEBfiFw9Uj/RTd7s8C9J904tbizIU+ph8dDt5ug
         aoq0zN0LyA9dptGeMcu3dey6CNK5AJsJ+2DTbeaRchqrTM4fi2LFjzZ55iGRigsJigMp
         cYzxyipTkm+HR1c86gnTk4S74vVjUGWTNEVqVO16SYaZZ1nk7m6bJ1V33z97st0oQkUe
         1oTX5faXDN5Hyn8LBFYKTSER2NFwsC+BCXuY7+n1RzsZrBhmlt7icAo4IdHTTin3Fby9
         NJKCIQr7MtobQ3H/wYHP1GOn7jzdsdxiRo19IFQDNB+Q7ZmJ641pmQ/KjioNfMjE3IRv
         AJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ds/8Q3nzhjRti10SXcnceadSOxIF9RIfstp/zQ3mPDE=;
        b=VGmlHRnNA8u/cBUq2DxC6ILQ76pM+v9YDGRsWvIGwk8eZkZUCf1GKQt97+ovm8JQ34
         m2e64sqbTfz7putbSQ9XK6uVVvwlDVtSXqMuWUf71OLrMHiyof3zG0Q2p/RskuEzapgo
         6fhq3GG6vX128sUr2zrcSkxeeuZWkWW1De2JeSGgwdbMeiXphGEZB/IxftjoBF4/KtHl
         /gkjNiqdZmvJAczryd6irN9STDFOIB+CkYFwwtjwixTB4rJdV2pq4uLdlix76LNZm9UF
         Ga4jcHBdtE2S1IhUgpEmxdHhpeRa1z/+xNTh8PZxqBZhLXW5jNLz4D4HiB0xstjPlZGQ
         tQeg==
X-Gm-Message-State: APjAAAVO4OKgrcTh+/5WAtTFuK8htqaCdqYvtTTrgexkp/ripoENz/4t
        lgTP0OiWNjNMfdA/VuVUF3LSkh73
X-Google-Smtp-Source: APXvYqypodCbPPzNkkQTEMmd0JSn20WmZ01yE95WTWKUDaHYZ8EGuDJoxTq/LeYvk6sw/m9C+UnklA==
X-Received: by 2002:adf:fbc7:: with SMTP id d7mr3619986wrs.224.1559249397652;
        Thu, 30 May 2019 13:49:57 -0700 (PDT)
Received: from ash-clevo (80.104.199.146.dyn.plus.net. [146.199.104.80])
        by smtp.gmail.com with ESMTPSA id l18sm2502166wrv.38.2019.05.30.13.49.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 13:49:56 -0700 (PDT)
Date:   Thu, 30 May 2019 21:49:56 +0100
From:   Ash Hughes <sehguh.hsa@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v2] conntrackd: Use strdup in lexer
Message-ID: <20190530204956.GA7776@ash-clevo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use strdup in the config file lexer to copy strings to yylval.string. This should solve the "[ERROR] unknown layer 3 protocol" problem here: https://www.spinics.net/lists/netfilter/msg58628.html

v2: Changed spaces to tabs.

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
index 1d510ed..1f506d1 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -117,6 +117,7 @@ logfile_bool : T_LOG T_OFF
 logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 syslog_bool : T_SYSLOG T_ON
@@ -152,8 +153,10 @@ syslog_facility : T_SYSLOG T_STRING
 	else {
 		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
 		     "ignoring", $2);
+		free($2);
 		break;
 	}
+	free($2);
 
 	if (conf.stats.syslog_facility != -1 &&
 	    conf.syslog_facility != conf.stats.syslog_facility)
@@ -164,6 +167,7 @@ syslog_facility : T_SYSLOG T_STRING
 lock : T_LOCK T_PATH_VAL
 {
 	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 refreshtime : T_REFRESH T_NUMBER
@@ -225,6 +229,7 @@ multicast_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
 
@@ -235,6 +240,7 @@ multicast_option : T_IPV4_ADDR T_IP
 		break;
 	}
 
+	free($2);
 	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
 };
 
@@ -247,6 +253,7 @@ multicast_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.mcast.in);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+		free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
@@ -257,6 +264,7 @@ multicast_option : T_IPV6_ADDR T_IP
 		dlog(LOG_WARNING, "your multicast address is IPv6 but "
 		     "is binded to an IPv4 interface? "
 		     "Surely this is not what you want");
+		free($2);
 		break;
 	}
 
@@ -269,12 +277,14 @@ multicast_option : T_IPV6_ADDR T_IP
 		idx = if_nametoindex($2);
 		if (!idx) {
 			dlog(LOG_WARNING, "%s is an invalid interface", $2);
+			free($2);
 			break;
 		}
 
 		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
 		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
 	}
+	free($2);
 };
 
 multicast_option : T_IPV4_IFACE T_IP
@@ -283,8 +293,10 @@ multicast_option : T_IPV4_IFACE T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.ifa)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
+	free($2);
 
         if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
 		dlog(LOG_WARNING, "your multicast interface is IPv4 but "
@@ -299,6 +311,7 @@ multicast_option : T_IPV4_IFACE T_IP
 multicast_option : T_IPV6_IFACE T_IP
 {
 	dlog(LOG_WARNING, "`IPv6_interface' not required, ignoring");
+	free($2);
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
+	free($2);
 };
 
 multicast_option : T_GROUP T_NUMBER
@@ -390,8 +406,10 @@ udp_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.server.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
+	free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
 };
 
@@ -404,12 +422,14 @@ udp_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.udp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+		free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+	free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
 };
 
@@ -419,8 +439,10 @@ udp_option : T_IPV4_DEST_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.client)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
+	free($2);
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
 };
 
@@ -433,12 +455,14 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 			&conf.channel[conf.channel_num].u.udp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+		free($2);
 		break;
 	} else {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+	free($2);
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
+	free($2);
 };
 
 udp_option : T_PORT T_NUMBER
@@ -530,8 +557,10 @@ tcp_option : T_IPV4_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.server.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
+	free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
 };
 
@@ -544,12 +573,14 @@ tcp_option : T_IPV6_ADDR T_IP
 			&conf.channel[conf.channel_num].u.tcp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+		free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+	free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -559,8 +590,10 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.client)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
+		free($2);
 		break;
 	}
+	free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
 };
 
@@ -573,12 +606,14 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 			&conf.channel[conf.channel_num].u.tcp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
+		free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
 		exit(EXIT_FAILURE);
 	}
 
+	free($2);
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -592,9 +627,12 @@ tcp_option : T_IFACE T_STRING
 	idx = if_nametoindex($2);
 	if (!idx) {
 		dlog(LOG_WARNING, "%s is an invalid interface", $2);
+		free($2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
+
+	free($2);
 };
 
 tcp_option : T_PORT T_NUMBER
@@ -652,6 +690,7 @@ unix_options:
 unix_option : T_PATH T_PATH_VAL
 {
 	strncpy(conf.local.path, $2, PATH_MAX);
+	free($2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
@@ -739,6 +778,7 @@ expect_list:
 expect_item: T_STRING
 {
 	exp_filter_add(STATE(exp_filter), $1);
+	free($1);
 }
 
 sync_mode_alarm: T_SYNC_MODE T_ALARM '{' sync_mode_alarm_list '}'
@@ -988,6 +1028,8 @@ scheduler_line : T_TYPE T_STRING
 		dlog(LOG_ERR, "unknown scheduler `%s'", $2);
 		exit(EXIT_FAILURE);
 	}
+
+	free($2);
 };
 
 scheduler_line : T_PRIO T_NUMBER
@@ -1065,8 +1107,10 @@ filter_protocol_item : T_STRING
 	if (pent == NULL) {
 		dlog(LOG_WARNING, "getprotobyname() cannot find "
 		     "protocol `%s' in /etc/protocols", $1);
+		free($1);
 		break;
 	}
+	free($1);
 	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
 
 	__kernel_filter_start();
@@ -1163,12 +1207,14 @@ filter_address_item : T_IPV4_ADDR T_IP
 		if (cidr > 32) {
 			dlog(LOG_WARNING, "%s/%d is not a valid network, "
 			     "ignoring", $2, cidr);
+			free($2);
 			break;
 		}
 	}
 
 	if (!inet_aton($2, &ip.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
+		free($2);
 		break;
 	}
 
@@ -1194,6 +1240,7 @@ filter_address_item : T_IPV4_ADDR T_IP
 				     "ignore pool!");
 		}
 	}
+	free($2);
 	__kernel_filter_start();
 
 	/* host byte order */
@@ -1223,6 +1270,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 		if (cidr > 128) {
 			dlog(LOG_WARNING, "%s/%d is not a valid network, "
 			     "ignoring", $2, cidr);
+			free($2);
 			break;
 		}
 	}
@@ -1230,6 +1278,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 	err = inet_pton(AF_INET6, $2, &ip.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
+		free($2);
 		break;
 	} else if (err < 0) {
 		dlog(LOG_ERR, "inet_pton(): IPv6 unsupported!");
@@ -1256,6 +1305,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 				     "ignore pool!");
 		}
 	}
+	free($2);
 	__kernel_filter_start();
 
 	/* host byte order */
@@ -1326,6 +1376,7 @@ stat_logfile_bool : T_LOG T_OFF
 stat_logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 stat_syslog_bool : T_SYSLOG T_ON
@@ -1361,8 +1412,10 @@ stat_syslog_facility : T_SYSLOG T_STRING
 	else {
 		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
 		     "ignoring.", $2);
+		free($2);
 		break;
 	}
+	free($2);
 
 	if (conf.syslog_facility != -1 &&
 	    conf.stats.syslog_facility != conf.syslog_facility)
@@ -1398,6 +1451,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 		dlog(LOG_ERR, "unknown layer 3 protocol");
 		exit(EXIT_FAILURE);
 	}
+	free($3);
 
 	if (strcmp($4, "tcp") == 0)
 		l4proto = IPPROTO_TCP;
@@ -1407,6 +1461,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 		dlog(LOG_ERR, "unknown layer 4 protocol");
 		exit(EXIT_FAILURE);
 	}
+	free($4);
 
 #ifdef BUILD_CTHELPER
 	helper = helper_find(CONNTRACKD_LIB_DIR, $2, l4proto, RTLD_NOW);
@@ -1418,6 +1473,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	dlog(LOG_ERR, "Helper support is disabled, recompile conntrackd");
 	exit(EXIT_FAILURE);
 #endif
+	free($2);
 
 	helper_inst = calloc(1, sizeof(struct ctd_helper_instance));
 	if (helper_inst == NULL)
@@ -1526,6 +1582,7 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 
 	policy = (struct ctd_helper_policy *) &e->data;
 	strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
+	free($2);
 	policy->name[CTD_HELPER_NAME_LEN-1] = '\0';
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
-- 
2.21.0

