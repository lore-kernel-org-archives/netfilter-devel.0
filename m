Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B651C28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AEAA2608D
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559396256;
	bh=mpK1R3CoQOBwdpjhvFcXxrFDFhjGjyoxehuKVzq5gmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XIqvn2E7C846XIusVuZNV2NDJAnyG4XHsM80DrIvJV7RF+Lq5oQQOr6e/8E/XiX4b
	 /qoMjAqNnuskrbWFIdy+yNXjIAnuhVT4gHo/BVrsbWG1fdmEZaN10BWd3LZoegQ6Wy
	 uIkXBRVG647NIqARlpelGdwMUzXQYgoLdGzXzhVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfFANVt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbfFANVs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4082727308;
        Sat,  1 Jun 2019 13:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395308;
        bh=mpK1R3CoQOBwdpjhvFcXxrFDFhjGjyoxehuKVzq5gmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtNW328zczhimrImskhqtnd6vYadLfYSxJ7NHMdUuZI/cNsQa1ZvBC/t02b+07kYg
         ktnnjC0P9CdLq26vria6a5zG/Y6sBvb9KzgOl/A6+HynjIMT1YIanCeJEcCNs3QNBe
         misPPC03Dv4WXoDjLMIxV5tp0NFCSjCjUCYNmv3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Jankowski <shasta@toxcorp.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 065/173] netfilter: nf_conntrack_h323: restore boundary check correctness
Date:   Sat,  1 Jun 2019 09:17:37 -0400
Message-Id: <20190601131934.25053-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jakub Jankowski <shasta@toxcorp.com>

[ Upstream commit f5e85ce8e733c2547827f6268136b70b802eabdb ]

Since commit bc7d811ace4a ("netfilter: nf_ct_h323: Convert
CHECK_BOUND macro to function"), NAT traversal for H.323
doesn't work, failing to parse H323-UserInformation.
nf_h323_error_boundary() compares contents of the bitstring,
not the addresses, preventing valid H.323 packets from being
conntrack'd.

This looks like an oversight from when CHECK_BOUND macro was
converted to a function.

To fix it, stop dereferencing bs->cur and bs->end.

Fixes: bc7d811ace4a ("netfilter: nf_ct_h323: Convert CHECK_BOUND macro to function")
Signed-off-by: Jakub Jankowski <shasta@toxcorp.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 1601275efe2d1..4c2ef42e189cb 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -172,7 +172,7 @@ static int nf_h323_error_boundary(struct bitstr *bs, size_t bytes, size_t bits)
 	if (bits % BITS_PER_BYTE > 0)
 		bytes++;
 
-	if (*bs->cur + bytes > *bs->end)
+	if (bs->cur + bytes > bs->end)
 		return 1;
 
 	return 0;
-- 
2.20.1

