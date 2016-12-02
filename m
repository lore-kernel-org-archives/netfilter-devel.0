From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH] config: drop old/obsolete/deprecated
 conntrackd.conf config options
Date: Fri, 02 Dec 2016 12:24:39 +0100
Message-ID: <148067787905.31366.6882929818938291343.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47607 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754048AbcLBLYt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 06:24:49 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1371851F358
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 11:24:47 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WHxzjtiTSzPI for <netfilter-devel@vger.kernel.org>;
        Fri,  2 Dec 2016 12:24:40 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 6E25E51F2A1
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 12:24:40 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There has been a long adaptation time already, with several conntrack-tools
releases in the meantime.

Users migrating from an old conntrackd to a current one are required
to update their config file.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/read_config_lex.l |   14 ---
 src/read_config_yy.y  |  207 ++-----------------------------------------------
 2 files changed, 9 insertions(+), 212 deletions(-)

diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 5f2de7d..0282534 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -71,12 +71,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "RefreshTime"			{ return T_REFRESH; }
 "CacheTimeout"			{ return T_EXPIRE; }
 "CommitTimeout"			{ return T_TIMEOUT; }
-"DelayDestroyMessages"		{ return T_DELAY; }
 "HashLimit"			{ return T_HASHLIMIT; }
 "Path"				{ return T_PATH; }
-"IgnoreProtocol"		{ return T_IGNORE_PROTOCOL; }
-"IgnoreTrafficFor"		{ return T_IGNORE_TRAFFIC; }
-"StripNAT"			{ return T_STRIP_NAT; }
 "Backlog"			{ return T_BACKLOG; }
 "Group"				{ return T_GROUP; }
 "Port"				{ return T_PORT; }
@@ -86,22 +82,16 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "General"			{ return T_GENERAL; }
 "Sync"				{ return T_SYNC; }
 "Stats"				{ return T_STATS; }
-"RelaxTransitions"		{ return T_RELAX_TRANSITIONS; }
 "SocketBufferSize"		{ return T_BUFFER_SIZE; /* alias */ }
 "SocketBufferSizeMaxGrown"	{ return T_BUFFER_SIZE_MAX_GROWN; /* alias */ }
 "SocketBufferSizeMaxGrowth"	{ return T_BUFFER_SIZE_MAX_GROWN; /* alias */ }
 "NetlinkBufferSize"		{ return T_BUFFER_SIZE; }
 "NetlinkBufferSizeMaxGrowth"	{ return T_BUFFER_SIZE_MAX_GROWN; }
 "Mode"				{ return T_SYNC_MODE; }
-"ListenTo"			{ return T_LISTEN_TO; }
-"Family"			{ return T_FAMILY; }
-"ResendBufferSize"		{ return T_RESEND_BUFFER_SIZE; }
 "ResendQueueSize"		{ return T_RESEND_QUEUE_SIZE; }
 "Checksum"			{ return T_CHECKSUM; }
 "ACKWindowSize"			{ return T_WINDOWSIZE; }
-"Replicate"			{ return T_REPLICATE; }
 "for"				{ return T_FOR; }
-"CacheWriteThrough"		{ return T_WRITE_THROUGH; }
 "SYN_SENT"			{ return T_SYN_SENT; }
 "SYN_RECV"			{ return T_SYN_RECV; }
 "ESTABLISHED"			{ return T_ESTABLISHED; }
@@ -112,10 +102,6 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "CLOSE"				{ return T_CLOSE; /* alias of CLOSED */ }
 "CLOSED"			{ return T_CLOSE; }
 "LISTEN"			{ return T_LISTEN; }
-"LogFileBufferSize"		{ return T_STAT_BUFFER_SIZE; }
-"DestroyTimeout"		{ return T_DESTROY_TIMEOUT; }
-"McastSndSocketBuffer"		{ return T_SNDBUFF; /* deprecated */ }
-"McastRcvSocketBuffer"		{ return T_RCVBUFF; /* deprecated */ }
 "SndSocketBuffer"		{ return T_SNDBUFF; }
 "RcvSocketBuffer"		{ return T_RCVBUFF; }
 "Filter"			{ return T_FILTER; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index bfe7abb..97f905d 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -62,18 +62,18 @@ enum {
 
 %token T_IPV4_ADDR T_IPV4_IFACE T_PORT T_HASHSIZE T_HASHLIMIT T_MULTICAST
 %token T_PATH T_UNIX T_REFRESH T_IPV6_ADDR T_IPV6_IFACE
-%token T_IGNORE_UDP T_IGNORE_ICMP T_IGNORE_TRAFFIC T_BACKLOG T_GROUP
-%token T_LOG T_UDP T_ICMP T_IGMP T_VRRP T_TCP T_IGNORE_PROTOCOL
-%token T_LOCK T_STRIP_NAT T_BUFFER_SIZE_MAX_GROWN T_EXPIRE T_TIMEOUT
-%token T_GENERAL T_SYNC T_STATS T_RELAX_TRANSITIONS T_BUFFER_SIZE T_DELAY
-%token T_SYNC_MODE T_LISTEN_TO T_FAMILY T_RESEND_BUFFER_SIZE
+%token T_BACKLOG T_GROUP T_IGNORE
+%token T_LOG T_UDP T_ICMP T_IGMP T_VRRP T_TCP
+%token T_LOCK T_BUFFER_SIZE_MAX_GROWN T_EXPIRE T_TIMEOUT
+%token T_GENERAL T_SYNC T_STATS T_BUFFER_SIZE
+%token T_SYNC_MODE
 %token T_ALARM T_FTFW T_CHECKSUM T_WINDOWSIZE T_ON T_OFF
-%token T_REPLICATE T_FOR T_IFACE T_PURGE T_RESEND_QUEUE_SIZE
+%token T_FOR T_IFACE T_PURGE T_RESEND_QUEUE_SIZE
 %token T_ESTABLISHED T_SYN_SENT T_SYN_RECV T_FIN_WAIT 
 %token T_CLOSE_WAIT T_LAST_ACK T_TIME_WAIT T_CLOSE T_LISTEN
-%token T_SYSLOG T_WRITE_THROUGH T_STAT_BUFFER_SIZE T_DESTROY_TIMEOUT
+%token T_SYSLOG
 %token T_RCVBUFF T_SNDBUFF T_NOTRACK T_POLL_SECS
-%token T_FILTER T_ADDRESS T_PROTOCOL T_STATE T_ACCEPT T_IGNORE
+%token T_FILTER T_ADDRESS T_PROTOCOL T_STATE T_ACCEPT
 %token T_FROM T_USERSPACE T_KERNELSPACE T_EVENT_ITER_LIMIT T_DEFAULT
 %token T_NETLINK_OVERRUN_RESYNC T_NICE T_IPV4_DEST_ADDR T_IPV6_DEST_ADDR
 %token T_SCHEDULER T_TYPE T_PRIO T_NETLINK_EVENTS_RELIABLE
@@ -98,10 +98,7 @@ lines : line
       | lines line
       ;
 
-line : ignore_protocol
-     | ignore_traffic
-     | strip_nat
-     | general
+line : general
      | sync
      | stats
      | helper
@@ -168,11 +165,6 @@ lock : T_LOCK T_PATH_VAL
 	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
 };
 
-strip_nat: T_STRIP_NAT
-{
-	dlog(LOG_WARNING, "`StripNAT' clause is obsolete, ignoring");
-};
-
 refreshtime : T_REFRESH T_NUMBER
 {
 	conf.refresh = $2;
@@ -215,65 +207,6 @@ checksum: T_CHECKSUM T_OFF
 	conf.channel[0].u.mcast.checksum = 1;
 };
 
-ignore_traffic : T_IGNORE_TRAFFIC '{' ignore_traffic_options '}'
-{
-	ct_filter_set_logic(STATE(us_filter),
-			    CT_FILTER_ADDRESS,
-			    CT_FILTER_NEGATIVE);
-
-	dlog(LOG_WARNING, "the clause `IgnoreTrafficFor' is obsolete. "
-	     "Use `Filter' instead");
-};
-
-ignore_traffic_options :
-		       | ignore_traffic_options ignore_traffic_option;
-
-ignore_traffic_option : T_IPV4_ADDR T_IP
-{
-	union inet_address ip;
-
-	memset(&ip, 0, sizeof(union inet_address));
-
-	if (!inet_aton($2, &ip.ipv4)) {
-		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
-		break;
-	}
-
-	if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET)) {
-		if (errno == EEXIST)
-			dlog(LOG_WARNING, "IP %s is repeated "
-			     "in the ignore pool", $2);
-		if (errno == ENOSPC)
-			dlog(LOG_WARNING, "too many IP in the "
-			     "ignore pool!");
-	}
-};
-
-ignore_traffic_option : T_IPV6_ADDR T_IP
-{
-	union inet_address ip;
-
-	memset(&ip, 0, sizeof(union inet_address));
-
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2, &ip.ipv6) <= 0) {
-		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
-		break;
-	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-#endif
-
-	if (!ct_filter_add_ip(STATE(us_filter), &ip, AF_INET6)) {
-		if (errno == EEXIST)
-			dlog(LOG_WARNING, "IP %s is repeated "
-			     "in the ignore pool", $2);
-		if (errno == ENOSPC)
-			dlog(LOG_WARNING, "too many IP in the ignore pool!");
-	}
-
-};
-
 multicast_line : T_MULTICAST '{' multicast_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
@@ -409,12 +342,6 @@ multicast_option : T_IFACE T_STRING
 	}
 };
 
-multicast_option : T_BACKLOG T_NUMBER
-{
-	dlog(LOG_WARNING, "`Backlog' option inside Multicast clause is "
-	     "obsolete. Please, remove it from conntrackd.conf");
-};
-
 multicast_option : T_GROUP T_NUMBER
 {
 	__max_dedicated_links_reached();
@@ -749,41 +676,6 @@ unix_option : T_BACKLOG T_NUMBER
 	conf.local.backlog = $2;
 };
 
-ignore_protocol: T_IGNORE_PROTOCOL '{' ignore_proto_list '}'
-{
-	ct_filter_set_logic(STATE(us_filter),
-			    CT_FILTER_L4PROTO,
-			    CT_FILTER_NEGATIVE);
-
-	dlog(LOG_WARNING, "the clause `IgnoreProtocol' is "
-	     "obsolete. Use `Filter' instead");
-};
-
-ignore_proto_list:
-		 | ignore_proto_list ignore_proto
-		 ;
-
-ignore_proto: T_NUMBER
-{
-	if ($1 < IPPROTO_MAX)
-		ct_filter_add_proto(STATE(us_filter), $1);
-	else
-		dlog(LOG_WARNING, "protocol number `%d' is freak", $1);
-};
-
-ignore_proto: T_STRING
-{
-	struct protoent *pent;
-
-	pent = getprotobyname($1);
-	if (pent == NULL) {
-		dlog(LOG_WARNING, "getprotobyname() cannot find "
-		     "protocol `%s' in /etc/protocols", $1);
-		break;
-	}
-	ct_filter_add_proto(STATE(us_filter), pent->p_proto);
-};
-
 sync: T_SYNC '{' sync_list '}'
 {
 	if (conf.flags & CTD_STATS_MODE) {
@@ -805,15 +697,9 @@ sync_line: refreshtime
 	 | multicast_line
 	 | udp_line
 	 | tcp_line
-	 | relax_transitions
-	 | delay_destroy_msgs
 	 | sync_mode_alarm
 	 | sync_mode_ftfw
 	 | sync_mode_notrack
-	 | listen_to
-	 | state_replication
-	 | cache_writethrough
-	 | destroy_timeout
 	 | option_line
 	 ;
 
@@ -895,15 +781,12 @@ sync_mode_alarm_line: refreshtime
               		 | expiretime
 	     		 | timeout
 			 | purge
-			 | relax_transitions
-			 | delay_destroy_msgs
 			 ;
 
 sync_mode_ftfw_list:
 	      | sync_mode_ftfw_list sync_mode_ftfw_line;
 
 sync_mode_ftfw_line: resend_queue_size
-		   | resend_buffer_size
 		   | timeout
 		   | purge
 		   | window_size
@@ -939,12 +822,6 @@ disable_external_cache: T_DISABLE_EXTERNAL_CACHE T_OFF
 	conf.sync.external_cache_disable = 0;
 };
 
-resend_buffer_size: T_RESEND_BUFFER_SIZE T_NUMBER
-{
-	dlog(LOG_WARNING, "`ResendBufferSize' is deprecated. "
-	     "Use `ResendQueueSize' instead");
-};
-
 resend_queue_size: T_RESEND_QUEUE_SIZE T_NUMBER
 {
 	conf.resend_queue_size = $2;
@@ -955,50 +832,6 @@ window_size: T_WINDOWSIZE T_NUMBER
 	conf.window_size = $2;
 };
 
-destroy_timeout: T_DESTROY_TIMEOUT T_NUMBER
-{
-	dlog(LOG_WARNING, "`DestroyTimeout' is deprecated. Remove it");
-};
-
-relax_transitions: T_RELAX_TRANSITIONS
-{
-	dlog(LOG_WARNING, "`RelaxTransitions' clause is obsolete. "
-	     "Please, remove it from conntrackd.conf");
-};
-
-delay_destroy_msgs: T_DELAY
-{
-	dlog(LOG_WARNING, "`DelayDestroyMessages' clause is obsolete. "
-	     "Please, remove it from conntrackd.conf");
-};
-
-listen_to: T_LISTEN_TO T_IP
-{
-	dlog(LOG_WARNING, "the clause `ListenTo' is obsolete, ignoring");
-};
-
-state_replication: T_REPLICATE states T_FOR state_proto
-{
-	ct_filter_set_logic(STATE(us_filter),
-			    CT_FILTER_STATE,
-			    CT_FILTER_POSITIVE);
-
-	dlog(LOG_WARNING, "the clause `Replicate' is obsolete. "
-	     "Use `Filter' instead");
-};
-
-states:
-      | states state;
-
-state_proto: T_STRING
-{
-	if (strncmp($1, "TCP", strlen("TCP")) != 0) {
-		dlog(LOG_WARNING, "unsupported protocol `%s' in line %d",
-		     $1, yylineno);
-	}
-};
-state: tcp_state;
-
 tcp_states:
 	  | tcp_states tcp_state;
 
@@ -1075,16 +908,6 @@ tcp_state: T_LISTEN
 	__kernel_filter_add_state(TCP_CONNTRACK_LISTEN);
 };
 
-cache_writethrough: T_WRITE_THROUGH T_ON
-{
-	dlog(LOG_WARNING, "`CacheWriteThrough' clause is obsolete, ignoring");
-};
-
-cache_writethrough: T_WRITE_THROUGH T_OFF
-{
-	dlog(LOG_WARNING, "`CacheWriteThrough' clause is obsolete, ignoring");
-};
-
 general: T_GENERAL '{' general_list '}';
 
 general_list:
@@ -1101,7 +924,6 @@ general_line: hashsize
 	    | unix_line
 	    | netlink_buffer_size
 	    | netlink_buffer_size_max_grown
-	    | family
 	    | event_iterations_limit
 	    | poll_secs
 	    | filter
@@ -1182,11 +1004,6 @@ scheduler_line : T_PRIO T_NUMBER
 	}
 };
 
-family : T_FAMILY T_STRING
-{
-	dlog(LOG_WARNING, "`Family' is deprecated, ignoring");
-};
-
 event_iterations_limit : T_EVENT_ITER_LIMIT T_NUMBER
 {
 	CONFIG(event_iterations_limit) = $2;
@@ -1499,7 +1316,6 @@ stat_line: stat_logfile_bool
 	 | stat_logfile_path
 	 | stat_syslog_bool
 	 | stat_syslog_facility
-	 | buffer_size
 	 ;
 
 stat_logfile_bool : T_LOG T_ON
@@ -1558,11 +1374,6 @@ stat_syslog_facility : T_SYSLOG T_STRING
 		     "values, defaulting to General");
 };
 
-buffer_size: T_STAT_BUFFER_SIZE T_NUMBER
-{
-	dlog(LOG_WARNING, "`LogFileBufferSize' is deprecated");
-};
-
 helper: T_HELPER '{' helper_list '}'
 {
 	conf.flags |= CTD_HELPER;

