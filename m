Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782965;
	b=ggNExkxyIB0jadWmS6g3gp5GoQQPVjcL66u/AXQeqivto9FkIdDqA/Wj0RLoWU7I406a
	 O6GmH9bRFO6lYGwCkSnuv/Z/zrQpoAD6HiDmdtDOEajNSnrXAmLIrKN/fh1IFDVipEV7r
	 pggvdtCOpH4QqaXa+CN0lyJHigVPkWZ0iCxzYnB1r+WeOO1SwWNSDuvhW1k0aLHUxDT88
	 lgTtl/NVYy/0whzgeYLahvKsxd5N/FEwlZBqCdtbvpg+QEGDgNYBf5dYsfxYwEPaYBwG2
	 cGrRKlfUEd0qYC3c76QsLCsFym3aIMo+TabQu1PiuOtMgdYqfHOjlkGLzGk4T79tvkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782965;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	b=GIHVUrj6a1RQNQnHdr6tnj8zFFeHNhOTy5oFEuTlEQwuwYeBpsz8fXBhw58YmUb0LzJi
	 maD1oGcADk0Ea2GVkw4GmmYHWn604caKKzXX6D6ASXF83X4JjLABBdfCfEO166SL52+SH
	 SjyeDs4BnCv5g6mceARG32/ubE74MdZztEUbXMhBeikenuRH8F0yHomHR1X6LTUkyB9gX
	 hq+nVsxGqcbaSbbeJV6oYRBjMMDYZIvlA1V1URcXh56E5ykQ//r95KFE6kBInqJSP0xwZ
	 hHOsx/HJiJNozTOwhzbaM0oCXqg1mMUMFcHuxfb0j7GaIAqjEWtJvbyuLScM+f10x3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="mQG/ez5l";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F37B606D809;
	Wed,  4 Nov 2026 09:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F37B606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mQG/ez5l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782961;
	bh=fo470PP63+10tqzrhqq++24kquyeboFFql2psSvwEeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQG/ez5l9f26ELd63jWzdmRLlOg2dE51Uz53xms2wueMoMflbFKo4KjNA9yrplQ6X
	 gfCFbP1UX5GP8O/fkzJI1FI59KbFyGnHVAxAwHYSYJdQU/yalprmBd/mskFzVtD3vS
	 BMwp4tvlLokGo4MLsKnOXgT9pC2MNZWzXBknpEo23GRvDpSy25Lk6psLzXkeWVoZKc
	 yxNTkVS6CelpcaQTryKJQon2VraN0b77l01ojMBipOoq4C/pi0AMc+f4JAQVH4CtA8
	 6W/jChJmT2v3a1UVIctgHez5xcsh+8dI5WyO1xxN2DKaTzhwyqa2VvpyjJC4Hsi5/m
	 /0GICjGwuUhoQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BEAE76008C;
	Wed,  4 Nov 2026 10:02:40 +0100 (CET)
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
Subject: [PATCH net 06/13] netfilter: flowtable: extend ct timeout of offloaded GRE flows
Date: Wed,  4 Nov 2026 10:02:17 +0100
Message-ID: <20261104090224.750548-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

