Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9F3C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJLPTn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJLPTU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:19:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B770E312E
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p21sk5rynnJORZ1qJ1gWHsXmBRHS+GM/4n6aYNC41Go=; b=DS8CDCkcQP0PAO0DhZirBKBRxa
        YQDEAV9CSXRVWI9wS+DLL3l6TF8WwHOq3DFjYS1hAIohZNOGtghCzp2yZ0+Bac0Ow1a8T8PKqwh38
        WM2EZBDJXzt7Wh+jgoPm/waMP008PTvqDiIaaa/jhS0FEukHzOKKf2N52avFHrl3rRdpMYX5pEk1R
        WASu0ePOlS0CDYA9HFI/WU4uH/FQK8Ste9IfA9ZSw7LPcAlWUO98DDtYsrwHZxWVUOybL0N3gOv8P
        M5v3LpGFALTDlwe6Womj7Lzrv6abqZyKb3e9ZDbvW9kIMntN5pdWQ+vO4sJE+f77lCuFf7mpO3tGC
        JNMhHN4Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVl-0002qj-QP; Wed, 12 Oct 2022 17:19:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 11/12] tests: libxt_connlimit.t: Add missing default values
Date:   Wed, 12 Oct 2022 17:18:01 +0200
Message-Id: <20221012151802.11339-12-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This extension always prints --connlimit-mask and (the default)
--connlimit-saddr options.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_connlimit.t | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_connlimit.t b/extensions/libxt_connlimit.t
index c7ea61e95fbc8..366cea745c653 100644
--- a/extensions/libxt_connlimit.t
+++ b/extensions/libxt_connlimit.t
@@ -1,11 +1,11 @@
 :INPUT,FORWARD,OUTPUT
--m connlimit --connlimit-upto 0;=;OK
--m connlimit --connlimit-upto 4294967295;=;OK
--m connlimit --connlimit-upto 4294967296;;FAIL
+-m connlimit --connlimit-upto 0;-m connlimit --connlimit-upto 0 --connlimit-mask 32 --connlimit-saddr;OK
+-m connlimit --connlimit-upto 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
+-m connlimit --connlimit-upto 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-upto -1;;FAIL
--m connlimit --connlimit-above 0;=;OK
--m connlimit --connlimit-above 4294967295;=;OK
--m connlimit --connlimit-above 4294967296;;FAIL
+-m connlimit --connlimit-above 0;-m connlimit --connlimit-above 0 --connlimit-mask 32 --connlimit-saddr;OK
+-m connlimit --connlimit-above 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-above -1;;FAIL
 -m connlimit --connlimit-upto 1 --conlimit-above 1;;FAIL
 -m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;OK
-- 
2.34.1

