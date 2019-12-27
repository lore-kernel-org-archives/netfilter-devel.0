Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19126C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16B820CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469477;
	bh=J0cPKhFxQCuZu+uLL9G/eNDy4tjEa8vlQ6PtGjaXh5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lfhgP2S2A0PQNF0duwv1gmTiwqpyzTSsCK1FW7fo4GZi4OQv/SN+02ZmoDgL/suhd
	 NDSRV/QgGHpc1Swlu0noFZy/vP4t+tcCdTeL9e91axmWZW85lE8kHZQpIlFTMABnmP
	 I2D/7p1tPpIlkJojHJjg7MASnnJihm5NEUBlDzPY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfL0Rlk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfL0Rli (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1017222C2;
        Fri, 27 Dec 2019 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468497;
        bh=J0cPKhFxQCuZu+uLL9G/eNDy4tjEa8vlQ6PtGjaXh5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riuEwbA+La0oSejcZQfZ8yWQO1PIIfkUWNebBQsf5fNP7pfmseA117B45jFDv6vhy
         +zJ2P2OKfFzBXEIqdcTCRxv7nvLU+Qhmf0whfeoJw5vFw6KDBEY2urV/XhUU0rsotC
         tpZYmVUPs7GcoHrbehIc8hhmY/71aF03FX8ZBAwQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH AUTOSEL 5.4 032/187] netfilter: uapi: Avoid undefined left-shift in xt_sctp.h
Date:   Fri, 27 Dec 2019 12:38:20 -0500
Message-Id: <20191227174055.4923-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
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
index 4bc6d1a08781..b4d804a9fccb 100644
--- a/include/uapi/linux/netfilter/xt_sctp.h
+++ b/include/uapi/linux/netfilter/xt_sctp.h
@@ -41,19 +41,19 @@ struct xt_sctp_info {
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

