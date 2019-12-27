Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CC2C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 18:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4875121775
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577470489;
	bh=lTg5GAODvTblUNGEeU/zAHWtWfxOlrGH8S10r5uIj24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AXngX8iiEbOtsfDAC3VwuzCk8BolOQJLUuore9d1nLXnvra+c91u7oUpkomDRFc9B
	 16yukFnNm8MbMPg1JLG5A05Lqs0EpR2hgQtC5Iii+nUvIk6tNuWngQhUCEqbYOqi3h
	 P/VXM3lmbKO2tSqD7aj9RzUS9NQVXP8lop2522kQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfL0SOs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfL0SOr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 13:14:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3256C21775;
        Fri, 27 Dec 2019 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470486;
        bh=lTg5GAODvTblUNGEeU/zAHWtWfxOlrGH8S10r5uIj24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVxlsYJV6UQvFBl8jWCqkNtYY202ZlwRj5jKGSlYK3ZoqqoIcq0RnwwrTT9Sk1z9N
         2F6mvdSoUH76lmnb/mm8cR8n0JTLuvC/HyGZB6UmNu4TUCMXxA9LlxyPuxXAlY9TV0
         kStL648m+nifIcz0wNXaBhOo5Uz9pIMEkO8dLo1E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.9 08/38] netfilter: uapi: Avoid undefined left-shift in xt_sctp.h
Date:   Fri, 27 Dec 2019 13:14:05 -0500
Message-Id: <20191227181435.7644-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 164166558aacea01b99c8c8ffb710d930405ba69 ]

With 'bytes(__u32)' being 32, a left-shift of 31 may happen which is
undefined for the signed 32-bit value 1. Avoid this by declaring 1 as
unsigned.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_sctp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_sctp.h b/include/uapi/linux/netfilter/xt_sctp.h
index 58ffcfb7978e..c2b0886c7c25 100644
--- a/include/uapi/linux/netfilter/xt_sctp.h
+++ b/include/uapi/linux/netfilter/xt_sctp.h
@@ -40,19 +40,19 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
 		(chunkmap)[type / bytes(__u32)] |= 	\
-			1 << (type % bytes(__u32));	\
+			1u << (type % bytes(__u32));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
 		(chunkmap)[type / bytes(__u32)] &= 		\
-			~(1 << (type % bytes(__u32)));	\
+			~(1u << (type % bytes(__u32)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
 	((chunkmap)[type / bytes (__u32)] & 		\
-		(1 << (type % bytes (__u32)))) ? 1: 0;	\
+		(1u << (type % bytes (__u32)))) ? 1: 0;	\
 })
 
 #define SCTP_CHUNKMAP_RESET(chunkmap) \
-- 
2.20.1

