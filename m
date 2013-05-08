From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] libxtables: fix parsing of dotted network mask format
Date: Wed,  8 May 2013 15:08:48 +0200
Message-ID: <1368018528-10137-1-git-send-email-pablo@netfilter.org>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3EHNI7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 09:08:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After upgrade from iptables 1.4.8 to 1.4.18 netmask parsing got broken:

-A foo -m policy --mode tunnel --dir in --tunnel-src 192.168.123.0/255.255.255.0 -j RETURN

With iptables 1.4.18:
iptables-restore v1.4.18: policy: bad value for option "--tunnel-src", or out of range (0-32)

This was probably broken by augmented parser.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 libxtables/xtoptions.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 452e0fe..37fcf53 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -667,6 +667,33 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 	free(lo_arg);
 }
 
+static int xtopt_parse_mask(struct xt_option_call *cb)
+{
+	struct addrinfo hints = {.ai_family = afinfo->family,
+				 .ai_flags = AI_NUMERICHOST };
+	struct addrinfo *res;
+	int ret;
+
+	ret = getaddrinfo(cb->arg, NULL, &hints, &res);
+	if (ret < 0)
+		return 0;
+
+	memcpy(&cb->val.hmask, xtables_sa_host(res->ai_addr, res->ai_family),
+	       xtables_sa_hostlen(res->ai_family));
+
+	switch(afinfo->family) {
+	case AF_INET:
+		cb->val.hlen = xtables_ipmask_to_cidr(&cb->val.hmask.in);
+		break;
+	case AF_INET6:
+		cb->val.hlen = xtables_ip6mask_to_cidr(&cb->val.hmask.in6);
+		break;
+	}
+
+	freeaddrinfo(res);
+	return 1;
+}
+
 /**
  * Parse an integer and ensure it is within the address family's prefix length
  * limits. The result is stored in @cb->val.hlen.
@@ -677,12 +704,16 @@ static void xtopt_parse_plen(struct xt_option_call *cb)
 	unsigned int prefix_len = 128; /* happiness is a warm gcc */
 
 	cb->val.hlen = (afinfo->family == NFPROTO_IPV4) ? 32 : 128;
-	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, cb->val.hlen))
+	if (!xtables_strtoui(cb->arg, NULL, &prefix_len, 0, cb->val.hlen)) {
+		/* Is this mask expressed in full format? e.g. 255.255.255.0 */
+		if (xtopt_parse_mask(cb))
+			return;
+
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
 			"or out of range (%u-%u).\n",
 			cb->ext_name, entry->name, 0, cb->val.hlen);
-
+	}
 	cb->val.hlen = prefix_len;
 }
 
-- 
1.7.10.4

