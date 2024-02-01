Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00155CDFE
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795465; cv=none; b=AuVEZ+V34gQFk0AjczpZN6h3fPRlvcM2umZHO6AB6F5/fj73eq9FjKsm//hYHNV4nMZI93DIqTGWzSmcGbcl0zzb0yRLyfPcdTAch+Vu0yczfhSgCgr/WMWoZSm4r/A4rElMYumH6tZ1YzL0nqeQOWQy1CVhtJ8c/34e8q3yd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795465; c=relaxed/simple;
	bh=e9AU3JqSTPotCEe1B61MkQfBfg/STaUZGkLg+tawVbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnaUZLKK17GmG4sanQRLVcC+D0oRBv4oEo02Z4FigHXgDORBGsUxsJcA5SSzzLIa7ZqC//ZBN7itWg3V3XeFE7eM4Kb36LmZ5kB2HGqNLWj0lHq/mcuila+4faTIvsOwb8Ws0X9LhK90EFVB7Yr3cdHOokjFW4MkFJzkxtxhILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mJUyWBtC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mJUyWBtC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rqeWfTZrYoWhRRHFMifXP1zlzYAST1CAiEEzo9JmVL0=; b=mJUyWBtCn7GwxWYWhuwfEdKzCQ
	yGYtuTSpDgwC7cOyEUxYWyK03CG2rjk+ycrMy7aYmBAp5Mfo/AGfflVKgaNTTv/HoCK+ozW+ApMY1
	QBXrTHtoFXSh3rbze3O3tKNFDMuj94Td7QkbVkMXsC4fXt14Vo+buDUG0eeqE7CBV+79XeYCh7Qcd
	gFLTILJCdlkleRB55/ks4o/pF3PMuGpt4s9f6vkM1WgRwILFaAU+Fvnu1bQh4owDW4gvLW8+8H4QX
	5KYLQIk5FcfDLZEllWW4gWwOWcOjNjSCAeQJH0RpTCB/qkWQCCXw6O+RMbRFVjwshXT6XnO+SKyEX
	Dn8uw7wA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT3-000000001ML-1Ffq;
	Thu, 01 Feb 2024 14:51:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 5/7] xshared: Fix for memleak in option merging with ebtables
Date: Thu,  1 Feb 2024 14:50:55 +0100
Message-ID: <20240201135057.24828-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The crucial difference in ebtables is that all extensions are loaded up
front instead of while parsing -m/-j flags. Since this loading of all
extensions before every call to do_parse() is pointless overhead (cf.
ebtables-restore), other tools' mechanism of freeing all merged options
in xtables_free_opts() after handling each command and resetting
xt_params->opts at the start of the parser loop is problematic.

Fixed commit entailed a hack to defeat the xt_params->opts happening at
start of do_parse() by assigning to xt_params->orig_opts after loading
all extensions. This approach caused a memleak though since
xtables_free_opts() called from xtables_merge_options() will free the
opts pointer only if it differs from orig_opts.

Resolve this via a different approach which eliminates the
xt_params->opts reset at the start of do_parse():

Make xt_params->opts be NULL until the first extension is loaded. Option
merging in command_match() and command_jump() tolerates a NULL pointer
there after minimal adjustment. Deinit in xtables_free_opts() is already
fine as it (re)turns xt_params->opts to a NULL pointer. With do_parse()
expecting that and falling back to xt_params->orig_opts, no explicit
initialization is required anymore and thus ebtables' init is not
mangled by accident.

A critical part is that do_parse() checks xt_params->opts pointer upon
each call to getopt_long() as it may get assigned while parsing.

Fixes: 58d364c7120b5 ("ebtables: Use do_parse() from xshared")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c    | 12 +++++++++---
 iptables/xtables-eb.c | 25 +++++++++++++------------
 libxtables/xtables.c  |  6 ++----
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 43fa929df7676..7d073891ed5c3 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -798,6 +798,9 @@ static void command_match(struct iptables_command_state *cs, bool invert)
 	else if (m->extra_opts != NULL)
 		opts = xtables_merge_options(xt_params->orig_opts, opts,
 					     m->extra_opts, &m->option_offset);
+	else
+		return;
+
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 	xt_params->opts = opts;
@@ -856,10 +859,13 @@ void command_jump(struct iptables_command_state *cs, const char *jumpto)
 		opts = xtables_options_xfrm(xt_params->orig_opts, opts,
 					    cs->target->x6_options,
 					    &cs->target->option_offset);
-	else
+	else if (cs->target->extra_opts != NULL)
 		opts = xtables_merge_options(xt_params->orig_opts, opts,
 					     cs->target->extra_opts,
 					     &cs->target->option_offset);
+	else
+		return;
+
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 	xt_params->opts = opts;
@@ -1484,10 +1490,10 @@ void do_parse(int argc, char *argv[],
 	   demand-load a protocol. */
 	opterr = 0;
 
-	xt_params->opts = xt_params->orig_opts;
 	while ((cs->c = getopt_long(argc, argv,
 				    optstring_lookup(afinfo->family),
-				    xt_params->opts, NULL)) != -1) {
+				    xt_params->opts ?: xt_params->orig_opts,
+				    NULL)) != -1) {
 		switch (cs->c) {
 			/*
 			 * Command selection
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index d197b37e81e9e..51c699defb047 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -298,11 +298,14 @@ static void ebt_load_match(const char *name)
 	xs_init_match(m);
 
 	if (m->x6_options != NULL)
-		opts = xtables_options_xfrm(opts, NULL,
+		opts = xtables_options_xfrm(xt_params->orig_opts, opts,
 					    m->x6_options, &m->option_offset);
 	else if (m->extra_opts != NULL)
-		opts = xtables_merge_options(opts, NULL,
+		opts = xtables_merge_options(xt_params->orig_opts, opts,
 					     m->extra_opts, &m->option_offset);
+	else
+		return;
+
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 	xt_params->opts = opts;
@@ -332,11 +335,16 @@ static void ebt_load_watcher(const char *name)
 	xs_init_target(watcher);
 
 	if (watcher->x6_options != NULL)
-		opts = xtables_options_xfrm(opts, NULL, watcher->x6_options,
+		opts = xtables_options_xfrm(xt_params->orig_opts, opts,
+					    watcher->x6_options,
 					    &watcher->option_offset);
 	else if (watcher->extra_opts != NULL)
-		opts = xtables_merge_options(opts, NULL, watcher->extra_opts,
+		opts = xtables_merge_options(xt_params->orig_opts, opts,
+					     watcher->extra_opts,
 					     &watcher->option_offset);
+	else
+		return;
+
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 	xt_params->opts = opts;
@@ -344,7 +352,6 @@ static void ebt_load_watcher(const char *name)
 
 static void ebt_load_match_extensions(void)
 {
-	xt_params->opts = ebt_original_options;
 	ebt_load_match("802_3");
 	ebt_load_match("arp");
 	ebt_load_match("ip");
@@ -358,10 +365,6 @@ static void ebt_load_match_extensions(void)
 
 	ebt_load_watcher("log");
 	ebt_load_watcher("nflog");
-
-	/* assign them back so do_parse() may
-	 * reset opts to orig_opts upon each call */
-	xt_params->orig_opts = xt_params->opts;
 }
 
 void ebt_add_match(struct xtables_match *m,
@@ -531,7 +534,6 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 
 void nft_fini_eb(struct nft_handle *h)
 {
-	struct option *opts = xt_params->opts;
 	struct xtables_match *match;
 	struct xtables_target *target;
 
@@ -542,8 +544,7 @@ void nft_fini_eb(struct nft_handle *h)
 		free(target->t);
 	}
 
-	if (opts != ebt_original_options)
-		free(opts);
+	free(xt_params->opts);
 
 	nft_fini(h);
 	xtables_fini();
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 856bfae804ea9..ae3ff25a3a876 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -111,10 +111,8 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 
 void xtables_free_opts(int unused)
 {
-	if (xt_params->opts != xt_params->orig_opts) {
-		free(xt_params->opts);
-		xt_params->opts = NULL;
-	}
+	free(xt_params->opts);
+	xt_params->opts = NULL;
 }
 
 struct option *xtables_merge_options(struct option *orig_opts,
-- 
2.43.0

