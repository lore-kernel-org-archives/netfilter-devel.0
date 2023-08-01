Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C86BC001E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 15:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjHAPPi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 11:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjHAPPh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 11:15:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE646116
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 08:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mlE38JizW8cSGzxLBJJrzioYP9KgvrxA6EPNFCHfJlQ=; b=YcEtxm9rhsgapbZtdKJTLUsb77
        C4tWaEwAXYeVnzqjdq+dNJzYu/JWe+gSj4jNNvK3/BTgHzM0x1obaqU+Z6D/NwQ3ffI1ph0AlBFkR
        kyXTC1ISyK22YW/7j62Tt+A4BT3oXCT596mj+6cPjrr2BkYQF3TPq7qM09bEKe/vVEctIGClCIeOD
        jU9SgS33KsF+VNBCpVZA9A8fKlJF+vdrFHA8+J/vm7JblOIxRz4F4UAkCgdvedmK9WbeUhF5ZdvjN
        HSdjPan2ePBsGLgzEynrgXO94+duIE0DhYAb8l/vlsRLVZfpKzi6MZH2yysofwbUaywP+afygOkrK
        k1SIaIvw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qQr5v-0005Tm-C0
        for netfilter-devel@vger.kernel.org; Tue, 01 Aug 2023 17:15:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] iptables-restore: Drop dead code
Date:   Tue,  1 Aug 2023 17:15:16 +0200
Message-Id: <20230801151517.15280-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Handle initialization is guarded by 'in_table' boolean, so there can't
be a handle already (because the branch which unsets 'in_table' also
frees the handle).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index f11b2dc2fd316..530297383d50b 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -223,8 +223,6 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 				}
 				continue;
 			}
-			if (handle)
-				cb->ops->free(handle);
 
 			handle = create_handle(cb, table);
 			if (noflush == 0) {
-- 
2.40.0

