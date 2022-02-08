Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770BCC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Feb 2022 14:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiBHOKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Feb 2022 09:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiBHOKL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Feb 2022 09:10:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738ABC03FECE
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Feb 2022 06:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QAWu/YZTz3VTlgjY5MwPzuOE7RxIAAG49O+AfX+t8Tc=; b=T8enoH6wqeWFDaONy+UMUrgP5m
        XYvFef6Yfu1AyUxxkQrUDXoMhg7v83w4cexBZq0YAyXVz4kPGF0GQ5133tatjTvhRBffsfC12Q16t
        254A/+QfPlHyiQ0UzVc7YWbx67FGOjXgJbo0bCRIk37BxlPJO0Dq4l2FQXEu6wM1cYLrAOFgP/yJQ
        OThhuSB6RjohhgklGKhgOeNZPBdrXsqw0F5zxGjityUi7phniZeblheuolj2GlYlVpWAOKDWfQAeX
        7XsNL4DkFAhrBn0WO8p7tMFfXfvYAj18hTgGhg5q/EzWt0nMmIOTmUuU/5vluDklYq9KcoJ/kR5hI
        YGVTrXfQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nHRC3-0005Hf-WE; Tue, 08 Feb 2022 15:10:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables.8: Describe the effect of multiple -v flags
Date:   Tue,  8 Feb 2022 15:10:01 +0100
Message-Id: <20220208141001.29383-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Functionality differs between legacy and nft variants, detail the
effects a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables.8.in | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 759ec54fdeb72..ccc498f56def1 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -360,7 +360,11 @@ byte counters are also listed, with the suffix 'K', 'M' or 'G' for
 the \fB\-x\fP flag to change this).
 For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed. \fB\-v\fP may be
-specified multiple times to possibly emit more detailed debug statements.
+specified multiple times to possibly emit more detailed debug statements:
+Specified twice, \fBiptables-legacy\fP will dump table info and entries in
+libiptc, \fBiptables-nft\fP dumps rules in netlink (VM code) presentation.
+Specified three times, \fBiptables-nft\fP will also dump any netlink messages
+sent to kernel.
 .TP
 \fB\-V\fP, \fB\-\-version\fP
 Show program version and the kernel API used.
-- 
2.34.1

