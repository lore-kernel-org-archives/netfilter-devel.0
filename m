Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C7EC6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 13:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjCINxY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 08:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjCINw5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 08:52:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6E1A249
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2023 05:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=61Pwrz5jl8ydpdrG/j0EmCl8R0s5C49OcmsTbFhs17E=; b=QwWn59kJLHVaWPET2yKujdpeDr
        kzS2X2Q1hcsYRAwPNrVwJOQju1qDB40eVPp5wlEuaCNtAs9Q+upxN8SPBaYjUb6C7yafqDlwxtOFx
        6vEG1Cnn7MkQvhIAzNkVmEkWt+MzuXIPVDptxGkNfBXA50siOaYCGbZkDcNGRqxxtGmSgUkMC3PXM
        05UsW8232BDJBR3AnOhqCS5wT+qFdOJFsdkFvXE8OBi94QZP+rCNkqrLfsoMDOI9W+768aCfZ/E9P
        AQxVJP5rV3nYm0NFCFgzcuXVwqSwpTcQBHqxoe1BenHjT7wyCkiQEsMier4VumlEUUwa3nzJNcCnz
        Dc64BvcA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1paGhT-0006Fz-0h; Thu, 09 Mar 2023 14:52:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Document lower priority limit for nat type chains
Date:   Thu,  9 Mar 2023 14:52:46 +0100
Message-Id: <20230309135246.18143-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Users can't know the magic limit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 7de4935b4b375..0d60c7520d31e 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -439,6 +439,9 @@ name which specifies the order in which chains with the same *hook* value are
 traversed. The ordering is ascending, i.e. lower priority values have precedence
 over higher ones.
 
+With *nat* type chains, there's a lower excluding limit of -200 for *priority*
+values, because conntrack hooks at this priority and NAT requires it.
+
 Standard priority values can be replaced with easily memorizable names.  Not all
 names make sense in every family with every hook (see the compatibility matrices
 below) but their numerical value can still be used for prioritizing chains.
-- 
2.38.0

