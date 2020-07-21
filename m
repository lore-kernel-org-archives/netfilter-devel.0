Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CE9C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 13:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 774F62073A
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 13:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="tJEOcR+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgGUNDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgGUNDr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 09:03:47 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92957C061794
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 06:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LQHkYT5vNkD4JkWE7hlOeP1wdduOYZE3ZPN0xDb/R+E=; b=tJEOcR+mvXZyRujn2Ld/y6bWO2
        SSALDGlo5kYFqyL+xxpXizIp9gxGE7crhKcF1aAgRE8rBOq16d+nmHQhgbo03MvXvSNdDyqk8JGki
        uCqmw76st/+taQ3wlUoZzZcaL3uI+wMpCp9sUfvwk1dDazNxJed6A/G3gFMI98Vhv+dMn+l2MoqQD
        6X81w/mdCq/O5sYVi4mgmLN/6hF+EaVkH7JgenvL4Ps8/ZZd4EllUCZtD6JiCWxjQgXUv8lmB1LSf
        AoT7Qwf/Yg3F3NIaXpWYP/ykjz91P4U4pW04ZEXYuNs2uhLhYu/d3c7yXBvF/GeMqmkey41H9Qurp
        waXhUqAA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jxrvu-0001Fx-4K; Tue, 21 Jul 2020 14:03:46 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2] doc: fix quoted string in libxt_DNETMAP man-page.
Date:   Tue, 21 Jul 2020 14:03:45 +0100
Message-Id: <20200721130345.717735-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In roff, lines beginning with a single quote are control lines.  In the
libxt_DNETMAP man-page there is a single-quoted string at the beginning
of a line, which troff tries and fails to interpret as a macro:

  troff: <standard input>:49: warning: macro 'S'' not defined

This means that the line is not output.

Replace the single quotes with the appropriate escape-sequences.

Fixes: 2b38d081a50b ("doc: spelling and grammar corrections to DNETMAP")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_DNETMAP.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_DNETMAP.man b/extensions/libxt_DNETMAP.man
index 7a8fe404435b..a59b6551fcbe 100644
--- a/extensions/libxt_DNETMAP.man
+++ b/extensions/libxt_DNETMAP.man
@@ -46,7 +46,7 @@ Contains the binding table for the given \fIsubnet/mask\fP. Each line contains
 \fBprenat address\fR, \fBpostnat address\fR, \fBttl\fR (seconds until the entry
 times out), \fBlasthit\fR (last hit to the entry in seconds relative to system
 boot time). Please note that the \fBttl\fR and \fBlasthit\fR entries contain an
-'\fBS\fR' in case of a static binding.
+\(oq\fBS\fR\(cq in case of a static binding.
 .TP
 \fB/proc/net/xt_DNETMAP/\fR\fIsubnet\fR\fB_\fR\fImask\fR\fB_stat\fR
 Contains statistics for a given \fIsubnet/mask\fP. The line contains four
-- 
2.27.0

