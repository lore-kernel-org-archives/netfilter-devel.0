Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846177;
	b=WKsLE5OsRDGRW4yhJjXtyaOOwgDf6T7dBrQ1VzwGxR2RaqqP3igyjD9BABqAqATg5zJ4
	 g1OLcgI7ghtLxzXupbPmX37sf7oAuG20tIuE0ZJx2qLeHVr35+q0T4G6Ipt7brsdptWot
	 QLxAomdWG4sY9Ihjp7yTkrKNI6hM4cafhWAnuCz5ZiKlHGvDE+OFFyj+WThyr+iLHIjSb
	 p3kgxnAMPFWnFxmWvzMwuA9VKsitnBlWSg29fKSks8oRozEqVLg53fJuF0MnPQCiNWFBT
	 LYz00TGCjDjQNQ4Do6cEQFM+8HKyT2wTGjuvyQaaR25Ak7oHjbh1Um8DS5QSvoN+ABw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846177;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Vu/o9Ix18ZRG6akOis5lROtDa1uIaD3LKlYsiG/Z5Bw=;
	b=44ZKknzZd1lsCRFMj0VFxdb/K5Xqf2UcWU/Mwusa7prfPrfuwVlAcLhJXp3nG7YvZ3oe
	 5B6mO2+hnphY5i7mbMwVB5K4AF7tKwq0uvErEulBLylLbEOsxQXpzrgUcqPmoONaYSzNT
	 LqqgxFNL++e2rpqnUJY6Q9cptwT+ZwgDWzH9eWVonnuWT/3F4HQEk4PoywLOqWQyEw9hr
	 O8Ar32d1ihzsmmwMBRtT3UCUwOX/XlCWy5qoE5iPJyd6zZACr5Plh3wfecD00SivnnKyR
	 7R3M7HDGAvRylbXt4ZNk32270HeXKfu7e6Z2Y+O8BtcgzA3Pb7LkRK/bqwWWiM7GS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.17.24
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3219606A31B;
	Sat, 24 Oct 2026 12:49:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3219606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue106
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1MTRdK-1x8WtI2iNw-00IRln; Sat, 24
 Oct 2026 14:49:28 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.15.y] netfilter: nf_tables: always walk all pending catchall elements
Date: Sat, 24 Oct 2026 14:49:27 +0200
Message-ID: <20261024124927.5289-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:BBa1+PlhHjb0O4hCe668lBHDCIFeU0noEzB4YMlp18Ebh599oVD
 2vmCtzY1ye4K4Dbt7OHCTp4VbW4A1fl5uSU0qgjNMjhp2KO8pimhHDfN9bIiwBj5EHP2ICu
 XJJXJlBaF3ijOahmDKKcSaZg0MXzNy9ZcN2lJMWRqXVR/PcD842srNXea3f6s6Jnaf4hwMg
 Xl3fvu+CSNU5zHfRbqYiw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qlKFvPoptNU=;pWUWJg2mh/AeG9LFJqfqZyecDVs
 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
 wSk=

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 ]

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.15.y: 5.15 still passes a struct nft_set_elem to
  nft_setelem_data_{de,}activate(); only the break statements are
  removed. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
Straightforward: only the two break statements are removed; 5.15 still
passes a struct nft_set_elem to nft_setelem_data_{de,}activate().

Build-tested on arm64; boot-tested under QEMU with KASAN: map with a
catch-all element, batched update and flush run without KASAN reports.

 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5273255b738..ea7da306ffcc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -627,7 +627,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 		elem.priv = catchall->elem;
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5172,7 +5171,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 
-- 
2.50.1 (Apple Git-155)

