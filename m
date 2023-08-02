Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C5EC001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjHBQKN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjHBQKM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E75E1
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+ai5EvVegN6dWGZtEJBeYxDpwLPUyGsya+DF7XJdbg8=; b=HKeDqtyunhp7Uf8JsL0jBkreew
        +tZDAvgGB70U5+sdpMMsLXQtWRkxeWemJ0A9NVIrh5XMbMyHfgTWM1k6n/6xaiwcrdm8V32vZO0VT
        1LatEGktVIZQlRfe65P7Q1PhXIumY0c29LHhwBsnSvCeP5u0dpWHQWVSa/+qWPlxfSnejjbxcDG43
        v+G8HBHO1KwhfnZaUt5B2N3nMjaXqcC8UNJ9Jkf1o0e0xj9x8L/dXy1IllqwgjXjSckhIWqCitLlG
        I/jv3QfTEH9+w6iyYRGLcGOjN28cB+nOqIZvtrXNPpIsXiOyKTbcCAy5hGlui61b5Uviryul3gX2r
        iBH/SNNw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQL-0004vM-Im
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 09/15] man: iptables-restore.8: Drop -W option from synopsis
Date:   Wed,  2 Aug 2023 18:09:17 +0200
Message-Id: <20230802160923.17949-10-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The description was dropped already, there is no benefit in still
listing it.

Fixes: 07e2107ef0cbc ("xshared: Implement xtables lock timeout using signals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index a63a344c0bd72..bfd2fc355dd49 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -24,11 +24,11 @@ iptables-restore \(em Restore IP Tables
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
 \fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
-[\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
+[\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fBfile\fP]
 .P
 \fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
-[\fB\-W\fP \fIusecs\fP] [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
+[\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fBfile\fP]
 .SH DESCRIPTION
 .PP
-- 
2.40.0

