Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E27CC43461
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2660D6144E
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbhD1RiO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242227AbhD1RiL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:38:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55DFC0613ED
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:25 -0700 (PDT)
Received: from localhost ([::1]:34742 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7o-0007AX-Dq; Wed, 28 Apr 2021 19:37:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] xtables: Make invflags 16bit wide
Date:   Wed, 28 Apr 2021 19:36:52 +0200
Message-Id: <20210428173656.16851-2-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210428173656.16851-1-phil@nwl.cc>
References: <20210428173656.16851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is needed to merge with xtables-arp which has more builtin
options and hence needs more bits in invflags.

The only adjustment needed is the set_option() call for option '-j'
which passed a pointer to cs->fw.ip.invflags. That field can't be
changed, it belongs to uAPI. Though using args->invflags instead works
fine, aside from that '-j' doesn't support inverting so this is merely a
sanity check and no real invflag value assignment will happen.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h | 2 +-
 iptables/xtables.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index da4ba9d2ba8de..cc8f3a79b369e 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -190,7 +190,7 @@ struct xtables_args {
 	int		family;
 	uint16_t	proto;
 	uint8_t		flags;
-	uint8_t		invflags;
+	uint16_t	invflags;
 	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
 	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 	bool		goto_set;
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 9779bd83d53b3..c3d82014778b2 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -239,7 +239,7 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 
 static void
-set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
+set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
 	   int invert)
 {
 	if (*options & option)
@@ -692,7 +692,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 #endif
 
 		case 'j':
-			set_option(&cs->options, OPT_JUMP, &cs->fw.ip.invflags,
+			set_option(&cs->options, OPT_JUMP, &args->invflags,
 				   cs->invert);
 			command_jump(cs, optarg);
 			break;
-- 
2.31.0

