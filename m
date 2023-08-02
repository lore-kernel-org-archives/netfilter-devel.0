Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B0CC04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjHBQJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjHBQJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:09:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2395C1BE4
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qyh4nvV6wyibp2gXONRJKbxkKbTXVcESl0UBDoV9NVs=; b=kA7hP8n6wnen7cJAjcHSer7Ge6
        /mDQgKpXZTHD/x0CSUxm6l+5k1cu4hsxnkCBakWi7Ak5savnUihHTecqg1SfDGCheY0OtSN6kOBGj
        QSYw06t2GBQQjlPLk/r49kl7DmZNeCM3rbwUZRn5g+6lJlg6eDZ7GGaQf/abNiCJ5KTt+/96ONkRx
        X+6bYsb+WQd+pdCBlEYVysJSebtyjpVkNO3b9bg/yqc0o/VNq0V34EYQmaM00F+O3/mE9xm7+R71M
        pC7VH15fnuMEofd7cOkL2MhLpiXWvp776Gr58c0Y4emrpI9o7hOmPAWEcftutme+cG0L8KLBu0N4G
        mJoPS7aw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREPu-0004tv-J0
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:09:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 11/15] man: iptables-restore.8: Start paragraphs in upper-case
Date:   Wed,  2 Aug 2023 18:09:19 +0200
Message-Id: <20230802160923.17949-12-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add a missing full stop in one spot.

Fixes: 117341ada43dd ("Added iptbles-restore and iptables-save manpages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index ff8179091eeee..ce4520e626772 100644
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

