Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFDFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9C5D610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhKFVAs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVAs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:00:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD70C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:06 -0700 (PDT)
Received: from localhost ([::1]:58746 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlI-00045l-Qa; Sat, 06 Nov 2021 21:58:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/10] xshared: Make load_proto() static
Date:   Sat,  6 Nov 2021 21:57:56 +0100
Message-Id: <20211106205756.14529-11-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The last outside users vanished ten years ago.

Fixes: 449cdd6bcc8d1 ("src: combine default_command functions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 2 +-
 iptables/xshared.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 37ea71068b69c..a1ca2b0fd7e3e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -107,7 +107,7 @@ static bool should_load_proto(struct iptables_command_state *cs)
 	return !cs->proto_used;
 }
 
-struct xtables_match *load_proto(struct iptables_command_state *cs)
+static struct xtables_match *load_proto(struct iptables_command_state *cs)
 {
 	if (!should_load_proto(cs))
 		return NULL;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 757940090dd69..060c62ef0b5ca 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -166,7 +166,6 @@ extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern int command_default(struct iptables_command_state *,
 	struct xtables_globals *, bool invert);
-extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
-- 
2.33.0

