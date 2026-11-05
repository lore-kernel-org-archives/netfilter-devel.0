Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882749;
	b=SNh6vuWPZ72Xa9BMrfPFKm10It9Fzf33XA+ZiimVOol98W3xMbLz6EugsMDIh0z2jf9n
	 ElplqeAm9WAgDpou7gr72jB8ei7QYTxOnrcm42cMVcdk+ujHMS84mM2HuNmV1AqoAHlBK
	 0+6j9w0UDcBu7ZHYPqlg5AgqnlogKHcPb3X0ptdBuG7kp166zm/hCgj6J45LdqAKi4sNu
	 pYTB2kgZjp3vFuHD33vAyGUGjSfJGQjlvhBK3m7mG+7RwOOdFMsHQx3HeEsu3mQAgcZ+p
	 jhgLa2CUrQ7Abz6xElnNDO8yMbHIO1mMcFRcX3Lbey3qG89zgAq+004Ue+dznNHzTbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882749;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	b=BbDeXYGGB1r3s/23cH9HSjg305Yl5qCf3CUkisjyng9U69GBoPOERCwjIduJzpXpO52u
	 SraoYQgqkw93zn1tDRdSjTIhmT4pCYfqm3iEogvjBZ9pHWic5S6sIFVBXq0uquJ9iSnec
	 N4BvXi7GLPBqJzAubECNs7FjHRj2ng/xNdJA9A8yDJ3FGx1AMnbK5PwegYa1c1WBps4Ys
	 /bjjI5Od+tLmf3g3/dR5b8D+8UA+vjSIlFCVbMBMl7QzWcEDKHKzpN/Xkh1o65wcwt7S+
	 J6drxgYjyKDhygaPlXasaQLokdpGRLtZ+xXIo332UyAqX6pU2Qj95Aq0s7YPKYqY78w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DGsMmcdH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88212606D816;
	Thu,  5 Nov 2026 12:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88212606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DGsMmcdH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882746;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGsMmcdHoKL8xVHG8+kp8ClMp8MkqdFzmUiSJJDQJfHjj68lC/Mkmg2M7EfsbRYc8
	 PesgJpNGAhjpysoZoXxHXXT9OV12St377FffBejUvaLMvRrrMG9UY1/3xz717Ysk2v
	 PwUu9+3pL8hzi05/4foZwBfg0Gaw3iYcA5jh8oXBLWY8YtOwFxDTpcVKat2acT25+L
	 aJeXxfzkvNHCqvBp980pHjdE9iaU7vG6le+f5JkcxhNxTHn4dO19bQOrSp0zAH0HAd
	 xGlmZcvaOct5HvO7Knd7jNVyeh8PHYlYABCOb9zqlEI1ItAUD8wWxgWHf8D+UmrpPb
	 ACiQo0H9ZcJNA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 785AC60096;
	Thu,  5 Nov 2026 13:45:46 +0100 (CET)
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
Subject: [PATCH net 05/12] netfilter: flowtable: extend ct timeout of offloaded GRE flows
Date: Thu,  5 Nov 2026 13:45:29 +0100
Message-ID: <20261105124536.1009301-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

