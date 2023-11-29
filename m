Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ThQ6fLny"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E23810A
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LX03F5ZwCADDJEyWZ6+uuGTjpov9WP0rhX6xumsVnhM=; b=ThQ6fLnyoc/EVmoh8Is7FO9JPN
	P1troriTRbcS52Y+2vgMd7JksQgcDEZcLgP9bfxUx4UuJj146gJz8BwI6eUbVAD0J6dy0lkpyuoen
	QWXN1qXLM7RNvNfAPC+N1O+o/PF57AAJF8kn8ARQclU+sRI/5emK6lK/j101ShC4i/Cgo+/z/r2S6
	Z9cluzG197uOmE7jcKyFqpxsivOwWr4MWCoNrX9vhL1kTkLpQ7xwrXf2aK1cjNCNfAqILschE824+
	I7OD2h+5jUqH+e7Rxw4gWMTLWEQbhlhEZjfQrz4WQk+O33kEpvMwqoeuDtgFt0BWpRyBT0oUQiZA8
	Vm+X2MOA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPi-0001j2-GE
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/13] xshared: Introduce print_help callback (again)
Date: Wed, 29 Nov 2023 14:28:18 +0100
Message-ID: <20231129132827.18166-5-phil@nwl.cc>
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

Prep work for ebtables parser to use do_parse(). Adding more special
casing to xtables_printhelp() causes a mess, so work with a callback
again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 1 +
 iptables/iptables.c  | 1 +
 iptables/nft-arp.c   | 1 +
 iptables/nft-ipv4.c  | 1 +
 iptables/nft-ipv6.c  | 1 +
 iptables/xshared.c   | 6 +++---
 iptables/xshared.h   | 2 ++
 7 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 96603756324a5..4b5d4ac6878b7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -671,6 +671,7 @@ int do_command6(int argc, char *argv[], char **table,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
 		.command_default = command_default,
+		.print_help	= xtables_printhelp,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index b57483ef44514..5ae28fe04a5f5 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -665,6 +665,7 @@ int do_command4(int argc, char *argv[], char **table,
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
 		.command_default = command_default,
+		.print_help	= xtables_printhelp,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index f3e2920ac6d15..6011620cf52a7 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -859,6 +859,7 @@ struct nft_family_ops nft_family_ops_arp = {
 		.option_name	= nft_arp_option_name,
 		.option_invert	= nft_arp_option_invert,
 		.command_default = command_default,
+		.print_help	= xtables_printhelp,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 754c776473143..979880a3e7702 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -355,6 +355,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
 		.command_default = command_default,
+		.print_help	= xtables_printhelp,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index b1b5891013577..e4b1714d00c2f 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -346,6 +346,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 		.option_name	= ip46t_option_name,
 		.option_invert	= ip46t_option_invert,
 		.command_default = command_default,
+		.print_help	= xtables_printhelp,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 29b3992904e68..177f3ddd1c19e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1108,9 +1108,9 @@ int print_match_save(const struct xt_entry_match *e, const void *ip)
 	return 0;
 }
 
-static void
-xtables_printhelp(const struct xtables_rule_match *matches)
+void xtables_printhelp(struct iptables_command_state *cs)
 {
+	const struct xtables_rule_match *matches = cs->matches;
 	const char *prog_name = xt_params->program_name;
 	const char *prog_vers = xt_params->program_version;
 
@@ -1527,7 +1527,7 @@ void do_parse(int argc, char *argv[],
 				xtables_find_match(cs->protocol,
 					XTF_TRY_LOAD, &cs->matches);
 
-			xtables_printhelp(cs->matches);
+			p->ops->print_help(cs);
 			xtables_clear_iptables_command_state(cs);
 			xtables_free_opts(1);
 			xtables_fini();
diff --git a/iptables/xshared.h b/iptables/xshared.h
index bf24fd568a6f5..69f50e505cb9b 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -274,6 +274,7 @@ struct xt_cmd_parse_ops {
 	int	(*option_invert)(int option);
 	int	(*command_default)(struct iptables_command_state *cs,
 				   struct xtables_globals *gl, bool invert);
+	void	(*print_help)(struct iptables_command_state *cs);
 };
 
 struct xt_cmd_parse {
@@ -289,6 +290,7 @@ struct xt_cmd_parse {
 	struct xt_cmd_parse_ops		*ops;
 };
 
+void xtables_printhelp(struct iptables_command_state *cs);
 const char *ip46t_option_name(int option);
 int ip46t_option_invert(int option);
 int command_default(struct iptables_command_state *cs,
-- 
2.41.0

