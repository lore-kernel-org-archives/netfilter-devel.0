Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A231ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 13:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbiHZNOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 09:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiHZNOj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 09:14:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917213F1DD
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rQK+vhG1aAtMdTMAj2dXZgH0n7fP4+mFRMMzXaU2Tmk=; b=p5uDk5KGrb7ORNRzADMFPz1oVh
        hJAQu1PAUqgUfdN42SkTvqtEorQiOZaaIKv49uF1zMCOFHZFZGoH2j4Cqj4v288ACmbid+zC118iL
        DTDoYDfeFDewTWKvn+NtMXqlO6hW3cX6X26ZoWct+4ein2b/MtJTSTJoh7J3U8Nzv118wDJqIgIqP
        HTtiOwG/YeAd1swiuXug5Ji1DfIMpLeJETxpWKCfwiBYhqTqTI5UulhhSId2oSXZnNZ/EAUQs5qsz
        nl2wulrSY84EKpzEtnvCjHeIfR6KVsuo4yz+7vfw6iPDqekJyOo3QSkzOTjIyjsKzH+XPj7sCsdBR
        RceuPhdw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oRZAR-00070X-Ou; Fri, 26 Aug 2022 15:14:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Extend limit statement's burst value info
Date:   Fri, 26 Aug 2022 15:14:31 +0200
Message-Id: <20220826131431.19696-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Describe how the burst value influences the kernel module's token
bucket in each of the two modes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Looking at the code, maybe one should make byte-based limit burst
default to either zero or four times the rate value instead of the
seemingly arbitrary 5 bytes.
---
 doc/statements.txt | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6aaf806bcff25..af8ccb8603c67 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -332,8 +332,13 @@ ____
 A limit statement matches at a limited rate using a token bucket filter. A rule
 using this statement will match until this limit is reached. It can be used in
 combination with the log statement to give limited logging. The optional
-*over* keyword makes it match over the specified rate. Default *burst* is 5.
-if you specify *burst*, it must be non-zero value.
+*over* keyword makes it match over the specified rate.
+
+The *burst* value influences the bucket size, i.e. jitter tolerance. With
+packet-based *limit*, the bucket holds exactly *burst* packets, by default
+five. With byte-based *limit*, the bucket's minimum size is the given rate's
+byte value and the *burst* value adds to that, by default five bytes. If you
+specify *burst*, it must be a non-zero value.
 
 .limit statement values
 [options="header"]
-- 
2.34.1

