Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oHYAyJbM"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C316D72
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8CLQgAc9ncq55DtctCxf0V1FLy5fp4ynFw7NmnAlf5U=; b=oHYAyJbMphQj3eg41hw1HEBuAZ
	T3SogI3ROvHHbuZRRoQFWJeHFPmV7qR4lk4PBmh4HfqbEq5p+6nS+kiO/nwGi0dWhUlE7tFIPaSjl
	RNEaSnmwVqTMLBiBoVDds60+z/C87+Cyn5T5SvKFZ6Kofzrt86w8mCDBDyn5FrhX35XPzQyn97v5G
	SR9Lkauy9rMRYkwj2Q/q6H0lVcsVuefYUwMB/mIxYAJJD/pJJTQ/5Ds4YuyoR43HjETwbzVIcZJp4
	RD8ph8T3YKXq++i0wEop/F4QUWrkr4rc2L8MgATq49vYgFwa/LVssqCqhwXymIbOIW0eNl/XPTfzS
	wmzNwYHw==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6Tyq-0002J7-Ru
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:04:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] xshared: Introduce xt_cmd_parse_ops::option_invert
Date: Fri, 24 Nov 2023 12:13:24 +0100
Message-ID: <20231124111325.5221-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124111325.5221-1-phil@nwl.cc>
References: <20231124111325.5221-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the awkward inverse_for_options array with basically a few
switch() statements clearly identifying the relation between option and
inverse values and relieve callers from having to find the option flag
bit's position.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |  1 +
 iptables/iptables.c  |  1 +
 iptables/nft-arp.c   | 14 ++++++++++++++
 iptables/nft-ipv4.c  |  1 +
 iptables/nft-ipv6.c  |  1 +
 iptables/xshared.c   | 38 ++++++++++++++------------------------
 iptables/xshared.h   |  2 ++
 7 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 85cb211d2ec12..08da04b456787 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -670,6 +670,7 @@ int do_command6(int argc, char *argv[], char **table,
 		.proto_parse	= ipv6_proto_parse,
 		.post_parse	= ipv6_post_parse,
 		.option_name	= ip46t_option_name,
+		.option_invert	= ip46t_option_invert,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 4bfce62dd5d86..a73e8eed9028a 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -664,6 +664,7 @@ int do_command4(int argc, char *argv[], char **table,
 		.proto_parse	= ipv4_proto_parse,
 		.post_parse	= ipv4_post_parse,
 		.option_name	= ip46t_option_name,
+		.option_invert	= ip46t_option_invert,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 6f8e1952db3b8..c009dd83e26cf 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -832,6 +832,19 @@ static const char *nft_arp_option_name(int option)
 	}
 }
 
+static int nft_arp_option_invert(int option)
+{
+	switch (option) {
+	case OPT_S_MAC:		return IPT_INV_SRCDEVADDR;
+	case OPT_D_MAC:		return IPT_INV_TGTDEVADDR;
+	case OPT_H_LENGTH:	return IPT_INV_ARPHLN;
+	case OPT_OPCODE:	return IPT_INV_ARPOP;
+	case OPT_H_TYPE:	return IPT_INV_ARPHRD;
+	case OPT_P_TYPE:	return IPT_INV_PROTO;
+	default:		return ip46t_option_invert(option);
+	}
+}
+
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -844,6 +857,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.cmd_parse		= {
 		.post_parse	= nft_arp_post_parse,
 		.option_name	= nft_arp_option_name,
+		.option_invert	= nft_arp_option_invert,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 166680b3eb07c..7fb71ed4a8056 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -354,6 +354,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 		.proto_parse	= ipv4_proto_parse,
 		.post_parse	= ipv4_post_parse,
 		.option_name	= ip46t_option_name,
+		.option_invert	= ip46t_option_invert,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 2cc45944f6c04..bb417356629a9 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -345,6 +345,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 		.proto_parse	= ipv6_proto_parse,
 		.post_parse	= ipv6_post_parse,
 		.option_name	= ip46t_option_name,
+		.option_invert	= ip46t_option_invert,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 31a3019592317..f939a988fa59d 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1003,27 +1003,18 @@ const char *ip46t_option_name(int option)
 	}
 }
 
-static const int inverse_for_options[NUMBER_OF_OPT] =
+int ip46t_option_invert(int option)
 {
-/* -n */ 0,
-/* -s */ IPT_INV_SRCIP,
-/* -d */ IPT_INV_DSTIP,
-/* -p */ XT_INV_PROTO,
-/* -j */ 0,
-/* -v */ 0,
-/* -x */ 0,
-/* -i */ IPT_INV_VIA_IN,
-/* -o */ IPT_INV_VIA_OUT,
-/*--line*/ 0,
-/* -c */ 0,
-/* -f */ IPT_INV_FRAG,
-/* 2 */ IPT_INV_SRCDEVADDR,
-/* 3 */ IPT_INV_TGTDEVADDR,
-/* -l */ IPT_INV_ARPHLN,
-/* 4 */ IPT_INV_ARPOP,
-/* 5 */ IPT_INV_ARPHRD,
-/* 6 */ IPT_INV_PROTO,
-};
+	switch (option) {
+	case OPT_SOURCE:	return IPT_INV_SRCIP;
+	case OPT_DESTINATION:	return IPT_INV_DSTIP;
+	case OPT_PROTOCOL:	return XT_INV_PROTO;
+	case OPT_VIANAMEIN:	return IPT_INV_VIA_IN;
+	case OPT_VIANAMEOUT:	return IPT_INV_VIA_OUT;
+	case OPT_FRAGMENT:	return IPT_INV_FRAG;
+	default:		return -1;
+	}
+}
 
 static void
 set_option(struct xt_cmd_parse_ops *ops,
@@ -1037,14 +1028,13 @@ set_option(struct xt_cmd_parse_ops *ops,
 	*options |= option;
 
 	if (invert) {
-		unsigned int i;
-		for (i = 0; 1 << i != option; i++);
+		int invopt = ops->option_invert(option);
 
-		if (!inverse_for_options[i])
+		if (invopt < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				      "cannot have ! before %s",
 				      ops->option_name(option));
-		*invflg |= inverse_for_options[i];
+		*invflg |= invopt;
 	}
 }
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2470acbb46b7d..28efd73cf470a 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -274,6 +274,7 @@ struct xt_cmd_parse_ops {
 			      struct iptables_command_state *cs,
 			      struct xtables_args *args);
 	const char *(*option_name)(int option);
+	int	(*option_invert)(int option);
 };
 
 struct xt_cmd_parse {
@@ -290,6 +291,7 @@ struct xt_cmd_parse {
 };
 
 const char *ip46t_option_name(int option);
+int ip46t_option_invert(int option);
 
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
-- 
2.41.0

