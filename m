From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 2/3] conntrackd: replace error reporting in
 the config parser with dlog()
Date: Fri, 04 Nov 2016 11:37:07 +0100
Message-ID: <147825582747.31164.14730910801546363786.stgit@nfdev2.cica.es>
References: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53281 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761197AbcKDKhH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 06:37:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1222A51F304
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 10:37:03 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kyWwp7UVnsrv for <netfilter-devel@vger.kernel.org>;
        Fri,  4 Nov 2016 11:36:55 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 9DD6251F301
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 11:36:55 +0100 (CET)
In-Reply-To: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that our main log function is able to handle the case of the log engine
not being initialised, we can use the general function instead of a custom
one in the parser.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/read_config_yy.y |  321 ++++++++++++++++++++++----------------------------
 1 file changed, 140 insertions(+), 181 deletions(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index cc0eb18..bfe7abb 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -30,7 +30,6 @@
 #include "cidr.h"
 #include "helper.h"
 #include "stack.h"
-#include <syslog.h>
 #include <sched.h>
 #include <dlfcn.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -41,13 +40,6 @@ extern int   yylineno;
 
 struct ct_conf conf;
 
-enum {
-	CTD_CFG_ERROR = 0,
-	CTD_CFG_WARN,
-};
-
-static void print_err(int err, const char *msg, ...);
-
 static void __kernel_filter_start(void);
 static void __kernel_filter_add_state(int value);
 static void __max_dedicated_links_reached(void);
@@ -160,15 +152,15 @@ syslog_facility : T_SYSLOG T_STRING
 	else if (!strcmp($2, "local7"))
 		conf.syslog_facility = LOG_LOCAL7;
 	else {
-		print_err(CTD_CFG_WARN, "'%s' is not a known syslog facility, "
-					"ignoring", $2);
+		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
+		     "ignoring", $2);
 		break;
 	}
 
 	if (conf.stats.syslog_facility != -1 &&
 	    conf.syslog_facility != conf.stats.syslog_facility)
-	    	print_err(CTD_CFG_WARN, "conflicting Syslog facility "
-					"values, defaulting to General");
+		dlog(LOG_WARNING, "conflicting Syslog facility "
+		     "values, defaulting to General");
 };
 
 lock : T_LOCK T_PATH_VAL
@@ -178,7 +170,7 @@ lock : T_LOCK T_PATH_VAL
 
 strip_nat: T_STRIP_NAT
 {
-	print_err(CTD_CFG_WARN, "`StripNAT' clause is obsolete, ignoring");
+	dlog(LOG_WARNING, "`StripNAT' clause is obsolete, ignoring");
 };
 
 refreshtime : T_REFRESH T_NUMBER
@@ -203,8 +195,8 @@ purge: T_PURGE T_NUMBER
 
 checksum: T_CHECKSUM T_ON 
 {
-	print_err(CTD_CFG_WARN, "the use of `Checksum' outside the "
-				"`Multicast' clause is ambiguous");
+	dlog(LOG_WARNING, "the use of `Checksum' outside the "
+	     "`Multicast' clause is ambiguous");
 	/* 
 	 * XXX: The use of Checksum outside of the Multicast clause is broken
 	 *	if we have more than one dedicated links.
@@ -214,8 +206,8 @@ checksum: T_CHECKSUM T_ON
 
 checksum: T_CHECKSUM T_OFF
 {
-	print_err(CTD_CFG_WARN, "the use of `Checksum' outside the "
-				"`Multicast' clause is ambiguous");
+	dlog(LOG_WARNING, "the use of `Checksum' outside the "
+	     "`Multicast' clause is ambiguous");
 	/*
 	 * XXX: The use of Checksum outside of the Multicast clause is broken
 	 *	if we have more than one dedicated links.
@@ -229,8 +221,8 @@ ignore_traffic : T_IGNORE_TRAFFIC '{' ignore_traffic_options '}'
 			    CT_FILTER_ADDRESS,
 			    CT_FILTER_NEGATIVE);
 
-	print_err(CTD_CFG_WARN, "the clause `IgnoreTrafficFor' is obsolete. "
-				"Use `Filter' instead");
+	dlog(LOG_WARNING, "the clause `IgnoreTrafficFor' is obsolete. "
+	     "Use `Filter' instead");
 };
 
 ignore_traffic_options :
@@ -243,18 +235,17 @@ ignore_traffic_option : T_IPV4_ADDR T_IP
 	memset(&ip, 0, sizeof(union inet_address));
 
 	if (!inet_aton($2, &ip.ipv4)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4, "
-					"ignoring", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
 		break;
 	}
 
 	if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET)) {
 		if (errno == EEXIST)
-			print_err(CTD_CFG_WARN, "IP %s is repeated "
-						"in the ignore pool", $2);
+			dlog(LOG_WARNING, "IP %s is repeated "
+			     "in the ignore pool", $2);
 		if (errno == ENOSPC)
-			print_err(CTD_CFG_WARN, "too many IP in the "
-						"ignore pool!");
+			dlog(LOG_WARNING, "too many IP in the "
+			     "ignore pool!");
 	}
 };
 
@@ -266,20 +257,19 @@ ignore_traffic_option : T_IPV6_ADDR T_IP
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2, &ip.ipv6) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6, ignoring", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 #endif
 
 	if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET6)) {
 		if (errno == EEXIST)
-			print_err(CTD_CFG_WARN, "IP %s is repeated "
-						"in the ignore pool", $2);
+			dlog(LOG_WARNING, "IP %s is repeated "
+			     "in the ignore pool", $2);
 		if (errno == ENOSPC)
-			print_err(CTD_CFG_WARN, "too many IP in the "
-						"ignore pool!");
+			dlog(LOG_WARNING, "too many IP in the ignore pool!");
 	}
 
 };
@@ -288,8 +278,8 @@ multicast_line : T_MULTICAST '{' multicast_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_MCAST) {
-		print_err(CTD_CFG_ERROR, "cannot use `Multicast' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `Multicast' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_MCAST;
@@ -302,8 +292,8 @@ multicast_line : T_MULTICAST T_DEFAULT '{' multicast_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_MCAST) {
-		print_err(CTD_CFG_ERROR, "cannot use `Multicast' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `Multicast' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_MCAST;
@@ -322,14 +312,14 @@ multicast_option : T_IPV4_ADDR T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 
         if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
-		print_err(CTD_CFG_WARN, "your multicast address is IPv4 but "
-					"is binded to an IPv6 interface? "
-					"Surely, this is not what you want");
+		dlog(LOG_WARNING, "your multicast address is IPv4 but "
+		     "is binded to an IPv6 interface? "
+		     "Surely, this is not what you want");
 		break;
 	}
 
@@ -343,18 +333,18 @@ multicast_option : T_IPV6_ADDR T_IP
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
 		      &conf.channel[conf.channel_num].u.mcast.in) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 
 	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET) {
-		print_err(CTD_CFG_WARN, "your multicast address is IPv6 but "
-					"is binded to an IPv4 interface? "
-					"Surely this is not what you want");
+		dlog(LOG_WARNING, "your multicast address is IPv6 but "
+		     "is binded to an IPv4 interface? "
+		     "Surely this is not what you want");
 		break;
 	}
 
@@ -366,8 +356,7 @@ multicast_option : T_IPV6_ADDR T_IP
 
 		idx = if_nametoindex($2);
 		if (!idx) {
-			print_err(CTD_CFG_WARN,
-				  "%s is an invalid interface", $2);
+			dlog(LOG_WARNING, "%s is an invalid interface", $2);
 			break;
 		}
 
@@ -381,14 +370,14 @@ multicast_option : T_IPV4_IFACE T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.ifa)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 
         if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
-		print_err(CTD_CFG_WARN, "your multicast interface is IPv4 but "
-					"is binded to an IPv6 interface? "
-					"Surely, this is not what you want");
+		dlog(LOG_WARNING, "your multicast interface is IPv4 but "
+		     "is binded to an IPv6 interface? "
+		     "Surely, this is not what you want");
 		break;
 	}
 
@@ -397,7 +386,7 @@ multicast_option : T_IPV4_IFACE T_IP
 
 multicast_option : T_IPV6_IFACE T_IP
 {
-	print_err(CTD_CFG_WARN, "`IPv6_interface' not required, ignoring");
+	dlog(LOG_WARNING, "`IPv6_interface' not required, ignoring");
 }
 
 multicast_option : T_IFACE T_STRING
@@ -410,7 +399,7 @@ multicast_option : T_IFACE T_STRING
 
 	idx = if_nametoindex($2);
 	if (!idx) {
-		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
+		dlog(LOG_WARNING, "%s is an invalid interface", $2);
 		break;
 	}
 
@@ -422,9 +411,8 @@ multicast_option : T_IFACE T_STRING
 
 multicast_option : T_BACKLOG T_NUMBER
 {
-	print_err(CTD_CFG_WARN, "`Backlog' option inside Multicast clause is "
-				"obsolete. Please, remove it from "
-				"conntrackd.conf");
+	dlog(LOG_WARNING, "`Backlog' option inside Multicast clause is "
+	     "obsolete. Please, remove it from conntrackd.conf");
 };
 
 multicast_option : T_GROUP T_NUMBER
@@ -461,8 +449,8 @@ udp_line : T_UDP '{' udp_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_UDP) {
-		print_err(CTD_CFG_ERROR, "cannot use `UDP' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `UDP' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_UDP;
@@ -475,8 +463,8 @@ udp_line : T_UDP T_DEFAULT '{' udp_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_UDP) {
-		print_err(CTD_CFG_ERROR, "cannot use `UDP' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `UDP' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_UDP;
@@ -495,7 +483,7 @@ udp_option : T_IPV4_ADDR T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.server.ipv4)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
@@ -508,11 +496,11 @@ udp_option : T_IPV6_ADDR T_IP
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
 		      &conf.channel[conf.channel_num].u.udp.server.ipv6) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
@@ -523,7 +511,7 @@ udp_option : T_IPV4_DEST_ADDR T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.client)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
@@ -536,11 +524,11 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
 		      &conf.channel[conf.channel_num].u.udp.client) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
@@ -555,7 +543,7 @@ udp_option : T_IFACE T_STRING
 
 	idx = if_nametoindex($2);
 	if (!idx) {
-		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
+		dlog(LOG_WARNING, "%s is an invalid interface", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.udp.server.ipv6.scope_id = idx;
@@ -595,8 +583,8 @@ tcp_line : T_TCP '{' tcp_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_TCP) {
-		print_err(CTD_CFG_ERROR, "cannot use `TCP' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `TCP' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_TCP;
@@ -611,8 +599,8 @@ tcp_line : T_TCP T_DEFAULT '{' tcp_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_TCP) {
-		print_err(CTD_CFG_ERROR, "cannot use `TCP' with other "
-					 "dedicated link protocols!");
+		dlog(LOG_ERR, "cannot use `TCP' with other "
+		     "dedicated link protocols!");
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_TCP;
@@ -633,7 +621,7 @@ tcp_option : T_IPV4_ADDR T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.server.ipv4)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
@@ -646,11 +634,11 @@ tcp_option : T_IPV6_ADDR T_IP
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
 		      &conf.channel[conf.channel_num].u.tcp.server.ipv6) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
@@ -661,7 +649,7 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 	__max_dedicated_links_reached();
 
 	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.client)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
@@ -674,11 +662,11 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2,
 		      &conf.channel[conf.channel_num].u.tcp.client) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6 address", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
@@ -693,7 +681,7 @@ tcp_option : T_IFACE T_STRING
 
 	idx = if_nametoindex($2);
 	if (!idx) {
-		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
+		dlog(LOG_WARNING, "%s is an invalid interface", $2);
 		break;
 	}
 	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
@@ -767,8 +755,8 @@ ignore_protocol: T_IGNORE_PROTOCOL '{' ignore_proto_list '}'
 			    CT_FILTER_L4PROTO,
 			    CT_FILTER_NEGATIVE);
 
-	print_err(CTD_CFG_WARN, "the clause `IgnoreProtocol' is "
-				"obsolete. Use `Filter' instead");
+	dlog(LOG_WARNING, "the clause `IgnoreProtocol' is "
+	     "obsolete. Use `Filter' instead");
 };
 
 ignore_proto_list:
@@ -780,7 +768,7 @@ ignore_proto: T_NUMBER
 	if ($1 < IPPROTO_MAX)
 		ct_filter_add_proto(STATE(us_filter), $1);
 	else
-		print_err(CTD_CFG_WARN, "protocol number `%d' is freak", $1);
+		dlog(LOG_WARNING, "protocol number `%d' is freak", $1);
 };
 
 ignore_proto: T_STRING
@@ -789,8 +777,8 @@ ignore_proto: T_STRING
 
 	pent = getprotobyname($1);
 	if (pent == NULL) {
-		print_err(CTD_CFG_WARN, "getprotobyname() cannot find "
-					"protocol `%s' in /etc/protocols", $1);
+		dlog(LOG_WARNING, "getprotobyname() cannot find "
+		     "protocol `%s' in /etc/protocols", $1);
 		break;
 	}
 	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
@@ -799,8 +787,8 @@ ignore_proto: T_STRING
 sync: T_SYNC '{' sync_list '}'
 {
 	if (conf.flags & CTD_STATS_MODE) {
-		print_err(CTD_CFG_ERROR, "cannot use both `Stats' and `Sync' "
-					 "clauses in conntrackd.conf");
+		dlog(LOG_ERR, "cannot use both `Stats' and `Sync' "
+		     "clauses in conntrackd.conf");
 		exit(EXIT_FAILURE);
 	}
 	conf.flags |= CTD_SYNC_MODE;
@@ -953,8 +941,8 @@ disable_external_cache: T_DISABLE_EXTERNAL_CACHE T_OFF
 
 resend_buffer_size: T_RESEND_BUFFER_SIZE T_NUMBER
 {
-	print_err(CTD_CFG_WARN, "`ResendBufferSize' is deprecated. "
-				"Use `ResendQueueSize' instead");
+	dlog(LOG_WARNING, "`ResendBufferSize' is deprecated. "
+	     "Use `ResendQueueSize' instead");
 };
 
 resend_queue_size: T_RESEND_QUEUE_SIZE T_NUMBER
@@ -969,24 +957,24 @@ window_size: T_WINDOWSIZE T_NUMBER
 
 destroy_timeout: T_DESTROY_TIMEOUT T_NUMBER
 {
-	print_err(CTD_CFG_WARN, "`DestroyTimeout' is deprecated. Remove it");
+	dlog(LOG_WARNING, "`DestroyTimeout' is deprecated. Remove it");
 };
 
 relax_transitions: T_RELAX_TRANSITIONS
 {
-	print_err(CTD_CFG_WARN, "`RelaxTransitions' clause is obsolete. "
-				"Please, remove it from conntrackd.conf");
+	dlog(LOG_WARNING, "`RelaxTransitions' clause is obsolete. "
+	     "Please, remove it from conntrackd.conf");
 };
 
 delay_destroy_msgs: T_DELAY
 {
-	print_err(CTD_CFG_WARN, "`DelayDestroyMessages' clause is obsolete. "
-				"Please, remove it from conntrackd.conf");
+	dlog(LOG_WARNING, "`DelayDestroyMessages' clause is obsolete. "
+	     "Please, remove it from conntrackd.conf");
 };
 
 listen_to: T_LISTEN_TO T_IP
 {
-	print_err(CTD_CFG_WARN, "the clause `ListenTo' is obsolete, ignoring");
+	dlog(LOG_WARNING, "the clause `ListenTo' is obsolete, ignoring");
 };
 
 state_replication: T_REPLICATE states T_FOR state_proto
@@ -995,8 +983,8 @@ state_replication: T_REPLICATE states T_FOR state_proto
 			    CT_FILTER_STATE,
 			    CT_FILTER_POSITIVE);
 
-	print_err(CTD_CFG_WARN, "the clause `Replicate' is obsolete. "
-				"Use `Filter' instead");
+	dlog(LOG_WARNING, "the clause `Replicate' is obsolete. "
+	     "Use `Filter' instead");
 };
 
 states:
@@ -1005,8 +993,8 @@ states:
 state_proto: T_STRING
 {
 	if (strncmp($1, "TCP", strlen("TCP")) != 0) {
-		print_err(CTD_CFG_WARN, "unsupported protocol `%s' in line %d",
-					$1, yylineno);
+		dlog(LOG_WARNING, "unsupported protocol `%s' in line %d",
+		     $1, yylineno);
 	}
 };
 state: tcp_state;
@@ -1089,14 +1077,12 @@ tcp_state: T_LISTEN
 
 cache_writethrough: T_WRITE_THROUGH T_ON
 {
-	print_err(CTD_CFG_WARN, "`CacheWriteThrough' clause is obsolete, "
-				"ignoring");
+	dlog(LOG_WARNING, "`CacheWriteThrough' clause is obsolete, ignoring");
 };
 
 cache_writethrough: T_WRITE_THROUGH T_OFF
 {
-	print_err(CTD_CFG_WARN, "`CacheWriteThrough' clause is obsolete, "
-				"ignoring");
+	dlog(LOG_WARNING, "`CacheWriteThrough' clause is obsolete, ignoring");
 };
 
 general: T_GENERAL '{' general_list '}';
@@ -1182,7 +1168,7 @@ scheduler_line : T_TYPE T_STRING
 	} else if (strcasecmp($2, "fifo") == 0) {
 		conf.sched.type = SCHED_FIFO;
 	} else {
-		print_err(CTD_CFG_ERROR, "unknown scheduler `%s'", $2);
+		dlog(LOG_ERR, "unknown scheduler `%s'", $2);
 		exit(EXIT_FAILURE);
 	}
 };
@@ -1191,14 +1177,14 @@ scheduler_line : T_PRIO T_NUMBER
 {
 	conf.sched.prio = $2;
 	if (conf.sched.prio < 0 || conf.sched.prio > 99) {
-		print_err(CTD_CFG_ERROR, "`Priority' must be [0, 99]\n", $2);
+		dlog(LOG_ERR, "`Priority' must be [0, 99]\n", $2);
 		exit(EXIT_FAILURE);
 	}
 };
 
 family : T_FAMILY T_STRING
 {
-	print_err(CTD_CFG_WARN, "`Family' is deprecated, ignoring");
+	dlog(LOG_WARNING, "`Family' is deprecated, ignoring");
 };
 
 event_iterations_limit : T_EVENT_ITER_LIMIT T_NUMBER
@@ -1211,7 +1197,7 @@ poll_secs: T_POLL_SECS T_NUMBER
 	conf.flags |= CTD_POLL;
 	conf.poll_kernel_secs = $2;
 	if (conf.poll_kernel_secs == 0) {
-		print_err(CTD_CFG_ERROR, "`PollSecs' clause must be > 0");
+		dlog(LOG_ERR, "`PollSecs' clause must be > 0");
 		exit(EXIT_FAILURE);
 	}
 };
@@ -1265,8 +1251,8 @@ filter_protocol_item : T_STRING
 
 	pent = getprotobyname($1);
 	if (pent == NULL) {
-		print_err(CTD_CFG_WARN, "getprotobyname() cannot find "
-					"protocol `%s' in /etc/protocols", $1);
+		dlog(LOG_WARNING, "getprotobyname() cannot find "
+		     "protocol `%s' in /etc/protocols", $1);
 		break;
 	}
 	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
@@ -1284,8 +1270,8 @@ filter_protocol_item : T_TCP
 
 	pent = getprotobyname("tcp");
 	if (pent == NULL) {
-		print_err(CTD_CFG_WARN, "getprotobyname() cannot find "
-					"protocol `tcp' in /etc/protocols");
+		dlog(LOG_WARNING, "getprotobyname() cannot find "
+		     "protocol `tcp' in /etc/protocols");
 		break;
 	}
 	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
@@ -1303,7 +1289,7 @@ filter_protocol_item : T_UDP
 
 	pent = getprotobyname("udp");
 	if (pent == NULL) {
-		print_err(CTD_CFG_WARN, "getprotobyname() cannot find "
+		dlog(LOG_WARNING, "getprotobyname() cannot find "
 					"protocol `udp' in /etc/protocols");
 		break;
 	}
@@ -1363,14 +1349,14 @@ filter_address_item : T_IPV4_ADDR T_IP
 		*slash = '\0';
 		cidr = atoi(slash+1);
 		if (cidr > 32) {
-			print_err(CTD_CFG_WARN, "%s/%d is not a valid network, "
-						"ignoring", $2, cidr);
+			dlog(LOG_WARNING, "%s/%d is not a valid network, "
+			     "ignoring", $2, cidr);
 			break;
 		}
 	}
 
 	if (!inet_aton($2, &ip.ipv4)) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv4, ignoring", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
 		break;
 	}
 
@@ -1383,18 +1369,17 @@ filter_address_item : T_IPV4_ADDR T_IP
 
 		if (!ct_filter_add_netmask(STATE(us_filter), &tmp, AF_INET)) {
 			if (errno == EEXIST)
-				print_err(CTD_CFG_WARN, "netmask %s is "
-							"repeated in the "
-							"ignore pool", $2);
+				dlog(LOG_WARNING, "netmask %s is "
+				     "repeated in the ignore pool", $2);
 		}
 	} else {
 		if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET)) {
 			if (errno == EEXIST)
-				print_err(CTD_CFG_WARN, "IP %s is repeated in "
-							"the ignore pool", $2);
+				dlog(LOG_WARNING, "IP %s is repeated in "
+				     "the ignore pool", $2);
 			if (errno == ENOSPC)
-				print_err(CTD_CFG_WARN, "too many IP in the "
-							"ignore pool!");
+				dlog(LOG_WARNING, "too many IP in the "
+				     "ignore pool!");
 		}
 	}
 	__kernel_filter_start();
@@ -1423,19 +1408,19 @@ filter_address_item : T_IPV6_ADDR T_IP
 		*slash = '\0';
 		cidr = atoi(slash+1);
 		if (cidr > 128) {
-			print_err(CTD_CFG_WARN, "%s/%d is not a valid network, "
-						"ignoring", $2, cidr);
+			dlog(LOG_WARNING, "%s/%d is not a valid network, "
+			     "ignoring", $2, cidr);
 			break;
 		}
 	}
 
 #ifdef HAVE_INET_PTON_IPV6
 	if (inet_pton(AF_INET6, $2, &ip.ipv6) <= 0) {
-		print_err(CTD_CFG_WARN, "%s is not a valid IPv6, ignoring", $2);
+		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
 		break;
 	}
 #else
-	print_err(CTD_CFG_WARN, "cannot find inet_pton(), IPv6 unsupported!");
+	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
 	break;
 #endif
 	if (slash && cidr < 128) {
@@ -1445,18 +1430,17 @@ filter_address_item : T_IPV6_ADDR T_IP
 		ipv6_cidr2mask_net(cidr, tmp.mask);
 		if (!ct_filter_add_netmask(STATE(us_filter), &tmp, AF_INET6)) {
 			if (errno == EEXIST)
-				print_err(CTD_CFG_WARN, "netmask %s is "
-							"repeated in the "
-							"ignore pool", $2);
+				dlog(LOG_WARNING, "netmask %s is "
+				     "repeated in the ignore pool", $2);
 		}
 	} else {
 		if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET6)) {
 			if (errno == EEXIST)
-				print_err(CTD_CFG_WARN, "IP %s is repeated in "
-							"the ignore pool", $2);
+				dlog(LOG_WARNING, "IP %s is repeated in "
+				     "the ignore pool", $2);
 			if (errno == ENOSPC)
-				print_err(CTD_CFG_WARN, "too many IP in the "
-							"ignore pool!");
+				dlog(LOG_WARNING, "too many IP in the "
+				     "ignore pool!");
 		}
 	}
 	__kernel_filter_start();
@@ -1500,8 +1484,8 @@ filter_state_item : tcp_states T_FOR T_TCP;
 stats: T_STATS '{' stats_list '}'
 {
 	if (conf.flags & CTD_SYNC_MODE) {
-		print_err(CTD_CFG_ERROR, "cannot use both `Stats' and `Sync' "
-					 "clauses in conntrackd.conf");
+		dlog(LOG_ERR, "cannot use both `Stats' and `Sync' "
+		     "clauses in conntrackd.conf");
 		exit(EXIT_FAILURE);
 	}
 	conf.flags |= CTD_STATS_MODE;
@@ -1563,20 +1547,20 @@ stat_syslog_facility : T_SYSLOG T_STRING
 	else if (!strcmp($2, "local7"))
 		conf.stats.syslog_facility = LOG_LOCAL7;
 	else {
-		print_err(CTD_CFG_WARN, "'%s' is not a known syslog facility, "
-					"ignoring.", $2);
+		dlog(LOG_WARNING, "'%s' is not a known syslog facility, "
+		     "ignoring.", $2);
 		break;
 	}
 
 	if (conf.syslog_facility != -1 &&
 	    conf.stats.syslog_facility != conf.syslog_facility)
-		print_err(CTD_CFG_WARN, "conflicting Syslog facility "
-					"values, defaulting to General");
+		dlog(LOG_WARNING, "conflicting Syslog facility "
+		     "values, defaulting to General");
 };
 
 buffer_size: T_STAT_BUFFER_SIZE T_NUMBER
 {
-	print_err(CTD_CFG_WARN, "`LogFileBufferSize' is deprecated");
+	dlog(LOG_WARNING, "`LogFileBufferSize' is deprecated");
 };
 
 helper: T_HELPER '{' helper_list '}'
@@ -1604,7 +1588,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	else if (strcmp($3, "inet6") == 0)
 		l3proto = AF_INET6;
 	else {
-		print_err(CTD_CFG_ERROR, "unknown layer 3 protocol");
+		dlog(LOG_ERR, "unknown layer 3 protocol");
 		exit(EXIT_FAILURE);
 	}
 
@@ -1613,19 +1597,18 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	else if (strcmp($4, "udp") == 0)
 		l4proto = IPPROTO_UDP;
 	else {
-		print_err(CTD_CFG_ERROR, "unknown layer 4 protocol");
+		dlog(LOG_ERR, "unknown layer 4 protocol");
 		exit(EXIT_FAILURE);
 	}
 
 #ifdef BUILD_CTHELPER
 	helper = helper_find(CONNTRACKD_LIB_DIR, $2, l4proto, RTLD_NOW);
 	if (helper == NULL) {
-		print_err(CTD_CFG_ERROR, "Unknown `%s' helper", $2);
+		dlog(LOG_ERR, "Unknown `%s' helper", $2);
 		exit(EXIT_FAILURE);
 	}
 #else
-	print_err(CTD_CFG_ERROR, "Helper support is disabled, recompile "
-				 "conntrackd");
+	dlog(LOG_ERR, "Helper support is disabled, recompile conntrackd");
 	exit(EXIT_FAILURE);
 #endif
 
@@ -1669,9 +1652,8 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 				break;
 			}
 			if (matching == NULL) {
-				print_err(CTD_CFG_ERROR,
-					  "Unknown policy `%s' in helper "
-					  "configuration", pol->name);
+				dlog(LOG_ERR, "Unknown policy `%s' in helper "
+				     "configuration", pol->name);
 				exit(EXIT_FAILURE);
 			}
 			/* FIXME: First set default policy, then change only
@@ -1684,9 +1666,9 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 			break;
 		}
 		default:
-			print_err(CTD_CFG_ERROR,
-				  "Unexpected symbol parsing helper policy");
-				exit(EXIT_FAILURE);
+			dlog(LOG_ERR, "Unexpected symbol parsing helper "
+			     "policy");
+			exit(EXIT_FAILURE);
 			break;
 		}
 	}
@@ -1729,9 +1711,8 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 
 	e = stack_item_pop(&symbol_stack, SYMBOL_HELPER_EXPECT_POLICY_LEAF);
 	if (e == NULL) {
-		print_err(CTD_CFG_ERROR,
-			  "Helper policy configuration empty, fix your "
-			  "configuration file, please");
+		dlog(LOG_ERR, "Helper policy configuration empty, fix your "
+		     "configuration file, please");
 		exit(EXIT_FAILURE);
 		break;
 	}
@@ -1787,38 +1768,17 @@ helper_policy_expect_timeout: T_HELPER_EXPECT_TIMEOUT T_NUMBER
 int __attribute__((noreturn))
 yyerror(char *msg)
 {
-	print_err(CTD_CFG_ERROR, "parsing config file in "
-				 "line (%d), symbol '%s': %s",
-				 yylineno, yytext, msg);
+	dlog(LOG_ERR, "parsing config file in line (%d), symbol '%s': %s",
+	     yylineno, yytext, msg);
 	exit(EXIT_FAILURE);
 }
 
-static void print_err(int type, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	switch(type) {
-	case CTD_CFG_ERROR:
-		fprintf(stderr, "ERROR: ");
-		break;
-	case CTD_CFG_WARN:
-		fprintf(stderr, "WARNING: ");
-		break;
-	default:
-		fprintf(stderr, "?: ");
-	}
-	vfprintf(stderr, msg, args);
-	va_end(args);
-	fprintf(stderr,"\n");
-}
-
 static void __kernel_filter_start(void)
 {
 	if (!STATE(filter)) {
 		STATE(filter) = nfct_filter_create();
 		if (!STATE(filter)) {
-			print_err(CTD_CFG_ERROR, "cannot create ignore pool!");
+			dlog(LOG_ERR, "cannot create ignore pool!");
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -1840,9 +1800,8 @@ static void __kernel_filter_add_state(int value)
 static void __max_dedicated_links_reached(void)
 {
 	if (conf.channel_num >= MULTICHANNEL_MAX) {
-		print_err(CTD_CFG_ERROR, "too many dedicated links in "
-					 "the configuration file "
-					 "(Maximum: %d)", MULTICHANNEL_MAX);
+		dlog(LOG_ERR, "too many dedicated links in the configuration "
+		     "file (Maximum: %d)", MULTICHANNEL_MAX);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -1872,9 +1831,9 @@ init_config(char *filename)
 
 #ifndef BUILD_SYSTEMD
 	if (CONFIG(systemd) == 1) {
-		print_err(CTD_CFG_WARN, "systemd runtime support activated but"
-					" conntrackd was built without support"
-					" for it. Recompile conntrackd");
+		dlog(LOG_WARNING, "systemd runtime support activated but "
+		     "conntrackd was built without support "
+		     "for it. Recompile conntrackd");
 	}
 #endif /* BUILD_SYSTEMD */
 

