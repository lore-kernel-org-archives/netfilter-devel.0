Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A05C388F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 18:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE7B21707
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 18:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="R0l8S5ot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417988AbgJYSQA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 14:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417977AbgJYSP7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 14:15:59 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D47C061755
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 11:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+XpJnKupvh+Sg32pHP/2hLfgXeeUfBbHsSiF1ntnvg8=; b=R0l8S5otEMQF0xXPKXu9iNWcZe
        GeOWLIzdH6vmH1T3UfRRiKJduopqjVKEQ4/UXJrGdrf0AjHMqCMj+rm3E7R0hm8hbNkG6sqrs9RyN
        aNS2UCxpg5H7iJoBrd8dRoVDCcpu46j/7XKVln5BFDYYyLxjYZLsnbHLvkFIkzKC+HIQ8mJ1NBcXy
        qyHT5WqjFRmhmziKi6JvMbTXdBjfie12JNI3Sf/3l7JBGpzAfAZvIvjuhF7Vfa9ZcVk5Cy+hQNonq
        +UeLORfrJcE+joAJZ4SNq2HVBvBF/f/QFVr7nwxHuR9Fa03p3QkUeqTIkbA2yQ6VN4NqT6xAWpms7
        GLdgirNw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWkYd-00010U-DM; Sun, 25 Oct 2020 18:15:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons] pnock: pknlusr: mention the group ID command-line paramater in the man-page.
Date:   Sun, 25 Oct 2020 18:15:51 +0000
Message-Id: <20201025181551.962197-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.8 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/extensions/pknock/pknlusr.8 b/extensions/pknock/pknlusr.8
index a34b8fe1abbb..2c24bff52ec5 100644
--- a/extensions/pknock/pknlusr.8
+++ b/extensions/pknock/pknlusr.8
@@ -4,12 +4,15 @@
 pknlusr \(em userspace monitor for successful xt_pknock matches
 .SH Synopsis
 .PP
-\fBpknlusr\fP
+\fBpknlusr\fP [ \fIgroup-id\fP ]
 .SH Description
 \fIxt_pknock\fP is an xtables match extension that implements so-called \fIport
 knocking\fP. It can be configured to send information about each successful
 match via a netlink socket to userspace. \fBpknluser\fP listens for these
 notifications.
+.PP
+By default, \fBpknlusr\fP listens for messages sent to netlink multicast group
+1.  Another group ID may be passed as a command-line argument.
 .SH See also
 .PP
 xtables-addons(8)
-- 
2.28.0

