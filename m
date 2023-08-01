Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81856C41513
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 15:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjHAPDO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 11:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjHAPDN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 11:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A86E1;
        Tue,  1 Aug 2023 08:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7885E615E2;
        Tue,  1 Aug 2023 15:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8CAC433C8;
        Tue,  1 Aug 2023 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690902190;
        bh=GiTJrXK18Hf7JC/NN63VbVrZqz6m5Mt87YaCCE2Kras=;
        h=From:To:Cc:Subject:Date:From;
        b=GbnjVZfsyD+ZTwfKhOPI7Eiy+YHOeoIx68o/1/CElqyruzLDcXSZpSbT6qKOChI7f
         3P6aIc51SqA4j5oceeXwpAvX541FvpbFm6NqVARzDYQLAWbk50hT44l4s789wz2JFI
         FrfbFrj6mTS3bx4PNO8GHUkVovysLIKl9fVRCO02XzEskDrld0BNi4ZFBoZgonfm9N
         TFzS8kuReBYN0Dj+FJbIMpHLW2eFRwgKOUDnvVNjExhzX2Rm4s6M7pFFHQlvgqe9uX
         4YqdgcQ3oTmjpa4A8PNY3UE52yObqfmh/CE4WjIekv69BsvZhQzaR8+wp82Hbsxji/
         n5ApBF52jzYJw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] netfilter: bpf_link: avoid unused-function warning
Date:   Tue,  1 Aug 2023 17:02:41 +0200
Message-Id: <20230801150304.1980987-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The newly added function is unused in some random configurations:

net/netfilter/nf_bpf_link.c:32:1: error: 'get_proto_defrag_hook' defined but not used [-Werror=unused-function]
   32 | get_proto_defrag_hook(struct bpf_nf_link *link,
      | ^~~~~~~~~~~~~~~~~~~~~

Change the preprocessor conditionals to if() checks that the
compiler can understand to avoid the warning.

Fixes: 91721c2d02d3a ("netfilter: bpf: Support BPF_F_NETFILTER_IP_DEFRAG in netfilter link")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nf_bpf_link.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 8fe594bbc7e24..6028fd4c1ab4c 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -74,24 +74,26 @@ static int bpf_nf_enable_defrag(struct bpf_nf_link *link)
 	const struct nf_defrag_hook __maybe_unused *hook;
 
 	switch (link->hook_ops.pf) {
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	case NFPROTO_IPV4:
+		if (!IS_ENABLED(CONFIG_NF_DEFRAG_IPV4))
+			return -EAFNOSUPPORT;
+
 		hook = get_proto_defrag_hook(link, nf_defrag_v4_hook, "nf_defrag_ipv4");
 		if (IS_ERR(hook))
 			return PTR_ERR(hook);
 
 		link->defrag_hook = hook;
 		return 0;
-#endif
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	case NFPROTO_IPV6:
+		if (!IS_ENABLED(CONFIG_NF_DEFRAG_IPV6))
+			return -EAFNOSUPPORT;
+
 		hook = get_proto_defrag_hook(link, nf_defrag_v6_hook, "nf_defrag_ipv6");
 		if (IS_ERR(hook))
 			return PTR_ERR(hook);
 
 		link->defrag_hook = hook;
 		return 0;
-#endif
 	default:
 		return -EAFNOSUPPORT;
 	}
-- 
2.39.2

