Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0191EC001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjHBQKe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjHBQKd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0195CE1
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ivyY5J5NiN6TO49HkeqNRFX7VZ4rJYUem8RAARRBlds=; b=Rm/xf1V2yJcqN0b4BN4ydbwVDD
        0lsfpq0NzJwHWuKEPzCfCtLm2nq0lKj/RDDlzePUoHiW0yG/mt/jaJOGArfQGPi1/iQPxblBUVQO/
        GxJKAYAjH2R+tEAip5xMh5ukUaiS1J3GbTiVjCf+H339rjniSbr+lK6fmsoAREd9yuMhSjOZy/92x
        Vg+P7woN86/lgMukFQYtmCpn8fmphLy5BaDekVoJ5+8nGCyDAmbeELX7teEcyL7+kkEHNtj63IEf5
        yeuYGf1BqmPpaFhKpxHdegbEK/uEJ3oYid22DMxN21OtcKRjYcc0ckfMFxuFgkfqBeEckvxe0mCPw
        xOiflLsg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQh-0004wu-Ab
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 08/15] man: iptables-restore.8: Consistently document -w option
Date:   Wed,  2 Aug 2023 18:09:16 +0200
Message-Id: <20230802160923.17949-9-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the same name for the option's argument.

Fixes: 65801d02a482b ("iptables-restore.8: document -w/-W options")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index f95f00acd8d49..a63a344c0bd72 100644
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

