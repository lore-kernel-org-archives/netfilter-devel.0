Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA76C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7316604AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhHBJNF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJNE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 05:13:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B79C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 02:12:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mAU0D-0002dh-E5; Mon, 02 Aug 2021 11:12:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools 4/4] conntrack: add shorthand mnemonic for UNREPLIED
Date:   Mon,  2 Aug 2021 11:12:31 +0200
Message-Id: <20210802091231.1486-5-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802091231.1486-1-fw@strlen.de>
References: <20210802091231.1486-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

conntrack tool prints [UNREPLIED] if a conntrack entry lacks the
SEEN_REPLY bit.  Accept this as '-u' argument too.

If requested, mask is set to SEEN_REPLY and value remains 0 (bit not set).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index cc564a2b4b1b..ef7f604c9e97 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1199,6 +1199,7 @@ parse_parameter(const char *arg, unsigned int *status, int parse_type)
 static void
 parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask, int parse_type)
 {
+	static const char unreplied[] = "UNREPLIED";
 	unsigned int *value;
 	const char *comma;
 	bool negated;
@@ -1215,6 +1216,12 @@ parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask,
 
 		value = negated ? mask : status;
 
+		if (!negated && strncmp(arg, unreplied, strlen(unreplied)) == 0) {
+			*mask |= IPS_SEEN_REPLY;
+			arg = comma+1;
+			continue;
+		}
+
 		if (!do_parse_parameter(arg, comma-arg, value, parse_type))
 			exit_error(PARAMETER_PROBLEM,"Bad parameter `%s'", arg);
 		arg = comma+1;
@@ -1225,6 +1232,11 @@ parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask,
 		arg++;
 	value = negated ? mask : status;
 
+	if (!negated && strncmp(arg, unreplied, strlen(unreplied)) == 0) {
+		*mask |= IPS_SEEN_REPLY;
+		return;
+	}
+
 	if (strlen(arg) == 0
 	    || !do_parse_parameter(arg, strlen(arg),
 		    value, parse_type))
-- 
2.31.1

