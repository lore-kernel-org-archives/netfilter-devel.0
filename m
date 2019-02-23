Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3D3C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F67820661
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957523;
	bh=VUKeMSV75Rz9V5KKmRvEDog5lDNxkXc5ddb8aNs6viE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h6VsxCAAGQ3HpFKy27qg2G7cweMNJoKcrN747IA7tcn2HI+kIlg7AWgNlTnMdJIQy
	 wBRNrZNFy7pKzLA5pqublNa3SpWGUMp04vySif1Teki2KTwLcy6lQXl9JEGP5H/1Qb
	 P5ruxm3YHe4tCC5hC1pKnzLix90h2YlKL0M/1Bys=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbfBWVcC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbfBWVF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:05:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23AB20855;
        Sat, 23 Feb 2019 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550955928;
        bh=VUKeMSV75Rz9V5KKmRvEDog5lDNxkXc5ddb8aNs6viE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6Y079ma5y1QEDRvpNFxaPpkgCQmL8F7jxyrocKBy+9QbHSeKvxDNQTjo3FJACxuW
         6Xz3SukE9INxyAs8kyCP4e4bfh4+0x+Cai6T0ADjPjQAVTqrj5880K9J990D85cvhT
         u9jysXIXkRvMndoNqrls03IfapbD/eSBqljAGEDU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 38/72] netfilter: nfnetlink_osf: add missing fmatch check
Date:   Sat, 23 Feb 2019 16:03:48 -0500
Message-Id: <20190223210422.199966-38-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210422.199966-1-sashal@kernel.org>
References: <20190223210422.199966-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 1a6a0951fc009f6d9fe8ebea2d2417d80d54097b ]

When we check the tcp options of a packet and it doesn't match the current
fingerprint, the tcp packet option pointer must be restored to its initial
value in order to do the proper tcp options check for the next fingerprint.

Here we can see an example.
Assumming the following fingerprint base with two lines:

S10:64:1:60:M*,S,T,N,W6:      Linux:3.0::Linux 3.0
S20:64:1:60:M*,S,T,N,W7:      Linux:4.19:arch:Linux 4.1

Where TCP options are the last field in the OS signature, all of them overlap
except by the last one, ie. 'W6' versus 'W7'.

In case a packet for Linux 4.19 kicks in, the osf finds no matching because the
TCP options pointer is updated after checking for the TCP options in the first
line.

Therefore, reset pointer back to where it should be.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 6f41dd74729d9..1f1d90c1716b5 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -66,6 +66,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 			     int ttl_check,
 			     struct nf_osf_hdr_ctx *ctx)
 {
+	const __u8 *optpinit = ctx->optp;
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
@@ -155,6 +156,9 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		}
 	}
 
+	if (fmatch != FMATCH_OK)
+		ctx->optp = optpinit;
+
 	return fmatch == FMATCH_OK;
 }
 
-- 
2.19.1

