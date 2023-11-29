Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FyCH1j4I"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66779B2
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qAqm42Llfs712T9EGHrSvgmeJMePZd8CxVFLF3AVx+E=; b=FyCH1j4IHjqwwm2xgxn/RFh36E
	rSz/94RCSjUy9G2FMGPBIbSM94gqQLTQO3d3zOpYlQ9kbL+e9dzdCfw9+QCGE74hRYkevsz+fS68q
	6CxlUCBcH/x9sfMI4U8ZyQ0xkW49NvVs9qn5JV61C7xoWc09K0DusXZz07qlbTHsLkXupyZw+xi8+
	oxyFGJjJyNDR1TzuDquFtk+PB+nEZSKi4iq+DZkNf8/V0gT93i7TmOoLp5ovZ1JRZDFT01Nd4JUy3
	miEopBTjnYic7JJM0oSzDHRQScIBY+d7N6KDSB8ZAG/MLy2d3ocVCMcAOKUNdnYERSYXzUhpMy09m
	29C9525w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPh-0001iu-R2
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/13] xshared: Turn command_default() into a callback
Date: Wed, 29 Nov 2023 14:28:17 +0100
Message-ID: <20231129132827.18166-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ebtables' variant is pretty different since all extensions are loaded up
front and some targets serve as "watcher" extensions, so let variants
specify the function to call for extension parameters.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 1 +
 iptables/iptables.c  | 1 +
 iptables/nft-arp.c   | 1 +
 iptables/nft-ipv4.c  | 1 +
 iptables/nft-ipv6.c  | 1 +
 iptables/xshared.c   | 6 +++---
 iptables/xshared.h   | 4 ++++
 7 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 53eeb6e90bbb7..96603756324a5 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -670,6 +670,7 @@ int do_command6(int argc, char *argv[], char **table,
 		.post_parse	= ipv6_post_parse,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
+		.command_default = command_default,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 69dd289060528..b57483ef44514 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -664,6 +664,7 @@ int do_command4(int argc, char *argv[], char **table,
 		.post_parse	= ipv4_post_parse,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
+		.command_default = command_default,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c009dd83e26cf..f3e2920ac6d15 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -858,6 +858,7 @@ struct nft_family_ops nft_family_ops_arp = {
 		.post_parse	= nft_arp_post_parse,
 		.option_name	= nft_arp_option_name,
 		.option_invert	= nft_arp_option_invert,
+		.command_default = command_default,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index c140ffde34b62..754c776473143 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -354,6 +354,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 		.post_parse	= ipv4_post_parse,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
+		.command_default = command_default,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 4bf4f54f18a00..b1b5891013577 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -345,6 +345,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 		.post_parse	= ipv6_post_parse,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
+		.command_default = command_default,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ff809f2be3438..29b3992904e68 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -122,8 +122,8 @@ static struct xtables_match *load_proto(struct iptables_command_state *cs)
 			  cs->options & OPT_NUMERIC, &cs->matches);
 }
 
-static int command_default(struct iptables_command_state *cs,
-			   struct xtables_globals *gl, bool invert)
+int command_default(struct iptables_command_state *cs,
+		    struct xtables_globals *gl, bool invert)
 {
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
@@ -1784,7 +1784,7 @@ void do_parse(int argc, char *argv[],
 			exit_tryhelp(2, p->line);
 
 		default:
-			if (command_default(cs, xt_params, invert))
+			if (p->ops->command_default(cs, xt_params, invert))
 				/* cf. ip6tables.c */
 				continue;
 			break;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 3df2153fd6a10..bf24fd568a6f5 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -272,6 +272,8 @@ struct xt_cmd_parse_ops {
 			      struct xtables_args *args);
 	const char *(*option_name)(int option);
 	int	(*option_invert)(int option);
+	int	(*command_default)(struct iptables_command_state *cs,
+				   struct xtables_globals *gl, bool invert);
 };
 
 struct xt_cmd_parse {
@@ -289,6 +291,8 @@ struct xt_cmd_parse {
 
 const char *ip46t_option_name(int option);
 int ip46t_option_invert(int option);
+int command_default(struct iptables_command_state *cs,
+		    struct xtables_globals *gl, bool invert);
 
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
-- 
2.41.0

