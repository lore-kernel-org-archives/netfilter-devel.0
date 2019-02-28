Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7114C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A70BF20C01
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367792;
	bh=GANYQMmRV03+mlWdKJI4olu/VHaSWEiOWhSRTQkJaUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W/FaODTIppBNId3aJF4QCfqSW/B9pjkRgOG1WiASoVN1Zolfqw7iw2GczUhPcmXjI
	 j0uT3UcqUmpj+1OD0zU/EKYzr3I39qJX6uHniY0y2DePkE8ha59IzCV9GR/y+gRTT7
	 l96A8RRP/EAj0cDHD2VZ1vB92M8dcPpAWDQwzrWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387686AbfB1PKW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbfB1PKV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:10:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 158C2218C3;
        Thu, 28 Feb 2019 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551366620;
        bh=GANYQMmRV03+mlWdKJI4olu/VHaSWEiOWhSRTQkJaUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXmO+g8YQmww+RTyjHQeStqN2Rvzmpwfvxn76ekbwj/dR75Ykf1EaZ5T/MvA0pF8W
         dufJS2ZSVv8LORelia3DPcWduePU68kRP99Up0dF/2LTtKTN3hOzj0MdUuG/GGCDlU
         QRFZW8RfOuXS/HLpmUsksHILMKM+wddZeglWgWE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martynas Pumputis <martynas@weave.works>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 59/81] netfilter: nf_nat: skip nat clash resolution for same-origin entries
Date:   Thu, 28 Feb 2019 10:07:51 -0500
Message-Id: <20190228150813.10256-59-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190228150813.10256-1-sashal@kernel.org>
References: <20190228150813.10256-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Martynas Pumputis <martynas@weave.works>

[ Upstream commit 4e35c1cb9460240e983a01745b5f29fe3a4d8e39 ]

It is possible that two concurrent packets originating from the same
socket of a connection-less protocol (e.g. UDP) can end up having
different IP_CT_DIR_REPLY tuples which results in one of the packets
being dropped.

To illustrate this, consider the following simplified scenario:

1. Packet A and B are sent at the same time from two different threads
   by same UDP socket.  No matching conntrack entry exists yet.
   Both packets cause allocation of a new conntrack entry.
2. get_unique_tuple gets called for A.  No clashing entry found.
   conntrack entry for A is added to main conntrack table.
3. get_unique_tuple is called for B and will find that the reply
   tuple of B is already taken by A.
   It will allocate a new UDP source port for B to resolve the clash.
4. conntrack entry for B cannot be added to main conntrack table
   because its ORIGINAL direction is clashing with A and the REPLY
   directions of A and B are not the same anymore due to UDP source
   port reallocation done in step 3.

This patch modifies nf_conntrack_tuple_taken so it doesn't consider
colliding reply tuples if the IP_CT_DIR_ORIGINAL tuples are equal.

[ Florian: simplify patch to not use .allow_clash setting
  and always ignore identical flows ]

Signed-off-by: Martynas Pumputis <martynas@weave.works>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e92e749aff53e..830b1328fe975 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1007,6 +1007,22 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		}
 
 		if (nf_ct_key_equal(h, tuple, zone, net)) {
+			/* Tuple is taken already, so caller will need to find
+			 * a new source port to use.
+			 *
+			 * Only exception:
+			 * If the *original tuples* are identical, then both
+			 * conntracks refer to the same flow.
+			 * This is a rare situation, it can occur e.g. when
+			 * more than one UDP packet is sent from same socket
+			 * in different threads.
+			 *
+			 * Let nf_ct_resolve_clash() deal with this later.
+			 */
+			if (nf_ct_tuple_equal(&ignored_conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+				continue;
+
 			NF_CT_STAT_INC_ATOMIC(net, found);
 			rcu_read_unlock();
 			return 1;
-- 
2.19.1

