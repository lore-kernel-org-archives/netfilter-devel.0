Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24259C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F22302085A
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfCHOhL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:37:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34201 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfCHOhL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:37:11 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <l.stach@pengutronix.de>)
        id 1h2GcX-0004Q8-2D
        for netfilter-devel@vger.kernel.org; Fri, 08 Mar 2019 15:37:09 +0100
From:   Lucas Stach <l.stach@pengutronix.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] xtables-legacy: add missing config.h include
Date:   Fri,  8 Mar 2019 15:37:09 +0100
Message-Id: <20190308143709.27721-1-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netfilter-devel@vger.kernel.org
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 iptables/xtables-legacy-multi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/xtables-legacy-multi.c b/iptables/xtables-legacy-multi.c
index e68814dd082e..3b7905ff76b1 100644
--- a/iptables/xtables-legacy-multi.c
+++ b/iptables/xtables-legacy-multi.c
@@ -1,3 +1,4 @@
+#include <config.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
2.20.1

