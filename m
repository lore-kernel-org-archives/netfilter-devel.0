Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB8BC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiK3TOk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3TOj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:39 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4425E9E8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5eVUrLt8Js/WyzfNAEmZd6kVg2Ltqwp9NwzpliUiKvU=; b=niPc19bQPCfK++hOkrtPTBLNho
        t8jleg4RLtaTUE4FfWazGD0+ZoEQMDkUjjPaL3XbWSj/9u7/47ch+lPONEXkCewkkkXyqICW+uAr0
        Nf1wmo9DflP46OP3CjOVqQvYQO5sTdFKuLX/XtHjQrLZ3w0sSr2ovwJIaDaVrpiX4PLT6r8rkebyq
        pct6/igXYg7cUdieTxeSwFQTgmRQm32GdzZ6/8cb3gAcLEEDv94tPeFVHQnQzvxKi5R9uj0ZqTpbe
        B0LKAvD+82n98vv7li1tzWF/kVqjXAqstl2UnFNMzCXbqsjRZHJOKrfeMSjOXhkOVrEe3gNF+scub
        HJO8giag==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SXV-0001C8-3V
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/9] iptables-restore: Free handle with --test also
Date:   Wed, 30 Nov 2022 20:13:38 +0100
Message-Id: <20221130191345.14543-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running 'iptables-restore -t', valgrind reports:

1,496 (160 direct, 1,336 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
   at 0x48417E5: malloc (vg_replace_malloc.c:381)
   by 0x4857A46: alloc_handle (libiptc.c:1279)
   by 0x4857A46: iptc_init (libiptc.c:1342)
   by 0x1167CE: create_handle (iptables-restore.c:72)
   by 0x1167CE: ip46tables_restore_main (iptables-restore.c:229)
   by 0x116DAE: iptables_restore_main (iptables-restore.c:388)
   by 0x49A2349: (below main) (in /lib64/libc.so.6)

Free the handle pointer before parsing the next table.

Fixes: 1c9015b2cb483 ("libiptc: remove indirections")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 05661bf6ceee3..6f7ddf93b01bb 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -185,12 +185,12 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			if (!testing) {
 				DEBUGP("Calling commit\n");
 				ret = cb->ops->commit(handle);
-				cb->ops->free(handle);
-				handle = NULL;
 			} else {
 				DEBUGP("Not calling commit, testing\n");
 				ret = 1;
 			}
+			cb->ops->free(handle);
+			handle = NULL;
 
 			/* Done with the current table, release the lock. */
 			if (lock >= 0) {
-- 
2.38.0

