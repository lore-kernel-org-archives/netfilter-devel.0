Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EADDEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjHBCF3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjHBCF0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322322139
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C3w0Cax1RVBiv1VuTcHhwXzun6+WWPV4C1Yf35scylw=; b=o/ldZw5om8NzHW5OT7B6qQfnke
        YtThOpL7/aIwmKi3JBpnCkjFbKgWuBNu8U0Nc3QYOcJxBNSvawzFOGFaQlkJYI3jWiDMX2rh9/ewG
        AMljx8OEeVSM1fmwFDhP7BRiKlnKhEmF9KeTmSC24k43iTbH1dsXoGh6ROYFPzl260ekDNzHTx/ol
        CrhTq3GaWZBiTmjO65YQvEHm4+x0wNMYEyyCEJj14tThX4zgpoOM8fSSXXdulhZHAg5SO30M2cFEN
        gs7Pm4naJDeov7roVlLHU/MUwsdLEFH9UzRsDHlIhRAQmTJKpt/s1U4dpfwUXDKcoHYeprKOr//jR
        JD5iwe6Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Ep-0002tq-GH; Wed, 02 Aug 2023 04:05:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 08/16] man: iptables-restore.8: Consistently document -w option
Date:   Wed,  2 Aug 2023 04:03:52 +0200
Message-Id: <20230802020400.28220-9-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the same name for the option's argument.

Reported-by: debian@helgefjell.de
Fixes: 65801d02a482b ("iptables-restore.8: document -w/-W options")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 5846a47cefbcc..ac639687ca1ad 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -23,11 +23,11 @@ iptables-restore \(em Restore IP Tables
 .P
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIsecs\fP]
+\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fBfile\fP]
 .P
-\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIsecs\fP]
+\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fBfile\fP]
 .SH DESCRIPTION
-- 
2.40.0

