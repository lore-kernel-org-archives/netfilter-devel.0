Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40D5C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391437AbiEFLpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391436AbiEFLpE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C88860D92
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QbdaokyS01XTrlsr0VfoIdZknkdmpL00at5LyZLPJPw=; b=BrM3AEetbMn1qoVnUS/rfZKbZz
        TujDYu2wBLzJBAt6RbjXEBebgpSs0BoulFSPcko5dqsBEeQDNR7ozRWXczt5gGVsfmTaUR5DbX/C+
        t5EkL9LICNiOXpzGX+slUkIyvqpTF67jbzAnEm2BNpYSQV3QWZYXCKKI7YTEbgF+J9dNviVtHtBFV
        kFKAPY1SASOOfm4+7WG5Q2+32srp2ee4gnWSPPrPsKhaSyMxaUs/GPbcXXQ/0CucDvwgSGDfHGaJG
        tnDEmE5765I2yomuUhglu/TPeub7osC3T18EEKEN4kkWrATDk4zLkxQ0bTshhzFlwQa0QwqlMrdY5
        nYqw82Ug==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwKk-0005q3-Ro; Fri, 06 May 2022 13:41:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/5] libxtables: Drop xtables_globals 'optstring' field
Date:   Fri,  6 May 2022 13:41:03 +0200
Message-Id: <20220506114104.7344-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506114104.7344-1-phil@nwl.cc>
References: <20220506114104.7344-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Define the different optstrings in xshared.h instead, they are not
relevant for other libxtables users.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      |  1 -
 iptables/ip6tables.c   |  1 -
 iptables/iptables.c    |  1 -
 iptables/xshared.c     | 17 ++++++++++++++++-
 iptables/xshared.h     |  3 +++
 iptables/xtables-arp.c |  1 -
 iptables/xtables-eb.c  |  3 +--
 iptables/xtables.c     |  1 -
 8 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index a93e8f6e91585..8c1065bc7e010 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -420,7 +420,6 @@ struct xtables_globals
 {
 	unsigned int option_offset;
 	const char *program_name, *program_version;
-	const char *optstring;
 	struct option *orig_opts;
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 5806a13ce0710..75984cc1bcdd8 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -90,7 +90,6 @@ static struct option original_opts[] = {
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION " (legacy)",
-	.optstring = OPTSTRING_COMMON "R:S::W::" "46bg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = xtables_compatible_revision,
 };
diff --git a/iptables/iptables.c b/iptables/iptables.c
index edde604cf2367..e5207ba106057 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -87,7 +87,6 @@ static struct option original_opts[] = {
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION " (legacy)",
-	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = xtables_compatible_revision,
 };
diff --git a/iptables/xshared.c b/iptables/xshared.c
index e959f203e5cc9..fae5ddd5df93e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1340,6 +1340,20 @@ static void check_inverse(struct xtables_args *args, const char option[],
 	}
 }
 
+static const char *optstring_lookup(int family)
+{
+	switch (family) {
+	case AF_INET:
+	case AF_INET6:
+		return IPT_OPTSTRING;
+	case NFPROTO_ARP:
+		return ARPT_OPTSTRING;
+	case NFPROTO_BRIDGE:
+		return EBT_OPTSTRING;
+	}
+	return "";
+}
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
@@ -1370,7 +1384,8 @@ void do_parse(int argc, char *argv[],
 	opterr = 0;
 
 	xt_params->opts = xt_params->orig_opts;
-	while ((cs->c = getopt_long(argc, argv, xt_params->optstring,
+	while ((cs->c = getopt_long(argc, argv,
+				    optstring_lookup(afinfo->family),
 				    xt_params->opts, NULL)) != -1) {
 		switch (cs->c) {
 			/*
diff --git a/iptables/xshared.h b/iptables/xshared.h
index e69da7351efa4..14568bb00fb65 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -68,6 +68,9 @@ struct xtables_rule_match;
 struct xtables_target;
 
 #define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:"
+#define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x"
+#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nv" /* "m:" */
+#define EBT_OPTSTRING	OPTSTRING_COMMON "hv"
 
 /* define invflags which won't collide with IPT ones */
 #define IPT_INV_SRCDEVADDR	0x0080
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index bf7d44e7b815b..71518a9cbdb6a 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -86,7 +86,6 @@ static struct option original_opts[] = {
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION " (nf_tables)",
-	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
 	.compat_rev		= nft_compatible_revision,
 };
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index a7bfb9c5c60b8..3d15063e80e91 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -220,7 +220,6 @@ struct option ebt_original_options[] =
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= PACKAGE_VERSION " (nf_tables)",
-	.optstring		= OPTSTRING_COMMON "hv",
 	.orig_opts		= ebt_original_options,
 	.compat_rev		= nft_compatible_revision,
 };
@@ -734,7 +733,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	opterr = false;
 
 	/* Getopt saves the day */
-	while ((c = getopt_long(argc, argv, xt_params->optstring,
+	while ((c = getopt_long(argc, argv, EBT_OPTSTRING,
 					opts, NULL)) != -1) {
 		cs.c = c;
 		switch (c) {
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 41b6eb4838733..70924176df8c1 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -88,7 +88,6 @@ static struct option original_opts[] = {
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION " (nf_tables)",
-	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = nft_compatible_revision,
 };
-- 
2.34.1

