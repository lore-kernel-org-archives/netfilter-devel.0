From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] Provide family and protocol to make getaddrinfo happy
Date: Wed, 25 May 2011 14:16:26 +0200
Message-ID: <1306325786-16849-2-git-send-email-ljaenicke@innominate.com>
References: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:51274 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1EYMQj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 08:16:39 -0400
In-Reply-To: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

getaddrinfo() will fail for numeric port numbers if neither
the socket type (stream/datagram) nor the protocol is
provided.
Since matches on ports only make sense if the protocol is known
we "just" have to derive the protocol number from the information
already collected.

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 xtoptions.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index ac0601f..e38b7ef 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -556,12 +556,15 @@ static void xtopt_parse_host(struct xt_option_call *cb)
  * Resolve a port name to a number. Returns the port number in integral
  * form on success, or <0 on error. (errno will not be set.)
  */
-static int xtables_getportbyname(const char *name)
+static int xtables_getportbyname(const char *name, int family, int protocol)
 {
-	struct addrinfo *res = NULL, *p;
+	struct addrinfo hints, *res = NULL, *p;
 	int ret;
 
-	ret = getaddrinfo(NULL, name, NULL, &res);
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = family;
+	hints.ai_protocol = protocol;
+	ret = getaddrinfo(NULL, name, &hints, &res);
 	if (ret < 0)
 		return -1;
 	ret = -1;
@@ -598,9 +601,19 @@ static void xtopt_parse_protocol(struct xt_option_call *cb)
 static void xtopt_parse_port(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
+	struct ipt_entry *fw = cb->xt_entry;
+	struct ip6t_entry *fw6 = cb->xt_entry;
+	int family, protocol;
 	int ret;
 
-	ret = xtables_getportbyname(cb->arg);
+	if (afinfo->family == NFPROTO_IPV4) {
+		family = AF_INET;
+		protocol = fw->ip.proto;
+	} else {
+		family = AF_INET6;
+		protocol = fw6->ipv6.proto;
+	}
+	ret = xtables_getportbyname(cb->arg, family, protocol);
 	if (ret < 0)
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"Port \"%s\" does not resolve to anything.\n",
@@ -616,10 +629,21 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 {
 	static const size_t esize = sizeof(uint16_t);
 	const struct xt_option_entry *entry = cb->entry;
+	struct ipt_entry *fw = cb->xt_entry;
+	struct ip6t_entry *fw6 = cb->xt_entry;
 	char *lo_arg, *wp_arg, *arg;
 	unsigned int maxiter;
+	int family, protocol;
 	int value;
 
+	if (afinfo->family == NFPROTO_IPV4) {
+		family = AF_INET;
+		protocol = fw->ip.proto;
+	} else {
+		family = AF_INET6;
+		protocol = fw6->ipv6.proto;
+	}
+
 	wp_arg = lo_arg = strdup(cb->arg);
 	if (lo_arg == NULL)
 		xt_params->exit_err(RESOURCE_PROBLEM, "strdup");
@@ -645,7 +669,7 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 			continue;
 		}
 
-		value = xtables_getportbyname(arg);
+		value = xtables_getportbyname(arg, family, protocol);
 		if (value < 0)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"Port \"%s\" does not resolve to "
-- 
1.7.2.5

