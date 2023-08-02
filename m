Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F769EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjHBCEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHBCEm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1CF212C
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NnsaSFj88Ho3/+4cCEu38d7ZJykr43ttQ8nN0EAtVHg=; b=RL2ccZ01uMiJDWHLnyqzW3o4iQ
        b7+Q0Bw9uyVwU7WPF0bDxLSX08L4fFModQE4aefmX2i4G93AmyHHCnv0spfdnlDRbfZWC7x1vObhH
        CZkKZCOnJRin57ii8cG4pDL+num9+Vz+f8FKyaePcSNBCnU2ronHNIv0FfWRBfDoretw5UUHo9BLT
        QcDxqMi76+eHqkR9VZ2EBZznUCFrUsPq5bZMSEHIRjrVANKzHVerrKasO0gkZZUx7foRQ5DjVbkBC
        voXGN8xEeQqIrsnao9B9GpVXAIJ5pLP3angHPzgBrlSVr2agODOv5TaJdwMcwP09R/tdXR2spkHp6
        8a9rzTug==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1E8-0002qb-Lb; Wed, 02 Aug 2023 04:04:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 11/16] man: iptables-restore.8: Start paragraphs in upper-case
Date:   Wed,  2 Aug 2023 04:03:55 +0200
Message-Id: <20230802020400.28220-12-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add a missing full stop in one spot.

Reported-by: debian@helgefjell.de
Fixes: 117341ada43dd ("Added iptbles-restore and iptables-save manpages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 61f1fdd0baa26..f97f53813aeed 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -40,13 +40,13 @@ are used to restore IP and IPv6 Tables from data specified on STDIN or in
 specify \fIfile\fP as an argument.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-restore the values of all packet and byte counters
+Restore the values of all packet and byte counters.
 .TP
 \fB\-h\fP, \fB\-\-help\fP
 Print a short option summary.
 .TP
 \fB\-n\fR, \fB\-\-noflush\fR
-don't flush the previous contents of the table. If not specified,
+Don't flush the previous contents of the table. If not specified,
 both commands flush (delete) all previous contents of the respective table.
 .TP
 \fB\-t\fP, \fB\-\-test\fP
-- 
2.40.0

