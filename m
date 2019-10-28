Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A84CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD6D20830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfJ1Psi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:48:38 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40110 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfJ1Psi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:48:38 -0400
Received: from localhost ([::1]:53200 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7G1-00025X-8K; Mon, 28 Oct 2019 16:48:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 01/10] ip6tables, xtables-arp: Drop unused struct pprot
Date:   Mon, 28 Oct 2019 16:48:09 +0100
Message-Id: <20191028154818.31257-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These seem like leftovers when changing code to use xtables_chain_protos
as struct xtables_pprot is identical to struct pprot removed here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 6 ------
 iptables/xtables-arp.c | 7 -------
 2 files changed, 13 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c160a2dd4e65b..ee463c9586862 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -175,12 +175,6 @@ static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
 #define opts ip6tables_globals.opts
 #define prog_name ip6tables_globals.program_name
 #define prog_vers ip6tables_globals.program_version
-/* A few hardcoded protocols for 'all' and in case the user has no
-   /etc/protocols */
-struct pprot {
-	const char *name;
-	uint8_t num;
-};
 
 static void __attribute__((noreturn))
 exit_tryhelp(int status)
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 1a260e75e3808..8503f47fe2afe 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -209,13 +209,6 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* -c */ 0,
 };
 
-/* A few hardcoded protocols for 'all' and in case the user has no
-   /etc/protocols */
-struct pprot {
-	char *name;
-	u_int8_t num;
-};
-
 /* Primitive headers... */
 /* defined in netinet/in.h */
 #if 0
-- 
2.23.0

