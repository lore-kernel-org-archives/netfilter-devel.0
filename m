Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5DCC7EE2F
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjE1TPZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjE1TPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5697C4;
        Sun, 28 May 2023 12:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5831761985;
        Sun, 28 May 2023 19:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760DFC4339B;
        Sun, 28 May 2023 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301322;
        bh=qCM25N3wd9PFEAHJJI4BiACDhPBqY00Ba2+BKVg653E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHlp07ZIHHuAjgpK1e8tcoq7izMvP8Kjw56nqrkndSTRHpBEmhwux72coHuDn0h+F
         YrsxFbKh50U6Ei2a3Z9fia4RnNY4vOOfMHTrmVx14NkHaV2IilGGzQgBsvewCzOLG/
         iln2GDusr4e1ZbwKNu1v6/CxIkR0GNQVenIXUXI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 4.14 70/86] netfilter: nf_tables: fix register ordering
Date:   Sun, 28 May 2023 20:10:44 +0100
Message-Id: <20230528190831.237501132@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ d209df3e7f7002d9099fdb0f6df0f972b4386a63 ]

[ We hit the trace described in commit message with the
kselftest/nft_trans_stress.sh. This patch diverges from the upstream one
since kernel 4.14 does not have following symbols:
nft_chain_filter_init, nf_tables_flowtable_notifier ]

We must register nfnetlink ops last, as that exposes nf_tables to
userspace.  Without this, we could theoretically get nfnetlink request
before net->nft state has been initialized.

Fixes: 99633ab29b213 ("netfilter: nf_tables: complete net namespace support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[apanyaki: backport to v4.14-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6105,18 +6105,25 @@ static int __init nf_tables_module_init(
 		goto err1;
 	}
 
-	err = nf_tables_core_module_init();
+	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		goto err2;
 
-	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	err = nf_tables_core_module_init();
 	if (err < 0)
 		goto err3;
 
+	/* must be last */
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err4;
+
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
-	return register_pernet_subsys(&nf_tables_net_ops);
-err3:
+	return err;
+err4:
 	nf_tables_core_module_exit();
+err3:
+	unregister_pernet_subsys(&nf_tables_net_ops);
 err2:
 	kfree(info);
 err1:


