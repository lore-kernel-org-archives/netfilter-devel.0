Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6422BC2BB54
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 00:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 303F620768
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 00:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586217827;
	bh=JdtJsSJ3WVBLBbJeS+i+JF2aJaJCNvzsxpR2owr2CjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r1k94oaN/UlcBifFXmB8qy3LsN08KP+pXdaYWVNuyg0tzkwbuqMRiom5wHeQUO+Nd
	 4/IqyMAPoRhGqPVcxd/dcXOHtzMJgEvR+EA5IOKN0VEl6eLxx9yhGgtqi8LLgariHT
	 aOpy/yAZPRX5nTWgGMEkKqHJDC5FV2mumFY0WRUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgDGADm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgDGADJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 20:03:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457AC2078C;
        Tue,  7 Apr 2020 00:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217789;
        bh=JdtJsSJ3WVBLBbJeS+i+JF2aJaJCNvzsxpR2owr2CjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqHGkD9ol95LhRBzyTAWxlrjEbux7lStUvG5NtObupVnV4PB/r8yfA1/MTVUkNgBg
         jBylc9UHUSF31/6VB+EVNp6m+ihyzDZb4JvapP3//m3D4ni8ROi2kSaO2uWsuSMt8Q
         +yesNUMGLAi37uKg3Ktz/H4IeW3fh64W7btTs6go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/5] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
Date:   Mon,  6 Apr 2020 20:03:02 -0400
Message-Id: <20200407000304.17360-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000304.17360-1-sashal@kernel.org>
References: <20200407000304.17360-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8c2d45b2b65ca1f215244be1c600236e83f9815f ]

Currently, the -EEXIST return code of ->insert() callbacks is ambiguous: it
might indicate that a given element (including intervals) already exists as
such, or that the new element would clash with existing ones.

If identical elements already exist, the front-end is ignoring this without
returning error, in case NLM_F_EXCL is not set. However, if the new element
can't be inserted due an overlap, we should report this to the user.

To this purpose, allow set back-ends to return -ENOTEMPTY on collision with
existing elements, translate that to -EEXIST, and return that to userspace,
no matter if NLM_F_EXCL was set.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2fa1c4f2e94e0..d9b448ed9a47c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3642,6 +3642,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				err = -EBUSY;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
+		} else if (err == -ENOTEMPTY) {
+			/* ENOTEMPTY reports overlapping between this element
+			 * and an existing one.
+			 */
+			err = -EEXIST;
 		}
 		goto err5;
 	}
-- 
2.20.1

