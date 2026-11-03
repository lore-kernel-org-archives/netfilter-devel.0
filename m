Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714610;
	b=jjcFJEPjr9HbcDUBLZT4iLA6bYYDBPLlWlafbciCO0vR39mXWVqmDbgBQEZaoxassaqD
	 5qyVUnjgUy0A18PBWwugmwmszOj/qg4Ck9aa7HebmADFsvxgfoqitOFJdAacmhKosbA9u
	 u/Jt63zsD74OaID7yxNRVZun9M3DJ9YGgBDJ/NAzzoo6RcNGIv0OmRB29pfkzEvzb+0dH
	 XLB+qGRAtymVsjr4Zcb5w8U5Z0wN/yyJOzjcy012rmzzB6GOYAIURmln7fT+2CgDtrjlu
	 064SPjj2JbxOxbch5aJP7dPKLIplggcarHnoOU0bo/8s/xB+wJzg8hHf60Rf0qn/EqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714610;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	b=Gapji+jccrGCxXqCv9chpcY0HDjfBQNWX6NQ/JK5Np/SKmD3QyihtHVscxfGkInzEYFc
	 nz+b/eLCQ1HqxbZzFUJBBxlptvD4mIpBqWSsEzqlGWXt+LZ1hJTMEq5ttLPXnGBBf9oLI
	 rjD1ygOA+xWr0+9zQ5hYacmxrqb/07Sh3//pfIycPiyIcKOdQpedvukVDWL2k2FLxV/sm
	 ycz74ikZCBgoR+WKNZcgD5Bt/bAzFIY26RGUg6G2zzyo8ZquKxyz6RAkN3U1vetGEGN2d
	 SbyV30wp1w0RrvwNKSpulYT6BAJOtHJ6XfgT7aaoFvQty/6VcUyPAva5LlsVsPpVqSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tXIME0Bj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B016083638;
	Tue,  3 Nov 2026 14:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91B016083638
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tXIME0Bj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714608;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXIME0Bjp+4xYzyToycyoUIOI9xCtalvjRntTiLIb6XNaKa28bTP0Csqpo4xnU4ZA
	 PzX6cbQuowGPPBysv3aVpOPt67dxHODSebJ8z6B4apRL0YXZ8izFYBawGCMJr+O1QJ
	 vk7SBV7ToM3S0JKlsLM0NpFdmONEATOkpgbqIrQ4bJ3AvXKdA9Q8kGoPX+r/hc4idC
	 jFkkqnEFwfLQ+Jp2PLtj60L4iZieirRS9bVFuw4Gz3aDmsVQg5N6/lurHvWdJdf5Aq
	 pu/Q1NXQjyKs25rBMJiHWOBJ5vKRmCA9hEVstwQrgUl+XH3ENXaH9QI+tV6YERQLEA
	 6yMaRISqmn7TQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5FBB460085;
	Tue,  3 Nov 2026 15:03:27 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/15] netfilter: flowtable: extend ct timeout of offloaded GRE flows
Date: Tue,  3 Nov 2026 15:03:01 +0100
Message-ID: <20261103140308.591690-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

Since commit 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn
timeout extension logic"), the flowtable gc worker extends the timeout
of an offloaded conntrack entry from nf_flow_table_extend_ct_timeout()
once it falls below 5 minutes. That function only knows about TCP and
UDP and hits WARN_ON_ONCE() for any other layer 4 protocol. However,
GRE flows can be offloaded too, both via nft_flow_offload and act_ct,
since commit 4e8d9584d154 ("netfilter: flowtable: Support GRE").

The timeout of an offloaded GRE entry drops below that threshold as soon
as a packet of the flow still goes through conntrack. With ip6gre
tunnels using the default encapsulation limit this is ordinary traffic:
the flowtable does not parse the Destination Options header in front of
GRE, so every packet of the flow takes the classic forwarding path. It
also happens for a packet with ttl <= 1, which the flowtable fast path
passes up to the classic forwarding path. nf_conntrack_gre_packet() then
refreshes ct->timeout to the GRE stream timeout (180 seconds by default),
and the next gc run triggers, as reported by syzbot:

  WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_table_extend_ct_timeout+0x1ee/0x2f0
  Workqueue: events_power_efficient nf_flow_offload_work_gc
  Call Trace:
   nf_flow_offload_gc_step+0x545/0x7b0
   nf_flow_table_iterate+0x13c/0x1f0
   nf_flow_offload_work_gc+0x22/0x70
   process_scheduled_works+0xc3d/0x1630
   worker_thread+0xa47/0xfb0
   kthread+0x38b/0x480

Besides the splat, which panics the machine with panic_on_warn, the
default branch sets the new timeout to 1 jiffy, so the conntrack entry
expires right away and the offloaded flow is torn down.

Handle GRE like UDP and extend the timeout to NF_CT_DAY. GRE conntrack
has no protocol state to take into account, and NF_CT_DAY is also what
flow_offload_add() already sets for every offloaded entry, GRE included.
This also restores the behaviour from before commit 03428ca5cee9, when
the conntrack gc worker extended offloaded entries of any protocol to
NF_CT_DAY.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Reported-by: syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=521f7e7e2b974abde99a
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a..2aa2647ed9df 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -544,6 +544,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
+		case IPPROTO_GRE:
 			new_timeout = NF_CT_DAY;
 			break;
 		case IPPROTO_TCP:
-- 
2.47.3

