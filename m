Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E02BC10F0B
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F03E206B8
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367216;
	bh=STwgZ71JiIHnrqxcauUnRhITt+r5/YLxN4LvvIz6lOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Dx+H3ZwZ7mZ24wrkSH1cblttfgQPc75R3kp1wNgDOyT5KohcDaxhz37EANjqDheIp
	 4Vo652Zkw9FMv6LxFQXdVLKuP7b58buN3y8ZV7m4EyPbpsWq72tBWAdU4N8OwXMVO5
	 zfg9/n1B7oF3UuQp63k71PwcqZCl01zHBoPBw3KQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbfB1PUN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388319AbfB1POv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:14:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B360D2184A;
        Thu, 28 Feb 2019 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551366890;
        bh=STwgZ71JiIHnrqxcauUnRhITt+r5/YLxN4LvvIz6lOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB/xeeGZKQpvBRJc0xLvdMtmQ8HQDvmLq8ofIFR27aApaFHhQBLrbdqGcc1rQGK0u
         h+2KgVaIktKphtSRUZnVGOIBggixY8+PWOj5FuElkMhaBHFTYo8SN/AHMpWFtkTASi
         aAF0tzIjbnTjv3gasA/p4QxHOQJxfEb1oVtqtdjk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martynas Pumputis <martynas@weave.works>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 27/36] netfilter: nf_nat: skip nat clash resolution for same-origin entries
Date:   Thu, 28 Feb 2019 10:13:28 -0500
Message-Id: <20190228151337.12176-27-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190228151337.12176-1-sashal@kernel.org>
References: <20190228151337.12176-1-sashal@kernel.org>
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
index b793b55d14885..f07357ba96299 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -869,6 +869,22 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
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

