Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243C116CD3F
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464831; cv=none; b=LtJ96Y7RvFWLfsbgTZBZeLa087YUDnJX0OO++SY4GjO2bJxdHOZzNnyewKPDFbPXbnaLNParkKs4dR22jKoiRkrAFvQejddlS78KNX5jF1l3IJOXXOUfmtojx+HQSFUnT+YL/6IW4OgPefhyF+8ysINIoYp/Q0PBqeYSrD5Q+W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464831; c=relaxed/simple;
	bh=l6OhOSEaTjyDXmNgWp05txx+OyxH3PaDy2klgnD/XDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz0RjPbyVcG3q4v6cuiwEAdZEeufXWdPLQ1EWTLCQyu0jm28qkaIcdqL3MOIizEOR7Z8xHrTGYYEQ9wwfp6U+l44IeH9UxpuYo6R9K/g84AVqkLr40hhcwfJCxWXNq/q71k1SltcJkHgQj53ZWbkKXWZlnwx6/APIHqg2G0mB3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h96KGH+S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h96KGH+S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JcI/TTnptgxgnFBnY7D4WL+2md0ceGnhdoxyJkCWYAs=; b=h96KGH+Skm/puCERr6YVPVGece
	Xlu8tiw1FCKaWc1sV5/co198sGnrzLYSxc6qg3z4MFrnZysMpX9d3QHSVw7EN2al1NQF3KjE3nGZ2
	7E0AQSX4BpQ/SfdsXgOudP7ZnDwVUIytt2DvnWKSe3rH5D36fJsjG53lZ4LUM/nrnBqp169MNUZbI
	JJev46yHTZlbbmknDDnRvfz38zpyeJMXeFCwgLAfXWrw3tCu230obPBYt9J0xtWsUbVdrew6TOAOE
	LyjYZaUs6fsPFM5WHMX7sOLcjrlUjPqToHLANYz0rXnt67X9GfNH736SVQfkGCGGvM6zW2bvHveO9
	QsoXdtbw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHml-000000003i6-1RUU;
	Thu, 01 Aug 2024 00:27:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 2/8] ebtables: Introduce nft_bridge_init_cs()
Date: Thu,  1 Aug 2024 00:26:57 +0200
Message-ID: <20240731222703.22741-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom init done by nft_rule_to_ebtables_command_state() (which is
also the reason for its existence in the first place) should better go
into an ebtables-specific init_cs callback. Properly calling it from
do_commandeb() then removes the need for that custom rule_to_cs
callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 11 +++++------
 iptables/xtables-eb.c |  4 +++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index f75a13fbf1120..1623acbac0ba6 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -203,12 +203,9 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	return _add_action(r, cs);
 }
 
-static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
-					       const struct nftnl_rule *r,
-					       struct iptables_command_state *cs)
+static void nft_bridge_init_cs(struct iptables_command_state *cs)
 {
 	cs->eb.bitmask = EBT_NOPROTO;
-	return nft_rule_to_iptables_command_state(h, r, cs);
 }
 
 static void print_iface(const char *option, const char *name, bool invert)
@@ -353,7 +350,8 @@ static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (format & FMT_LINENUMBERS)
 		printf("%d. ", num);
 
-	nft_rule_to_ebtables_command_state(h, r, &cs);
+	nft_bridge_init_cs(&cs);
+	nft_rule_to_iptables_command_state(h, r, &cs);
 	__nft_bridge_save_rule(&cs, format);
 	ebt_cs_clean(&cs);
 }
@@ -699,7 +697,8 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.print_rule		= nft_bridge_print_rule,
 	.save_rule		= nft_bridge_save_rule,
 	.save_chain		= nft_bridge_save_chain,
-	.rule_to_cs		= nft_rule_to_ebtables_command_state,
+	.rule_to_cs		= nft_rule_to_iptables_command_state,
+	.init_cs		= nft_bridge_init_cs,
 	.clear_cs		= ebt_cs_clean,
 	.xlate			= nft_bridge_xlate,
 };
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 51c699defb047..45663a3ad0ee0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -557,7 +557,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		.argc = argc,
 		.argv = argv,
 		.jumpto	= "",
-		.eb.bitmask = EBT_NOPROTO,
 	};
 	const struct builtin_table *t;
 	struct xtables_args args = {
@@ -572,6 +571,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	};
 	int ret = 0;
 
+	if (h->ops->init_cs)
+		h->ops->init_cs(&cs);
+
 	do_parse(argc, argv, &p, &cs, &args);
 
 	h->verbose	= p.verbose;
-- 
2.43.0

