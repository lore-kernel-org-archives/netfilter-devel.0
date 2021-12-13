Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BD8C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhLMSIO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhLMSIO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:08:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1CCC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:08:14 -0800 (PST)
Received: from localhost ([::1]:58960 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpkC-0004IP-HB; Mon, 13 Dec 2021 19:08:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 4/6] xtables_globals: Introduce program_variant
Date:   Mon, 13 Dec 2021 19:07:45 +0100
Message-Id: <20211213180747.20707-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213180747.20707-1-phil@nwl.cc>
References: <20211213180747.20707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is supposed to hold the variant name (either "legacy" or
"nf_tables") for use in shared help/error printing functions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      | 2 +-
 iptables/ip6tables.c   | 1 +
 iptables/iptables.c    | 1 +
 iptables/xtables-arp.c | 1 +
 iptables/xtables-eb.c  | 1 +
 iptables/xtables.c     | 1 +
 6 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/xtables.h b/include/xtables.h
index ca674c2663eb4..6763890efb50e 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -419,7 +419,7 @@ enum xtables_exittype {
 struct xtables_globals
 {
 	unsigned int option_offset;
-	const char *program_name, *program_version;
+	const char *program_name, *program_version, *program_variant;
 	const char *optstring;
 	struct option *orig_opts;
 	struct option *opts;
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 788966d6b68af..d9fd3de69dfea 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -91,6 +91,7 @@ void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
+	.program_variant = "legacy",
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 	.compat_rev = xtables_compatible_revision,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 78fff9ef77b81..5a634b2ef7a5d 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -89,6 +89,7 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
+	.program_variant = "legacy",
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 	.compat_rev = xtables_compatible_revision,
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index cca19438a877e..24d020de23370 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -89,6 +89,7 @@ static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION,
+	.program_variant	= "nf_tables",
 	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3f58754d14cee..b78d5b6aa74f5 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -220,6 +220,7 @@ extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ..
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= PACKAGE_VERSION,
+	.program_variant	= "nf_tables",
 	.optstring		= OPTSTRING_COMMON "h",
 	.orig_opts		= ebt_original_options,
 	.exit_err		= xtables_exit_error,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index d53fd758ac72d..e85df75e7c1c3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -91,6 +91,7 @@ void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __at
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
+	.program_variant = "nf_tables",
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.exit_err = xtables_exit_error,
-- 
2.33.0

