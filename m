Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C07C04AA5
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Aug 2022 11:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiHYLXi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Aug 2022 07:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbiHYLXh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2022 07:23:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269A3AF0D6
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2022 04:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5wy6AdcKq8dMuU8jPEEku0k/T+rJMdzhgMjpXJRZETk=; b=APSAWihNHwqaLSTsmTNTsL8h9U
        84G/NDZOePvSVOa07WKRrPcn0q2CNM5yK0IksRT6w5TQApRM0CxZZPEsXEAu1gCxK2Rm/rLdhL3VD
        Wc3QR/Iad4KIflzQgIb/9oukMcHyqsk09MDop+nQ7tDDPQeYi1QJjqQ5wbv7awo2VSrMsyGN6Vnnt
        w6oAYoys7kd1GwOiswl23hAmCM1PaElLxZu6h6w5xC5x8dL9JZ1hRglwFSoLNuON0aIMbr9u37BsU
        /dAfLPEDqGHBojduW5ryWTpQmR9rPBQpntAF6QmGVbhG00YS06/1ov3ICzeOks/wnU+DTyg/NxSBx
        XuWVtBuw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oRAxR-0007KW-JV
        for netfilter-devel@vger.kernel.org; Thu, 25 Aug 2022 13:23:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-restore: Extend failure error message
Date:   Thu, 25 Aug 2022 13:23:29 +0200
Message-Id: <20220825112329.15526-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a line causes zero 'ret' value and errno is set, call nft_strerror()
for a more detailed error message. While not perfect, it helps with
debugging ominous "line NN failed" messages pointing at COMMIT:

| # iptables-nft-restore <<EOF
| *filter
| -A nonexist
| COMMIT
| EOF
| iptables-nft-restore: line 3 failed: No chain/target/match by that name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 1363f96ae0eb9..052a80c2b9586 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -249,8 +249,11 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 	    (strcmp(p->tablename, state->curtable->name) != 0))
 		return;
 	if (!ret) {
-		fprintf(stderr, "%s: line %u failed\n",
+		fprintf(stderr, "%s: line %u failed",
 				xt_params->program_name, line);
+		if (errno)
+			fprintf(stderr,	": %s.", nft_strerror(errno));
+		fprintf(stderr, "\n");
 		exit(1);
 	}
 }
-- 
2.34.1

