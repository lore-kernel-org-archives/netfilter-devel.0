Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAAEEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjHBCEt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjHBCEs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1608212D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LalZa9w87JM4hnnW48OPcULhKE1lcZQfdRkQfsAUU04=; b=eQ1zOnj3PiJPM/Kfa+3lWwFmnZ
        kImax5i2Zklhoqi++ndAO5V6E8+PO53WWCepQuAMcE1+tqhiKILzzzIwXKFnfJUyGmgeuGQ9sndLq
        v71ItnQ/3Dd2YxnOiEGpFIUfIV27270QEvO6I4Z1mj8OPsPDLI5Hq6KFFvd7u5qqotELXcjlED976
        FjTgXkeRonFcSEuighPvnmXX/NBmArJx+/Wnv0M+rzlhSoCDl1MQKQjC5gWz9W9KNbRTqJb60UemI
        YLT+AgCc7p2FmHeZKceiuNFzjNPaUhPbsQWOIqZPRuk4smmr4Iughh055b7zQ6n1K8cQCT1pgJ4iH
        jBSDOaSg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1EE-0002qo-0b
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 04:04:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/16] man: iptables-restore.8: Drop -W option from synopsis
Date:   Wed,  2 Aug 2023 04:03:53 +0200
Message-Id: <20230802020400.28220-10-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
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
index ac639687ca1ad..24d9fc06af25a 100644
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

