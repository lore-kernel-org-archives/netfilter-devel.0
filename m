Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A22C001B0
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jul 2023 12:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjGOM75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jul 2023 08:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGOM74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jul 2023 08:59:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C462835B5
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jul 2023 05:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YVTUjoQkv8xbpIFm86ChKMsZrBIDmn4NS10rYp+sOrc=; b=Q48Uq2/0BgK/uQ+vf/FphejnZG
        B31ubgUHBkIxOka4UPUQlVrP5eBQLMZsQ+ybCTk7zv+tN1iL+51VmKGu3GJTp1YKESBhWjlxsjeTU
        zRpfofBd+qe4qNYiZUYg6K9TcVZ51H8311VhaV+ariTq3lPfJrmVp9bidFoI/PJHf3qgyieI9F4hD
        i3lCpKBrSDPMXViFd9MLcbdfxxbshaP2qaOwCrVWMG2Xe3XcLjYa/a7wnh652mXlKSup+u4smGC/s
        1CZA9u2RSg3RitEC2RBOLUxj1NeRzl8wx4Us2DMw6T54JHtCnkkYlcrcZWNwOxK7hg71QEFTNFBo5
        /F090BDg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qKesL-0002NZ-Ir; Sat, 15 Jul 2023 14:59:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
Subject: [iptables PATCH 3/3] nft: Include sets in debug output
Date:   Sat, 15 Jul 2023 14:59:28 +0200
Message-Id: <20230715125928.18395-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230715125928.18395-1-phil@nwl.cc>
References: <20230715125928.18395-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rules referencing them are incomplete without, so add debug output on
the same level as for rules.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 10 +++++++++-
 iptables/nft.c       |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 76e99adcb8566..fabb577903f28 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -417,6 +417,7 @@ static int set_fetch_elem_cb(struct nftnl_set *s, void *data)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nft_handle *h = data;
 	struct nlmsghdr *nlh;
+	int ret;
 
 	if (set_has_elements(s))
 		return 0;
@@ -425,7 +426,14 @@ static int set_fetch_elem_cb(struct nftnl_set *s, void *data)
 				    NLM_F_DUMP, h->seq);
 	nftnl_set_elems_nlmsg_build_payload(nlh, s);
 
-	return mnl_talk(h, nlh, set_elem_cb, s);
+	ret = mnl_talk(h, nlh, set_elem_cb, s);
+
+	if (!ret && h->verbose > 1) {
+		fprintf(stdout, "set ");
+		nftnl_set_fprintf(stdout, s, 0, 0);
+		fprintf(stdout, "\n");
+	}
+	return ret;
 }
 
 static int fetch_set_cache(struct nft_handle *h,
diff --git a/iptables/nft.c b/iptables/nft.c
index f453f07acb7e9..b702c65ae49aa 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2975,6 +2975,12 @@ static void nft_compat_setelem_batch_add(struct nft_handle *h, uint16_t type,
 			break;
 	}
 	nftnl_set_elems_iter_destroy(iter);
+
+	if (h->verbose > 1) {
+		fprintf(stdout, "set ");
+		nftnl_set_fprintf(stdout, set, 0, 0);
+		fprintf(stdout, "\n");
+	}
 }
 
 static void nft_compat_chain_batch_add(struct nft_handle *h, uint16_t type,
-- 
2.40.0

