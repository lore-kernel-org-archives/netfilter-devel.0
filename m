From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH conntrack-tools] ipv6: remove use of HAVE_INET_PTON_IPV6
Date: Mon, 29 May 2017 17:44:15 +0200
Message-ID: <1496072655-26752-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: nicolas.dichtel@6wind.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:52309 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbdE2PyM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 11:54:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The goal of this patch is to fix the ipv6 support when conntrackd is
cross-compiled. The AC_RUN_IFELSE macro must be avoided as much as possible.
See section 6.6 of the gnu autoconf:
"If you really need to test for a runtime behavior while configuring, you can
 write a test program to determine the result, and compile and run it using
 AC_RUN_IFELSE. Avoid running test programs if possible, because this prevents
 people from configuring your package for cross-compiling."

Let's remove this check and test the returned error to handle the case where
ipv6 is not supported (inet_pton() returns -1 when the family is not supported).

Reported-by: Zhenlin Zhang <zhenlin.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 configure.ac         | 28 -----------------
 src/conntrack.c      |  2 --
 src/read_config_yy.y | 87 +++++++++++++++++++++++++++-------------------------
 3 files changed, 46 insertions(+), 71 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6141220c0e6a..ba330ee181f8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -81,34 +81,6 @@ dnl AC_CHECK_LIB([c], [main])
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl check for inet_pton
 AC_CHECK_FUNCS(inet_pton)
-dnl Some systems have it, but not IPv6
-if test "$ac_cv_func_inet_pton" = "yes" ; then
-AC_MSG_CHECKING(if inet_pton supports IPv6)
-AC_RUN_IFELSE([AC_LANG_SOURCE([[
-#ifdef HAVE_SYS_TYPES_H
-#include <sys/types.h>
-#endif
-#ifdef HAVE_SYS_SOCKET_H
-#include <sys/socket.h>
-#endif
-#ifdef HAVE_NETINET_IN_H
-#include <netinet/in.h>
-#endif
-#ifdef HAVE_ARPA_INET_H
-#include <arpa/inet.h>
-#endif
-int main()
-  {
-     struct in6_addr addr6;
-     if (inet_pton(AF_INET6, "::1", &addr6) < 1)
-        exit(1);
-     else
-        exit(0);
-  }
-  ]])],[ AC_MSG_RESULT(yes)
-       AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
-  ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
-fi
 
 # Checks for header files.
 dnl AC_HEADER_STDC
diff --git a/src/conntrack.c b/src/conntrack.c
index 57dbed777489..8d19cca78341 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1057,10 +1057,8 @@ parse_inetaddr(const char *cp, struct addr_parse *parse)
 {
 	if (inet_aton(cp, &parse->addr))
 		return AF_INET;
-#ifdef HAVE_INET_PTON_IPV6
 	else if (inet_pton(AF_INET6, cp, &parse->addr6) > 0)
 		return AF_INET6;
-#endif
 	return AF_UNSPEC;
 }
 
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 3bb7c5f90017..e4fd277a47ea 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -240,17 +240,17 @@ multicast_option : T_IPV4_ADDR T_IP
 multicast_option : T_IPV6_ADDR T_IP
 {
 	__max_dedicated_links_reached();
+	int err;
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.mcast.in) <= 0) {
+	err = inet_pton(AF_INET6, $2,
+			&conf.channel[conf.channel_num].u.mcast.in);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
+	} else if (err < 0) {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
 
 	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET) {
 		dlog(LOG_WARNING, "your multicast address is IPv6 but "
@@ -397,17 +397,18 @@ udp_option : T_IPV4_ADDR T_IP
 udp_option : T_IPV6_ADDR T_IP
 {
 	__max_dedicated_links_reached();
+	int err;
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.udp.server.ipv6) <= 0) {
+	err = inet_pton(AF_INET6, $2,
+			&conf.channel[conf.channel_num].u.udp.server.ipv6);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
+	} else if (err < 0) {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
+
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
 };
 
@@ -425,17 +426,18 @@ udp_option : T_IPV4_DEST_ADDR T_IP
 udp_option : T_IPV6_DEST_ADDR T_IP
 {
 	__max_dedicated_links_reached();
+	int err;
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.udp.client) <= 0) {
+	err = inet_pton(AF_INET6, $2,
+			&conf.channel[conf.channel_num].u.udp.client);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
+	} else {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
+
 	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
 };
 
@@ -535,17 +537,18 @@ tcp_option : T_IPV4_ADDR T_IP
 tcp_option : T_IPV6_ADDR T_IP
 {
 	__max_dedicated_links_reached();
+	int err;
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.tcp.server.ipv6) <= 0) {
+	err = inet_pton(AF_INET6, $2,
+			&conf.channel[conf.channel_num].u.tcp.server.ipv6);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
+	} else if (err < 0) {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
+
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -563,17 +566,18 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 tcp_option : T_IPV6_DEST_ADDR T_IP
 {
 	__max_dedicated_links_reached();
+	int err;
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2,
-		      &conf.channel[conf.channel_num].u.tcp.client) <= 0) {
+	err = inet_pton(AF_INET6, $2,
+			&conf.channel[conf.channel_num].u.tcp.client);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		break;
+	} else if (err < 0) {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
+
 	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
 };
 
@@ -1206,6 +1210,7 @@ filter_address_item : T_IPV6_ADDR T_IP
 	char *slash;
 	int cidr = 128;
 	struct nfct_filter_ipv6 filter_ipv6;
+	int err;
 
 	memset(&ip, 0, sizeof(union inet_address));
 
@@ -1220,15 +1225,15 @@ filter_address_item : T_IPV6_ADDR T_IP
 		}
 	}
 
-#ifdef HAVE_INET_PTON_IPV6
-	if (inet_pton(AF_INET6, $2, &ip.ipv6) <= 0) {
+	err = inet_pton(AF_INET6, $2, &ip.ipv6);
+	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6, ignoring", $2);
 		break;
+	} else if (err < 0) {
+		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
+		break;
 	}
-#else
-	dlog(LOG_WARNING, "cannot find inet_pton(), IPv6 unsupported!");
-	break;
-#endif
+
 	if (slash && cidr < 128) {
 		struct ct_filter_netmask_ipv6 tmp;
 
-- 
2.8.1

