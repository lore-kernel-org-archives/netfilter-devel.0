From: Thierry Du Tre <thierry@dtsystems.be>
Subject: [PATCH] extensions: libipt_DNAT: support shifted portmap ranges
Date: Wed, 20 Dec 2017 17:40:31 +0100
Message-ID: <52576776-f14e-3401-d28e-59e5a44c9bde@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38964 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754388AbdLTQke (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 11:40:34 -0500
Received: by mail-wm0-f67.google.com with SMTP id i11so10890957wmf.4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 08:40:33 -0800 (PST)
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a proposal patch for iptables DNAT extension to support shifted 
portmap ranges. It is related to the kernel patch proposed in earlier 
message '[PATCH] netfilter : add NAT support for shifted portmap ranges'.

The syntax uses an extra value in '--to-destination' for setting the 
base port which determines the offset in the redirect port range for 
incoming connections.
i.e. : iptables -t nat -A zone_wan_prerouting -p tcp -m tcp --dport 
5000:5100 -j DNAT --to-destination '192.168.1.2:2000-2100;5000'
The base port value is totally optional, so current behavior is not 
impacted in any way.

The use of semicolon as separator is an arbitrary choice, all other 
suggestions are valid of course.
The base port is now member of 'struct nf_nat_ipv4_range' together with 
min and max port. Therefore, the simplest solution is to parse the base 
port as part of the to-destination argument.
Another approach using an additional option seems also possible (i.e. 
'--base-port 5000'). However, that would mean more parsing logic with 
extra lines of code and thus increased risk for regression.

When a definitive solution is agreed on, I'll update libipt6_DNAT and 
man page accordingly.

Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>

---
  extensions/libipt_DNAT.c         | 18 +++++++++++++++++-
  include/linux/netfilter/nf_nat.h |  3 +++
  2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index a14d16f..f810efe 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -30,7 +30,7 @@ static void DNAT_help(void)
  {
  	printf(
  "DNAT target options:\n"
-" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
+" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port[;port]]]\n"
  "				Address to map destination to.\n"
  "[--random] [--persistent]\n");
  }
@@ -102,6 +102,7 @@ parse_to(const char *orig_arg, int portok, struct 
ipt_natinfo *info)
  				= htons(port);
  		} else {
  			int maxport;
+			char *semicolon;

  			maxport = atoi(dash + 1);
  			if (maxport <= 0 || maxport > 65535)
@@ -113,6 +114,17 @@ parse_to(const char *orig_arg, int portok, struct 
ipt_natinfo *info)
  					   "Port range `%s' funky\n", colon+1);
  			range.min.tcp.port = htons(port);
  			range.max.tcp.port = htons(maxport);
+
+			if ((semicolon = strchr(dash, ';'))) {
+				int baseport;
+
+				baseport = atoi(semicolon + 1);
+				if (baseport <= 0 || baseport > 65535)
+					xtables_error(PARAMETER_PROBLEM,
+							 "Port `%s' not valid\n", semicolon+1);
+				range.flags |= NF_NAT_RANGE_PROTO_OFFSET;
+				range.base.tcp.port = htons(baseport);
+			}
  		}
  		/* Starts with a colon? No IP info...*/
  		if (colon == arg) {
@@ -208,6 +220,8 @@ static void print_range(const struct 
nf_nat_ipv4_range *r)
  		printf("%hu", ntohs(r->min.tcp.port));
  		if (r->max.tcp.port != r->min.tcp.port)
  			printf("-%hu", ntohs(r->max.tcp.port));
+		if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
+			printf(";%hu", ntohs(r->base.tcp.port));
  	}
  }

@@ -259,6 +273,8 @@ static void print_range_xlate(const struct 
nf_nat_ipv4_range *r,
  		xt_xlate_add(xl, ":%hu", ntohs(r->min.tcp.port));
  		if (r->max.tcp.port != r->min.tcp.port)
  			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
+		if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
+			xt_xlate_add(xl, ";%hu", ntohs(r->base.tcp.port));
  	}
  }

diff --git a/include/linux/netfilter/nf_nat.h 
b/include/linux/netfilter/nf_nat.h
index 1ad3659..a945ee3 100644
--- a/include/linux/netfilter/nf_nat.h
+++ b/include/linux/netfilter/nf_nat.h
@@ -9,6 +9,7 @@
  #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
  #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
  #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)

  #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
  	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -19,6 +20,7 @@ struct nf_nat_ipv4_range {
  	__be32				max_ip;
  	union nf_conntrack_man_proto	min;
  	union nf_conntrack_man_proto	max;
+	union nf_conntrack_man_proto	base;
  };

  struct nf_nat_ipv4_multi_range_compat {
@@ -32,6 +34,7 @@ struct nf_nat_range {
  	union nf_inet_addr		max_addr;
  	union nf_conntrack_man_proto	min_proto;
  	union nf_conntrack_man_proto	max_proto;
+	union nf_conntrack_man_proto	base_proto;
  };

  #endif /* _NETFILTER_NF_NAT_H */
-- 
2.7.4
