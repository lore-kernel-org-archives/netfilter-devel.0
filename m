Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42BDC05027
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbjAZMYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbjAZMYm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA266C55C
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VaYJxv0FBCAkqQxuuXJb6JuRa5imGFZdqTBGmabBtSw=; b=irlFaLlw4HguHhy0tdaMxyQSZV
        Smtz7L8ACpGIgcse7rnJJ5Ug3jaVmG6tQ82cNnQCtmCp6wzs0WgFSIpg9Lu3fzpg4iqpiQ483nAx2
        HWdJXYI9zg3fbe+Qs6nb1fveyBMJiQVRG1jB0A6dbm/4sM4q+xdrHxNu5JOjB5Q9uk9L5MpIYZaFb
        87wcw6o4KBKK6s+xGGmKGRUHBpzpsnhvz88OHdya3FFP2QVjKYsAo+OUJjmingnYY1G5KjE84e0FH
        kJ/YCwn4oqHuetPIK5Dfa/BnUn+pdDDdB6s70alRjRbQ7CPDPNQNrBN9gtVIVSCbyZaaTlWGQQdOW
        e50F6bsQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1Iw-000589-Ec
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/7] ebtables: Refuse unselected targets' options
Date:   Thu, 26 Jan 2023 13:24:01 +0100
Message-Id: <20230126122406.23288-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike legacy, ebtables-nft would allow e.g.:

| -t nat -A PREROUTING --to-dst fe:ed:00:00:ba:be

While the result is correct, it may mislead users into believing
multiple targets are possible per rule. Better follow legacy's behaviour
and reject target options unless they have been "enabled" by a previous
'-j' option.

To achieve this, one needs to distinguish targets from watchers also
attached to 'xtables_targets' and otherwise behaving like regular
matches. Introduce XTABLES_EXT_WATCHER to mark the two.

The above works already, but error messages are misleading when using
the now unsupported syntax since target options have been merged
already. Solve this by not pre-loading the targets at all, code will
just fall back to loading ad '-j' parsing time as iptables does.

Note how this also fixes for 'counter' statement being in wrong position
of ebtables-translate output.

Fixes: fe97f60e5d2a9 ("ebtables-compat: add watchers support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_dnat.txlate                 | 12 ++++----
 extensions/libebt_log.c                       |  1 +
 extensions/libebt_mark.txlate                 | 16 +++++-----
 extensions/libebt_nflog.c                     |  1 +
 extensions/libebt_snat.txlate                 |  8 ++---
 include/xtables.h                             |  1 +
 .../ebtables/0002-ebtables-save-restore_0     |  4 +--
 iptables/xtables-eb.c                         | 29 +++++++------------
 8 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/extensions/libebt_dnat.txlate b/extensions/libebt_dnat.txlate
index 9f305c76c954f..531a22aa3e14f 100644
--- a/extensions/libebt_dnat.txlate
+++ b/extensions/libebt_dnat.txlate
@@ -1,8 +1,8 @@
-ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff
-nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter'
+ebtables-translate -t nat -A PREROUTING -i someport -j dnat --to-dst de:ad:00:be:ee:ff
+nft 'add rule bridge nat PREROUTING iifname "someport" counter ether daddr set de:ad:0:be:ee:ff accept'
 
-ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff --dnat-target ACCEPT
-nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff accept counter'
+ebtables-translate -t nat -A PREROUTING -i someport -j dnat --to-dst de:ad:00:be:ee:ff --dnat-target ACCEPT
+nft 'add rule bridge nat PREROUTING iifname "someport" counter ether daddr set de:ad:0:be:ee:ff accept'
 
-ebtables-translate -t nat -A PREROUTING -i someport --to-dst de:ad:00:be:ee:ff --dnat-target CONTINUE
-nft 'add rule bridge nat PREROUTING iifname "someport" ether daddr set de:ad:0:be:ee:ff continue counter'
+ebtables-translate -t nat -A PREROUTING -i someport -j dnat --to-dst de:ad:00:be:ee:ff --dnat-target CONTINUE
+nft 'add rule bridge nat PREROUTING iifname "someport" counter ether daddr set de:ad:0:be:ee:ff continue'
diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 045062196d20d..9f8d158956802 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -197,6 +197,7 @@ static int brlog_xlate(struct xt_xlate *xl,
 static struct xtables_target brlog_target = {
 	.name		= "log",
 	.revision	= 0,
+	.ext_flags	= XTABLES_EXT_WATCHER,
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_log_info)),
diff --git a/extensions/libebt_mark.txlate b/extensions/libebt_mark.txlate
index d006e8ac94008..4ace1a1f5cfde 100644
--- a/extensions/libebt_mark.txlate
+++ b/extensions/libebt_mark.txlate
@@ -1,11 +1,11 @@
-ebtables-translate -A INPUT --mark-set 42
-nft 'add rule bridge filter INPUT meta mark set 0x2a accept counter'
+ebtables-translate -A INPUT -j mark --mark-set 42
+nft 'add rule bridge filter INPUT counter meta mark set 0x2a accept'
 
-ebtables-translate -A INPUT --mark-or 42 --mark-target RETURN
-nft 'add rule bridge filter INPUT meta mark set meta mark or 0x2a return counter'
+ebtables-translate -A INPUT -j mark --mark-or 42 --mark-target RETURN
+nft 'add rule bridge filter INPUT counter meta mark set meta mark or 0x2a return'
 
-ebtables-translate -A INPUT --mark-and 42 --mark-target ACCEPT
-nft 'add rule bridge filter INPUT meta mark set meta mark and 0x2a accept counter'
+ebtables-translate -A INPUT -j mark --mark-and 42 --mark-target ACCEPT
+nft 'add rule bridge filter INPUT counter meta mark set meta mark and 0x2a accept'
 
-ebtables-translate -A INPUT --mark-xor 42 --mark-target DROP
-nft 'add rule bridge filter INPUT meta mark set meta mark xor 0x2a drop counter'
+ebtables-translate -A INPUT -j mark --mark-xor 42 --mark-target DROP
+nft 'add rule bridge filter INPUT counter meta mark set meta mark xor 0x2a drop'
diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index 115e15da45845..762d6d5d8bbe2 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -146,6 +146,7 @@ static int brnflog_xlate(struct xt_xlate *xl,
 static struct xtables_target brnflog_watcher = {
 	.name		= "nflog",
 	.revision	= 0,
+	.ext_flags	= XTABLES_EXT_WATCHER,
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_BRIDGE,
 	.size		= XT_ALIGN(sizeof(struct ebt_nflog_info)),
diff --git a/extensions/libebt_snat.txlate b/extensions/libebt_snat.txlate
index 857a6052aed1a..37343d3a14754 100644
--- a/extensions/libebt_snat.txlate
+++ b/extensions/libebt_snat.txlate
@@ -1,5 +1,5 @@
-ebtables-translate -t nat -A POSTROUTING -s 0:0:0:0:0:0 -o someport+ --to-source de:ad:00:be:ee:ff
-nft 'add rule bridge nat POSTROUTING oifname "someport*" ether saddr 00:00:00:00:00:00 ether saddr set de:ad:0:be:ee:ff accept counter'
+ebtables-translate -t nat -A POSTROUTING -s 0:0:0:0:0:0 -o someport+ -j snat --to-source de:ad:00:be:ee:ff
+nft 'add rule bridge nat POSTROUTING oifname "someport*" ether saddr 00:00:00:00:00:00 counter ether saddr set de:ad:0:be:ee:ff accept'
 
-ebtables-translate -t nat -A POSTROUTING -o someport --to-src de:ad:00:be:ee:ff --snat-target CONTINUE
-nft 'add rule bridge nat POSTROUTING oifname "someport" ether saddr set de:ad:0:be:ee:ff continue counter'
+ebtables-translate -t nat -A POSTROUTING -o someport -j snat --to-src de:ad:00:be:ee:ff --snat-target CONTINUE
+nft 'add rule bridge nat POSTROUTING oifname "someport" counter ether saddr set de:ad:0:be:ee:ff continue'
diff --git a/include/xtables.h b/include/xtables.h
index 4ffc8ec5a17e9..087a1d600f9ae 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -203,6 +203,7 @@ struct xtables_lmap {
 
 enum xtables_ext_flags {
 	XTABLES_EXT_ALIAS = 1 << 0,
+	XTABLES_EXT_WATCHER = 1 << 1,
 };
 
 struct xt_xlate;
diff --git a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0 b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
index 1091a4e80bebe..b4f9728bb9b6f 100755
--- a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
+++ b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
@@ -38,7 +38,7 @@ $XT_MULTI ebtables -A foo -p IPv6 --ip6-proto tcp -j ACCEPT
 
 $XT_MULTI ebtables -A foo --limit 100 --limit-burst 42 -j ACCEPT
 $XT_MULTI ebtables -A foo --log
-$XT_MULTI ebtables -A foo --mark-set 0x23 --mark-target ACCEPT
+$XT_MULTI ebtables -A foo -j mark --mark-set 0x23 --mark-target ACCEPT
 $XT_MULTI ebtables -A foo --nflog
 $XT_MULTI ebtables -A foo --pkttype-type multicast -j ACCEPT
 $XT_MULTI ebtables -A foo --stp-type config -j ACCEPT
@@ -53,7 +53,7 @@ $XT_MULTI ebtables -A FORWARD -j foo
 $XT_MULTI ebtables -N bar
 $XT_MULTI ebtables -P bar RETURN
 
-$XT_MULTI ebtables -t nat -A PREROUTING --redirect-target ACCEPT
+$XT_MULTI ebtables -t nat -A PREROUTING -j redirect --redirect-target ACCEPT
 #$XT_MULTI ebtables -t nat -A PREROUTING --to-src fe:ed:ba:be:00:01
 
 $XT_MULTI ebtables -t nat -A OUTPUT -j ACCEPT
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 412b5cccdc46a..3a73e79725489 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -468,14 +468,14 @@ static void ebt_load_match(const char *name)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
 
-static void __ebt_load_watcher(const char *name, const char *typename)
+static void ebt_load_watcher(const char *name)
 {
 	struct xtables_target *watcher;
 	size_t size;
 
 	watcher = xtables_find_target(name, XTF_TRY_LOAD);
 	if (!watcher) {
-		fprintf(stderr, "Unable to load %s %s\n", name, typename);
+		fprintf(stderr, "Unable to load %s watcher\n", name);
 		return;
 	}
 
@@ -496,16 +496,6 @@ static void __ebt_load_watcher(const char *name, const char *typename)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
 
-static void ebt_load_watcher(const char *name)
-{
-	return __ebt_load_watcher(name, "watcher");
-}
-
-static void ebt_load_target(const char *name)
-{
-	return __ebt_load_watcher(name, "target");
-}
-
 void ebt_load_match_extensions(void)
 {
 	opts = ebt_original_options;
@@ -522,13 +512,6 @@ void ebt_load_match_extensions(void)
 
 	ebt_load_watcher("log");
 	ebt_load_watcher("nflog");
-
-	ebt_load_target("mark");
-	ebt_load_target("dnat");
-	ebt_load_target("snat");
-	ebt_load_target("arpreply");
-	ebt_load_target("redirect");
-	ebt_load_target("standard");
 }
 
 void ebt_add_match(struct xtables_match *m,
@@ -633,6 +616,9 @@ int ebt_command_default(struct iptables_command_state *cs)
 
 	/* Is it a watcher option? */
 	for (t = xtables_targets; t; t = t->next) {
+		if (!(t->ext_flags & XTABLES_EXT_WATCHER))
+			continue;
+
 		if (t->parse &&
 		    t->parse(cs->c - t->option_offset, cs->argv,
 			     ebt_invert, &t->tflags, NULL, &t->t)) {
@@ -726,6 +712,11 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	optind = 0;
 	opterr = false;
 
+	for (t = xtables_targets; t; t = t->next) {
+		t->tflags = 0;
+		t->used = 0;
+	}
+
 	/* Getopt saves the day */
 	while ((c = getopt_long(argc, argv, EBT_OPTSTRING,
 					opts, NULL)) != -1) {
-- 
2.38.0

