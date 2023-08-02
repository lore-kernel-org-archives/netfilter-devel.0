Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494D4C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbjHBQKH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjHBQKG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2671995
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I61mMgSDgBruHUl38yubpWpSfMEGBvP3A1t/Ba25rwI=; b=e9ds9qXXfrKNS0wF/UhGk1tZ/p
        /A1DwU08qspTTEoxtrUzctX1FX0i5U67aThGlalPebP8fQ++Z2iuoyxdWs61TX+oJQhVWhvLXWCER
        q1B3/mLkWFkVh/RA/esV0uzIRmQk58GBrSlkrdVEOLdLsyRXBaTAp7VZoue6t1L3TvMz+cBzUY4Gh
        wpCWXtyk79SXElB5A5A2c0dUUuRtNIWrp3r1/bcnw4eCGaW5i+7vxc0iYZLuFSocnq1Q2kaNAfZoA
        Vkpx6zoB1Aw8SbljOtyX7D4t3FcokxhoCmejDKh+iphlvM+DPh0LWueb/BUf8Uka2EPjm0qiuDBsf
        AhxTmVWQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQG-0004vH-0Q
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 10/15] man: iptables-restore.8: Put 'file' in italics in synopsis
Date:   Wed,  2 Aug 2023 18:09:18 +0200
Message-Id: <20230802160923.17949-11-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The text has it this way already, be consistent.

Fixes: 081d57839e91e ("iptables-restore.8: file to read from can be specified as argument")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index bfd2fc355dd49..ff8179091eeee 100644
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

