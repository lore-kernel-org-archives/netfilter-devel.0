Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B7BC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 19:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED6061246
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 19:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356033AbhJATSJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 15:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhJATSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 15:18:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF0C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 12:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I8oLPHjT9uBwgMBaW1TVaaprvSjB92VbkQR3Lj4dwvY=; b=diZFOnYBsNiMUVz4OcxMwCYHHk
        TaW4brFzR/lPqmM9Gm6p4JjV7CnvCdl0I8utS05Be0BKLFp7lFfoV7sTgrdDZouf8GBItni0t/oT6
        Lm3N7kyUZJl8aEnKHFTXnCy7mh38K8wjMxUCen4JCMqKZovwobOCGsj0TBO+Ppp8T/VPzXv0Lt7OA
        y3wjnYG1+ISADJ6XixCsCH3i3DMZvjliQEHODilbTKXOjyZKBKnAPlhfU4DbCrNLBDC265l8XRg32
        rwDjzyi1vDaiuhSu4sTd3We9X7rPww5DXClU9hq3JaRgPZInHfe79qcA0KAtO5BZYnI1sbXcVMEC7
        ep6uupFw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWO15-002ULU-33
        for netfilter-devel@vger.kernel.org; Fri, 01 Oct 2021 20:16:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH] tests: shell: fix bashism
Date:   Fri,  1 Oct 2021 20:12:28 +0100
Message-Id: <20211001191228.1315767-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `<(cmd)` redirection is specific to Bash.  Update the shebang
accordingly.

Fixes: 63ab4fe3a191 ("ebtables: Avoid dropping policy when flushing")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/tests/shell/testcases/ebtables/0007-chain-policies_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/tests/shell/testcases/ebtables/0007-chain-policies_0 b/iptables/tests/shell/testcases/ebtables/0007-chain-policies_0
index faf37d02eaea..d79f91b1446d 100755
--- a/iptables/tests/shell/testcases/ebtables/0007-chain-policies_0
+++ b/iptables/tests/shell/testcases/ebtables/0007-chain-policies_0
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 case "$XT_MULTI" in
 *xtables-nft-multi)
-- 
2.33.0

