Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792912533;
	b=OCkT6YrV3MdXW9+lLXa0JMYwjd8jVl1QihVGRjHBYnrblm9pnkUX7XLzO1mlt/B3BEf4
	 Bt/L5TahLbPaEmTxgqsUNCYOIdKlPJScPS+PS939X/xlrGHTgxRRUpZWpNSStQhG9bVqa
	 OZYNihKoi05Y4+AiJq1BaAZ1OW+dD8WllxMEZ7fnaIzzdUfFHTA1uph8gRdCDmM9z7P36
	 MLKZWpEwi0N/IgEOJO4FejYJIxkUKkAZKpLGToCI0IqjTvPt7r1/aq6QQVJDA+L+lNzzt
	 QH9WouEyO/SwRQYtoybNmAVfKA0WrNscfb2EX/ACxC2h+ljOdT8kLk+jxfOqpXA+esg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792912533;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=N96c5pVXCKDvliCdnmP1mOJQlpT3gjknAMdKuzA4rRo=;
	b=ymZ7rsOWW5s36YWOEfV2r+/41CA68wormQ7ZSg3yLHEB6lUayfknEM5oaKZnYvlKI+B/
	 eyfirWWFAlaaidjDe4mV7dh4ucS3yFG/x+IFFrOt8op73Wvz2ynE2igyF8oXLTz6jsOTR
	 NHK1f1grJ0n7Z3xsFsjq3IQHPoRHS0mNaUx3JoI/CSoal4CqOokZW67uK28p8pHcPWdt+
	 9GKNvQyFoWwtHbrFr+OcPVnfBhafVp2h/kaBBRmn0+CQAf6X4+XtkkOOz3c4XC+kJNiUO
	 GO5oxbv8qZaVrABNl7pvvkY4JVPrPjRn9/CZhs962mwF/uaQjh5kWdneQ260IiWdClw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.133
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AE606A31D;
	Sun, 25 Oct 2026 07:15:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 430AE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MSswA-1x9Lso1UnW-00PXUB; Sun, 25
 Oct 2026 08:15:24 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.15.y 2/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 08:15:09 +0100
Message-ID: <20261025071509.47122-3-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
References: <2026-10-24-1-daily-reply-0009-nft-set-nelems-5-15-bounce@kernel.org>
 <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:DJpVw/b/j9EtZfgJM1C9JkreKoY1ZFwU0O45O84AID8M4SxmijL
 KndOUd3eyIaCDwQ3l4i7dDx12pjWfbekUPM2hHqS3y99UzN1aFqCDM/ZVzprSusTJQSOGdC
 ielyBywcsgVSG8+UpACwjsBzymSy/BqmTRoHl8DIpLUGSrpcygd4yTYABLBHNqa7t8GAYyA
 azsZDBOTKJJX0MaXjnhsQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t3aQ/s7LGEI=;4e5PGccf/oKnGx6ZDMBPF0FMRmc
 kfqdzmwdt4lNWTvD6YdTAT3zM7Z/fpik7CNK3K9eXbpIzzfVxt56UgNnTKLGTqptavrGW6kic
 t4A+ByX3sesjXwrnewhWUdHsf84TX5OFf7cCYf0uNm0aR43+QJyc5BxkUnJIy3Z/LlhJZoQqv
 gTR427tO8gZma2EDCYPyl5NZMjz2uUwAJYV4IgjyJOJdJ5KAJC3x7TYK0ntdJOqJhPgcczE3Y
 Q0LzUe2lU1SiUO0uv8HHigKeRcXVTSAZM3wsxDM4wBO10On1pdk03EkkvBx9oBPY7GA9pgNA9
 DY29j/cQUrHjAgyphHrEmpBCslOWtVdm+c5cQ0ov0ujdSRIn922FjC8GE4yXDaxbHrx1WgHA9
 HRghp3lsDcVIuibJY7gy5Pt0mVTsYMLr4oBVYDfdNfSTv5MZfgJ6D2lJvV7uIBEa5HnkT0ElO
 LNxFErtZEIPKoUxey0Tq+ztwcmrbQuylblDiXb9j8K3wwtoJ0cuOylTu/KMgc98x9uJiBNb9e
 R2XhHDbpyyV0/DLUxgywaSPVMhsDgPIn/x2vLLk4XuY4/dYQY+O+ZWmiD/x7rw9YfwO8TKJe6
 gMBo0OtAWHVCnprAvreFTz4F41648dq3jXZpuS/XIoIeIwRsPFAEbm5StPQAkbJrH1etdnEBT
 ZldJvpLniPipC7jDY7YR0Fo3r/F32DyzC2PK6X+KLoWzXbQJItyq7G6snorWj4wUJ6ElBUspy
 1wvIsz+W882JanysoObONxMwNsBuVmC3TZVd4Sgt4vhctPrfkD6R+mGL0OimcyLDFjALvquiH
 Wwxqxs12Lw7A8tdTk2BFGeSiJYdWmaKVi/MRlZ4JfMHm5SugzjYB5icqaBRyApkn6yuAv5sNo
 eim+BwA2EcqujOY/GUVHc3BRym6Y2Eswddha56KWzwH0hzgWOleVmjwE/zI/qKMuIImAhtxYH
 xb4L8xCrbd86Ww9HdBxlaDf4hl/EspFhNfoiD9aY05BrNUHYT7F4Le7iA5qhpoOvZrqURmL41
 qjnKjvNHRC8MSghjNHshWkyoMwMf7ZpwJqwt0oTZHRdN3I5FKYN1EiI5YpEDu4JZb6pjZpf3H
 Bxz1xaciKznEVyulQIFRgqZ1kj5HLnS16FPxDwk2G4bi8qN6K+YOzwFpAOyoQpYOmh6wHuWbt
 p3HJOC4Cizv9LhG1vCLntJE23oQiSa4V7Gksc2Be5YeQc3Q408Spkgwit59FRUTXkmQgcORAf
 ABDuJLdPqt/nZ+tzNFcja9yBmnGUIDvYbpCUIXErY0kJ83U22LQ5Ugfn/y+tOtupKMay5+LuB
 4A8xAkxy2kuzpwSQLFKqOLFfuwGMjvmEHvRXo5UfP/J58K7mbF0uvkby5QkihyUdNXLcm7YGt
 klQPmCwdnZlntEuZKXYwy49n9Vh/VLCrtPWdIU7k1jd1/CBgOAyHWJ/ANDhDtSWbGxNRJNAAT
 3IBwjil85wBnbnuv/U1sfozjuOHxeeKbMx76mUc/ljdA6zZH9xFxRvIokL2F9k1L0sboP8HAV
 kz0a/nGnPkpXGldUhe10uOzFBkJB7WugyZi57K9jP1wPabv2OBMMghNiX/oqmtGK+LJw0wSc7
 cfGhQPGr2726LFsO7+/vORMMZo6FB3dqWTBuJfAzgpllzXHgDH6M8rwodHI44lnkVsgcm7ohA
 wHKfNZZTphVZ+D2d1cg5XNjSv+srZOcsR6VWoLuRqw1RDM+ofRdU/++VMT2xE4B73H/+N6Qex
 sCQjaZP0q9MwpJr42aW41mpBaxoa7KuKyvYou6tu05+G3mzpYvVW71jNKEyJxDxmfufnvu9iC
 uq2X8JwusAsa/lJJbM1TD4ldppoBe2OExblh9STUxjJNQnuiWkEVHSqEvmyTuCUL0QSaLd00G
 +IZtK+b67qSud6AqxTYM4jIe0NJ8F9q/bR4asA4ApkJ8x58XN5wEJA8v048yX56CPnF0SvxZz
 tFdrIFuo+lZsgn3R6Jk/0OzJ3+ZcuVV6SDmPf0kqkCncc9mPrnj9grkdYHxArPM8htbAJ3h7u
 xqnOn0G2oM4U4gOHmAwlQNgX1A49rP1gS2VUm3fsGsXvmsgX30wtVaz1AnvHaZsdIdReP8N12
 m0BEHTQ4DiAjN9nggpCqVW5pJInRQMlpJ/Bz/d66cq14k/94FIzsD+1hy0NopCIsuab7+1CyH
 c0RYY5KM1igjEDc387pnZiXumOonvHAkg1YXmLrjFthE1uQgujsUqG/XVY/IEXR+dfPgSD6LL
 MrcyTVa/OR4Kdp9VR4AWjA7e2oNp6BdPx3jBlkX3ft6rThOgKO9XZYFtXWS3zl/+NGThDMX8e
 CBzyDgFfgS2jgFD41hZ9KaEChZX5PnqPlAIgVXybn7+pNBr5PPkg/wP1/H7+zhrbBqesYCxR0
 SKH0GQSUo8PJXCG7xxw8qBCQIctSzagXT2jJJLYdNL7eL+VZmSud1/nH4NBx8F2zCJHtrQiGI
 89ZcJTCcXMTXImhuFjwIvLVW3YhkCwwXL8wDGufEN6vmXb0oAl5lBZtxUGhF4U8PAIaanP+gG
 BuAnZAezHq78mYujQe64IylSwPWTNTJJFWNClyNWVSRTkquYRKgDiBFt5QY0aJjfvt6T7ZTat
 z7FSXjyb+jS4gXayywCVVLXbYyN2AglxAl0303LEDq7wcAJn4lWcTnx201TT3jBYQRrgDbS6A
 JpCUEIsI9/nzsV1JfEi4z/beGYRCKkyTc9YbeHoKDyeyvkybrH8fLcf9iYy3ndX6aGL/jwszz
 NGXld/4QfHPnBKF+yITt3xGtSB/9oAL5qTbu2nvfupYwMsuIUV6kuPMVS+cYYKAd8UXlYY2r2
 wzpk0xKLCkIv61fMmK4sxjQcB01sklrqtQ6YlFllfT4Ksp9Kji0joYnYFWGO/VHmyzay80F/W
 mM19ckQzqtf5rWMh5McQOdYqTa33aQZUfQU8OqwVWlipaHi3zdFMoo+xusXBjKn7Re7VKvVWI
 g2KDLzBxH7KVIkwX2GHizUtfN3k1YQKoHd0+eKudi90GARP3+ICiTEJN1QcrLbYY0Db1ULSnz
 2LHPrf1WJ5qleLhzCWJtkwA2htCfFM1bgAZaGnvF/7jTYVWPR0dCGbn2SO7fJ8rRGs4T/DIj1
 EeN59FFBThKHSxmH0n1X+qqj+gySNZ1ndfemeRmR26oenhAgDrwytkMTnxKVOkretkeiSyMBO
 mKe5tEXi5T1gvnnf82+nl/WCwuAj4CPkYTY9ZoXZfs2c7+/WncHu5yFEhzpULY1G7b8iN8m9x
 pRBAIZ8n30UTwZVRGfAUIJgJG7KfISeG17gyaIx5qLdI3P6VzS2dVW8+Zaj+BBcBuroASUi4Q
 AmZsbD5CPmVzopF0IBHbSW7CnqIhMm9NiplXow4f4v/GBhiht17DvKOuiSrvpLmo5lIOb6xJO
 UUSMaaI4bffiLAp9FEHw==

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.15.y: applies on top of d4b7f29eb85c ("netfilter:
  nf_tables: always increment set element count"), as in 6.1.y. 5.15
  has no nft_set_maxsize() helper (introduced by 8d738c1869f6
  "netfilter: nf_tables: fix set size with rbtree backend", not in
  5.15), so the ceiling is the same expression the prerequisite inlines:
  set->size ? set->size + set->ndeact : UINT_MAX. The update-path hunk
  from the upstream commit does not apply: 5.15 has no in-place
  element-update path here. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
 net/netfilter/nf_tables_api.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7a6bc137cdda..9a71c19ce3a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6263,6 +6263,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	void *elem_priv;
+	bool set_full = false;
 	u64 timeout;
 	u64 expiration;
 	int err, i;
@@ -6549,10 +6550,19 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_expr;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+		unsigned int nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -6585,23 +6595,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.39.5

