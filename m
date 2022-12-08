Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEF0C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLHAGI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiLHAGH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:06:07 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B198BD0A
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eLym2MZFZb+SDuyi92RynoARa72Gc/puxr227RsNp1Y=; b=fz2oJxZax6RAo0AE3cLk32o4yw
        E14K+pWnKD19gCcFKha4cHHrLAkYYCWrYFdB6M6yfOc8h9MOyJmwG3fiofkHcJabeoZvHpL4uCKQc
        lSSWwoX79MwBIRlcbiaQF2aDoLXQ0C9pZifEL5aeJOq3tYfdN6CFFJvGc1DftdGaDUuorcICm1oFE
        D7k/L3QANA92oyKinZrq/5BTOT4oA5a2wsk+cMjNwE4wshNORjIa8mMRgBx4b0On9t9EcWg5O4Wqw
        Zwnybr0BQlHR34ZVbBsozt2uBVh8EL6hcmBqgAuLBpdPAvdb5oPBTg9fXMxwm3bA38fOWwmMsu+bK
        WTV3QCEA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34QI-0005Oh-Am; Thu, 08 Dec 2022 01:05:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [nft PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:05:49 +0100
Message-Id: <20221208000549.13465-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to bzip2.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index eb1882dd828e8..f39832125b402 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_DEFINE([RELEASE_NAME], ["Lester Gooch #4"], [Release name])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
-        tar-pax no-dist-gzip dist-bzip2 1.6])
+        tar-pax no-dist-gzip dist-xz 1.6])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
2.38.0

