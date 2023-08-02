Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1ADEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjHBCE1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHBCE1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EA6212C
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o6DYWTwopjqs42VW40uij9OPB3pb6+qwSE2gsvXb7Xs=; b=i+sLhGscHugDXrSH9c2bpEZiq+
        nH5h2OT/aDLgzfeO7YPkDJxs0bRkXA6EP1Jh/TVd++qK5UN88o/h87bgTAFYT12ukwLDP8YtSXMLj
        BKkMfLfpdJF3YAg0EStO8p+qh5w1Gfydo0tqjPSTjUQDpPuNJYWhbCz4P/L3wRAFRcsG4neUCeERz
        A5754yp7p6/YzVhPjtE+WlFo+Bc1I0Y+HvQFHS+AJRgC1ktRIHvoJTkrNFEkNjT0tnqosVIpWYSpr
        BKADVejn60qPy2nNI1Hz1yMdvFe+wyjRmrcKAoJOUJBp+RKyWkRtPveZvNcxZlSJfQ5SHxSQW3jN6
        Q2rATaPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Ds-0002or-Ls; Wed, 02 Aug 2023 04:04:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 10/16] man: iptables-restore.8: Put 'file' in italics in synopsis
Date:   Wed,  2 Aug 2023 04:03:54 +0200
Message-Id: <20230802020400.28220-11-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The text has it this way already, be consistent.

Reported-by: debian@helgefjell.de
Fixes: 081d57839e91e ("iptables-restore.8: file to read from can be specified as argument")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 24d9fc06af25a..61f1fdd0baa26 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -25,11 +25,11 @@ ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
 \fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
-[\fBfile\fP]
+[\fIfile\fP]
 .P
 \fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
-[\fBfile\fP]
+[\fIfile\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-restore
-- 
2.40.0

