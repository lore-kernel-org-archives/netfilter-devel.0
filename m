Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72754C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjHBQJy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjHBQJv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:09:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5ED1FCB
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CaxKm9t5+z7wRuUYg+9iZcoK7n9MdTrQ5vvde725uTo=; b=AU9L2ytYTdyeU1m+IqMgDIH38K
        kZTLHxqpRHwrwRs7YlZ6U4R+KbsNYUvQji8pdEg85p9nWg5Oa/I4rRHSo9tcjtiyAAKS/BuV4jPVv
        kezB0dpyTRhWqpWgaDYO9SwvSKn1n2xj1va0CVvw8m7tYXKicinGalgQTfB8S2wu/H2hOaR04FaUs
        A/ZVgB7zQSkor/rxt5ujZIsSARzAWfnyEnVmSJWLXUtutdQRLc0ebJH+ja4a9+YuxBNNYE8PAPPN9
        Z1imJEeKygDfyZ3jHSSbOBcjK1dAlDiRbTNaHc/WqIqc1aqdDKfm1+Af6F4E0aMPRwizHlqTUsT29
        j8eqkGOg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREPz-0004u1-Uh
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:09:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 12/15] man: Trivial: Missing space after comma
Date:   Wed,  2 Aug 2023 18:09:20 +0200
Message-Id: <20230802160923.17949-13-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 6a79d78986c02 ("iptables: mention iptables-apply(8) in manpages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 2 +-
 iptables/iptables-save.8.in    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index ce4520e626772..aa816f794d6f3 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -82,7 +82,7 @@ from Rusty Russell.
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-restore.
 .SH SEE ALSO
-\fBiptables\-apply\fP(8),\fBiptables\-save\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8), \fBiptables\-save\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 7683fd3780f72..253907719acee 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -62,7 +62,7 @@ Rusty Russell <rusty@rustcorp.com.au>
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-save.
 .SH SEE ALSO
-\fBiptables\-apply\fP(8),\fBiptables\-restore\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8), \fBiptables\-restore\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
-- 
2.40.0

