Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846190;
	b=0W6WoFiEV72i3c/0VLB9xKV1tW42oA0pwfmt84Im++G0KTHzLJyZzABtHGjCJJXpzjeg
	 cEnZY8FqJIGTPB02spBgaxMolYTFsNSzYI3VO4eFshvqPoYuiENTmncr8mk3Hx+t0UCDK
	 hq/BsJ32nOSInMmAW+0p910jSd9DGRkeHHaQz+e33x71fQEQh1ceJEvFLL5apdIc3vWCB
	 z/42YN9XKKmprNDTg4huMFqQBP2QqU4PUoja8bClaptRrp8rENJn0N6nvkuu9UTx023CG
	 luLmv4XTWEygA0JBAVcRqcIuGYx8UGUp5r1zOu35Lvy5yJI339BbCh2TjrpsOTWfsKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846190;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=7vj/4hXgvEWT2AGbUwrxEeLTW7Q6LVveos1KAIoI6t0=;
	b=PUaUdiKRf6JU/1WZsH4uOUzFXq1I7D5wBSfc85vFZINXncG7qxtTLTsztS+LVB6NH50j
	 gGoaokVjxN2Dj3xssAeERPUcQZZS5Y7m5uODEqkK7cwblEa3qxB6Zd3+c+67EF4DwoH1n
	 Ls910HexfES9FSGp4PHZXKPoqH5iFdL1+07tNO5GBkkJWEEc6u1qCtwTTo78c1wbXwgCZ
	 moUPG817xmCdF/ECbTmGBUkStMF89kFRfzhoiHiplHVxsuze5bVy60U9E+tqK9e3eiwTU
	 QJxk/zu0sRSg6EEqnTSoKrb2wlyYIFF1/DwNXD9Gvup/moSjIS2fvChIY9qpxPXx+Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.133
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0B4606A31A;
	Sat, 24 Oct 2026 12:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA0B4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue010
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1Mw99Y-1wSdcZ1H2C-017yL6; Sat, 24
 Oct 2026 14:49:27 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.15.y] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 24 Oct 2026 14:49:26 +0200
Message-ID: <20261024124926.5225-1-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
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
X-Provags-ID: V03:K1:slqLUBbhv6J6uJuY/0btQx6LKieAcblqn156FzIZBUkacf9Pmnf
 2rbDJujz7J2heBEPfM19kaEiK5ftLJeYXHayPe2MH3ie8pUde+7XHZKCb8R4QeDO7YBCVC1
 V9Cnmmc4QgTsa/TXm9QiYBChvADo2JQnOspN3Jj4lEpktQ+4QRHuXWxLVUhN1ItOD8xWL3U
 Vp3DvQk4Lwj0WRz3S5lBw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AxhvELT2CUk=;UBSsQ2Qwg3ZPTyHIudJsm9QSYXv
 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

From: Inseo An <y0un9sa@gmail.com>

[ Upstream commit 71e99ee20fc3f662555118cf1159443250647533 ]

nf_tables_addchain() publishes the chain to table->chains via
list_add_tail_rcu() (in nft_chain_add()) before registering hooks.
If nf_tables_register_hook() then fails, the error path calls
nft_chain_del() (list_del_rcu()) followed by nf_tables_chain_destroy()
with no RCU grace period in between.

This creates two use-after-free conditions:

 1) Control-plane: nf_tables_dump_chains() traverses table->chains
    under rcu_read_lock(). A concurrent dump can still be walking
    the chain when the error path frees it.

 2) Packet path: for NFPROTO_INET, nf_register_net_hook() briefly
    installs the IPv4 hook before IPv6 registration fails.  Packets
    entering nft_do_chain() via the transient IPv4 hook can still be
    dereferencing chain->blob_gen_X when the error path frees the
    chain.

Add synchronize_rcu() between nft_chain_del() and the chain destroy
so that all RCU readers -- both dump threads and in-flight packet
evaluation -- have finished before the chain is freed.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Signed-off-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.15.y: 5.15 lacks d472e9853d7b ("netfilter: nf_tables:
  register hooks last when adding new chain/flowtable"), so the hooks are
  registered before the chain is added to table->chains and there is no
  err_register_hook label. A failing nf_tables_register_hook() can still
  have exposed the chain to the packet path through a transiently
  registered hook (the IPv4 hook of an inet chain when the IPv6 hook
  fails to register), so call synchronize_rcu() before the chain is
  destroyed on that path. This mirrors how the 5.15.y backport of
  d73f4b53aaae handles the same situation for flowtables. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
Not a clean cherry-pick (see the bracketed note): 5.15 registers the
chain hook before adding the chain and has no err_register_hook label,
so the synchronize_rcu() is placed in the hook-registration failure
branch. A review from the netfilter side would be welcome.

Build-tested on arm64; boot-tested under QEMU with KASAN: nf_tables
chain add/list/delete across families works, ruleset flush is clean,
no KASAN reports.

 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5273255b738..06e93bb1efef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2421,8 +2421,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	rcu_assign_pointer(chain->rules_gen_1, rules);
 
 	err = nf_tables_register_hook(net, table, chain);
-	if (err < 0)
+	if (err < 0) {
+		synchronize_rcu();
 		goto err_destroy_chain;
+	}
 
 	if (!nft_use_inc(&table->use)) {
 		err = -EMFILE;
-- 
2.50.1 (Apple Git-155)

