From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH 2/2 conntrack-tools] conntrackd: config: Free strdup()ed tokens
Date: Fri, 27 Jan 2017 12:38:47 -0800
Message-ID: <20170127203847.10785-2-cernekee@chromium.org>
References: <20170127203847.10785-1-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33747 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdA0UjD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 15:39:03 -0500
Received: by mail-pf0-f182.google.com with SMTP id y143so75642612pfb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 12:39:03 -0800 (PST)
In-Reply-To: <20170127203847.10785-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This frees T_IP, T_PATH_VAL, and T_STRING tokens.  They were being flagged
by valgrind as memory leaks.

Lightly tested using doc/helper/conntrackd.conf and doc/stats/conntrackd.conf.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 src/read_config_yy.y | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 97f905d..f10e0db 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -116,6 +116,7 @@ logfile_bool : T_LOG T_OFF
 logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 syslog_bool : T_SYSLOG T_ON
@@ -158,11 +159,13 @@ syslog_facility : T_SYSLOG T_STRING
 	    conf.syslog_facility != conf.stats.syslog_facility)
 		dlog(LOG_WARNING, "conflicting Syslog facility "
 		     "values, defaulting to General");
+	free($2);
 };
 
 lock : T_LOCK T_PATH_VAL
 {
 	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 refreshtime : T_REFRESH T_NUMBER
@@ -257,6 +260,7 @@ multicast_option : T_IPV4_ADDR T_IP
 	}
 
 	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	free($2);
 };
 
 multicast_option : T_IPV6_ADDR T_IP
@@ -296,6 +300,7 @@ multicast_option : T_IPV6_ADDR T_IP
 		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
 		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
 	}
+	free($2);
 };
 
 multicast_option : T_IPV4_IFACE T_IP
@@ -315,11 +320,13 @@ multicast_option : T_IPV4_IFACE T_IP
 	}
 
 	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	free($2);
 };
 
 multicast_option : T_IPV6_IFACE T_IP
 {
 	dlog(LOG_WARNING, "`IPv6_interface' not required, ignoring");
+	free($2);
 }
 
 multicast_option : T_IFACE T_STRING
@@ -340,6 +347,7 @@ multicast_option : T_IFACE T_STRING
 		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
 		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
 	}
+	free($2);
 };
 
 multicast_option : T_GROUP T_NUMBER
@@ -414,6 +422,7 @@ udp_option : T_IPV4_ADDR T_IP
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
+	free($2);
 };
 
 udp_option : T_IPV6_ADDR T_IP
@@ -431,6 +440,7 @@ udp_option : T_IPV6_ADDR T_IP
 	break;
 #endif
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	free($2);
 };
 
 udp_option : T_IPV4_DEST_ADDR T_IP
@@ -459,6 +469,7 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 	break;
 #endif
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	free($2);
 };
 
 udp_option : T_IFACE T_STRING
@@ -474,6 +485,7 @@ udp_option : T_IFACE T_STRING
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.server.ipv6.scope_id = idx;
+	free($2);
 };
 
 udp_option : T_PORT T_NUMBER
@@ -552,6 +564,7 @@ tcp_option : T_IPV4_ADDR T_IP
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	free($2);
 };
 
 tcp_option : T_IPV6_ADDR T_IP
@@ -569,6 +582,7 @@ tcp_option : T_IPV6_ADDR T_IP
 	break;
 #endif
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	free($2);
 };
 
 tcp_option : T_IPV4_DEST_ADDR T_IP
@@ -580,6 +594,7 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	free($2);
 };
 
 tcp_option : T_IPV6_DEST_ADDR T_IP
@@ -597,6 +612,7 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 	break;
 #endif
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	free($2);
 };
 
 tcp_option : T_IFACE T_STRING
@@ -612,6 +628,7 @@ tcp_option : T_IFACE T_STRING
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
+	free($2);
 };
 
 tcp_option : T_PORT T_NUMBER
@@ -669,6 +686,7 @@ unix_options:
 unix_option : T_PATH T_PATH_VAL
 {
 	strcpy(conf.local.path, $2);
+	free($2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
@@ -757,6 +775,7 @@ expect_list:
 expect_item: T_STRING
 {
 	exp_filter_add(STATE(exp_filter), $1);
+	free($1);
 }
 
 sync_mode_alarm: T_SYNC_MODE T_ALARM '{' sync_mode_alarm_list '}'
@@ -993,6 +1012,7 @@ scheduler_line : T_TYPE T_STRING
 		dlog(LOG_ERR, "unknown scheduler `%s'", $2);
 		exit(EXIT_FAILURE);
 	}
+	free($2);
 };
 
 scheduler_line : T_PRIO T_NUMBER
@@ -1079,6 +1099,7 @@ filter_protocol_item : T_STRING
 	nfct_filter_add_attr_u32(STATE(filter),
 				 NFCT_FILTER_L4PROTO,
 				 pent->p_proto);
+	free($1);
 };
 
 filter_protocol_item : T_TCP
@@ -1209,6 +1230,7 @@ filter_address_item : T_IPV4_ADDR T_IP
 
 	nfct_filter_add_attr(STATE(filter), NFCT_FILTER_SRC_IPV4, &filter_ipv4);
 	nfct_filter_add_attr(STATE(filter), NFCT_FILTER_DST_IPV4, &filter_ipv4);
+	free($2);
 };
 
 filter_address_item : T_IPV6_ADDR T_IP
@@ -1268,6 +1290,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 
 	nfct_filter_add_attr(STATE(filter), NFCT_FILTER_SRC_IPV6, &filter_ipv6);
 	nfct_filter_add_attr(STATE(filter), NFCT_FILTER_DST_IPV6, &filter_ipv6);
+	free($2);
 };
 
 filter_item : T_STATE T_ACCEPT '{' filter_state_list '}'
@@ -1330,6 +1353,7 @@ stat_logfile_bool : T_LOG T_OFF
 stat_logfile_path : T_LOG T_PATH_VAL
 {
 	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+	free($2);
 };
 
 stat_syslog_bool : T_SYSLOG T_ON
@@ -1372,6 +1396,7 @@ stat_syslog_facility : T_SYSLOG T_STRING
 	    conf.stats.syslog_facility != conf.syslog_facility)
 		dlog(LOG_WARNING, "conflicting Syslog facility "
 		     "values, defaulting to General");
+	free($2);
 };
 
 helper: T_HELPER '{' helper_list '}'
@@ -1484,6 +1509,9 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 		}
 	}
 	list_add(&helper_inst->head, &CONFIG(cthelper).list);
+	free($2);
+	free($3);
+	free($4);
 };
 
 helper_type_list:
@@ -1534,6 +1562,7 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
 	stack_item_push(&symbol_stack, e);
+	free($2);
 };
 
 helper_policy_list:
-- 
2.7.4

