Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382B7C83F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjH2NHp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbjH2NHU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:07:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Aug 2023 06:07:18 PDT
Received: from mail.inliniac.net (static-27.netfusion.at [83.215.238.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0578A99
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:07:17 -0700 (PDT)
Received: by mail.inliniac.net (Postfix, from userid 108)
        id AC7C645B; Tue, 29 Aug 2023 15:00:09 +0200 (CEST)
Received: from localhost.localdomain (77-174-216-85.fixed.kpn.net [77.174.216.85])
        (Authenticated sender: victor)
        by mail.inliniac.net (Postfix) with ESMTPSA id 8696B104;
        Tue, 29 Aug 2023 15:00:06 +0200 (CEST)
From:   Victor Julien <victor@inliniac.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Victor Julien <victor@inliniac.net>
Subject: [PATCH] doc: fix example of xt_cpu
Date:   Tue, 29 Aug 2023 14:59:32 +0200
Message-Id: <20230829125932.31735-1-victor@inliniac.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

REDIRECT uses --to-ports instead of --to-port.

Fixes: 2d59208943a3 ("extension: add xt_cpu match")

Signed-off-by: Victor Julien <victor@inliniac.net>
---
 extensions/libxt_cpu.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_cpu.man b/extensions/libxt_cpu.man
index d9ea5c2f..c89ef08a 100644
--- a/extensions/libxt_cpu.man
+++ b/extensions/libxt_cpu.man
@@ -7,9 +7,9 @@ multiqueue NICs to spread network traffic on different queues.
 Example:
 .PP
 iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 0 
-\-j REDIRECT \-\-to\-port 8080
+\-j REDIRECT \-\-to\-ports 8080
 .PP
 iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 1 
-\-j REDIRECT \-\-to\-port 8081
+\-j REDIRECT \-\-to\-ports 8081
 .PP
 Available since Linux 2.6.36.
-- 
2.34.1

