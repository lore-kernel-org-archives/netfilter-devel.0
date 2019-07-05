Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F30C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 03:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2CE621852
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 03:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGEDdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 23:33:16 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34368 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfGEDdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 23:33:16 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 06A8844030A;
        Fri,  5 Jul 2019 06:33:11 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH libnftnl] Add Libs.private field to libnftnl.pc
Date:   Fri,  5 Jul 2019 06:32:24 +0300
Message-Id: <b121a93e89d0b9478d4e57430e98c04d490d5af2.1562297544.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>

Static linking userspace programs such as nftables against libnftnl
currently doesn't work out of the box, because libnftnl is linked
against libmnl, but this isn't expressed in libnftnl pkg-config
file:

  CCLD   nft
[...]/bfin-buildroot-uclinux-uclibc/sysroot/usr/lib/libnftnl.a(table.o): In function `_nft_table_nlmsg_parse':
table.c:(.text+0x480): undefined reference to `_mnl_attr_parse'
table.c:(.text+0x492): undefined reference to `_mnl_attr_get_str'
table.c:(.text+0x4a8): undefined reference to `_mnl_attr_get_u32'
table.c:(.text+0x4ca): undefined reference to `_mnl_attr_get_u32'
[...]

The Libs.private field is specifically designed for such usage:

From pkg-config documentation:

  Libs.private:

     This line should list any private libraries in use.  Private
     libraries are libraries which are not exposed through your
     library, but are needed in the case of static linking.

Therefore, this patch adds a reference to libmnl in the Libs.private
field of libnftnl pkg-config file.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 libnftnl.pc.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libnftnl.pc.in b/libnftnl.pc.in
index fd5cc6ac5ca4..7fef9215c888 100644
--- a/libnftnl.pc.in
+++ b/libnftnl.pc.in
@@ -12,4 +12,5 @@ Version: @VERSION@
 Requires:
 Conflicts:
 Libs: -L${libdir} -lnftnl
+Libs.private: @LIBMNL_LIBS@
 Cflags: -I${includedir}
-- 
2.20.1

