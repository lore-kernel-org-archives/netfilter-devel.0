Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846175;
	b=vJb0KI/UUjbQNWcR/tJnBOx1N1Km6Av+047D5bXPgk9RwPjeF+DDl8ZW+61mAiNivSzE
	 kNqPUAFeDvFMNuF1HwhZwuMsuXlVl4M0FayWoLDZ3JiwbFqPb/4HvpLdvHrFc5j09QdbT
	 fvaSVUhTrcIdYfyHcTE2tMjCJEi6Hzj8SAx4Jl36x5CjHI3p+w/7+Rtqm7k6w47WaZE9v
	 GameeuZiwoK2uNauq4+GjnBIT+PKJKB5AnB01YQ5myE/GVs0sUYBfraoyZaerNpxq7bBL
	 3Cy9zxwLi3hLNn/HpvHmKYWf7yBYiJxqtOzrJjw0LUzUVV/956p/MYo4rhDQTc5JQgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846175;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=p/2AV0saPMIDHKLYTyhSdSQh5/dWISaZKv1R2XF9dIY=;
	b=nngajfM+XPRovZ486IaFWN3ts6Kek0YrvcFY2jShMqktYqpOYTi3kWchDLgcLbreHWQt
	 IIrfxrA20umaNpdjvRMFOczcN/pEJeJ2MYD1NUhhlKOBPkm8SecodlhrZfrw2Z7lJzLNJ
	 vGzwhZAIT2TrV3+UKdn+5qdb4TuAWwiEa8yoBJ6g2dphtyckh1vhNKxVCrLJbrulihXXo
	 mWUFpIrQ2/GHvCfl4JBwP8Vt9EyBZhykxnekJe/CMGc25s+6QwLf15pwFngwQJEdG8bsq
	 xPbuMNrvDMF7O9rzq5ZYfQNqWojNH9Ov/cgbvEN8ZzW7bKfuCZ6Ig7cx1IgcAIn/hww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.134
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CE606A31F;
	Sat, 24 Oct 2026 12:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 348CE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue010
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1M8yPu-1xFflk4AXG-00CH5q; Sat, 24
 Oct 2026 14:49:31 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.10.y] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 24 Oct 2026 14:49:30 +0200
Message-ID: <20261024124930.5397-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:soROOQMCtV0twiHiIORA0Tu5YlTbNhzAdWhKBfn6t84A/eUpPF0
 EUw8flaWeomZ98x4amOj3ZmvqIqQazS6/OZ6Tbc74ABD7DmcnWe1cLNDGoa6jduwbWLMqzs
 Dch/dZKIVOecy+BEvoNcvkkpc+PgxM4ir8rYjZytu7ysZC2Vo+lH9h0iIEi1AcRyKKTt/d5
 tpqOx0YGEgvje0IsG29bA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Z9mC28rEyCI=;D5/E2R0rDemuE08C71I+JkZ0fV1
 nMd5rxR7HRJyNgMACK+HkwPCYZzGCI/ggdiIJPc3ObWuOUpxw//UaCdq2BdhOttwbpThRXAiP
 Kq9XuNM3B6WzkE39+wpAePOkH0cgE2gqSWx68AJ2qmUDI6oJoIIvxM+bU8tceRDGomD0sonSu
 kqDWxrt+TV7fBZKHgLP+jZCigYAbSQZp/+a3MNgGF+IaeUbENRyCiBB1PEh4SphU/y9TTYdnj
 cReSKUYcqfEUHCMsDeJLW3YgAhZulp1Csz86fa6IiJ/zy+uwG8GO7n896FgdDqDFa0JL7L2Ii
 13dEpNTRguDg07Osqmls5oJiXtlm0aCHVNhtXCFWKHSBxkvzd5PQ66FqaiGTrPjqNfkxDbqPq
 hWQpnPcsASKJalEDHVKYaVp/2RfJXyEdkqkBXC0gAAIMLfKBlHXv7nrFiH3mYuJ1v74kQ7b33
 fqhWsb2s3oUxnM2G9Wuztbz31WbUrgWLiXV43dz+mjAkLRM/OJYWNjMDh7LRgPz5WrvlQALEo
 0Jm90Ft/ggMYvxAuSYwReInusfhCzNpQkQe1u+yp/s3SCNWQzNbZqkezYqnQzTzXcguYh+8vr
 OYrKAApAjHwSJ495snJzQm5GUmP7nng202cWOspEmKm+VMs4GD8h5zDT4zUyNh30HRDc5UhSz
 +KiTPxQk8lRAWHTIkmrP1tGyZEwwFr/mX8EtvAgOm+RB0PETU8fb4GFGd2nSJMe4wOxGyQfcO
 Moj2pW3b05UMONHnCSkm2UptMaKu+tDR5pveE5UVpIZp8JjKTV3RIvDwt9Sqt6FxarWKE40rr
 /C9j1uf/urX+FHvpO3OBrhT1vWwcleTpsA4qkv5DCOtfMzKkW/3mppVJ2uAieJNFhhSD69YJR
 CJH6sib9W0Dc8hARPCbrk+8UDBBJuVVc98j1lnqPB+njvCctzCqH3rRRoQbx0cvvnIoSH2s/k
 78bCdNv7tpYmrihrMTTJTONPeHbYjTMPqPwRZz7EJd4HNE76EgtclYeCtscZAnPTs317lFtSs
 iEoPMh40Gp960RVeeP2Lt9dAYufd9LD8B2pekZamUDSAwsyTGNobL8S5sbw/+sOCMt0+lM2bf
 iMK12K9NluQgOYBk3IA4W5DT0ink/Xg5f599ZLTjmKgLipvAlY66wSnIyG2Gwn4rGMxfrqa2T
 H3ibxnjHnNXSxTgrFGFQA0pbG7vsODjIrEcVnHBVubH23DWiuph+TWXt4cvsZQBEbJvGsXXLR
 SDxGnf436ZL08Ctfv/SBTgBFv6bdiAKfkxm2b0rlXdChW0Qm3lZgJhBJ1w6uQ5PdeS1bXLsww
 FBWGHv84ZWnJfxYd3z/bKQlncjgnS8LFjmF4yUYJoVaXemuVCRnWHVp5Jm6RJZxqAxEOPPSiU
 TW9owTEOuK70Xl3PTtPvsh3VzV1LHCYkPlAC6YFiUeB7kjTbyMmzAXWTMKZmeOnJ96neQiVwI
 uXo6v//gK5dS+HOR4Xdu0y3Ho6a2WuowXhn6OG2VPkMjVyxKYITUmCuly8rFS9pwE2wUuMsqE
 5OKgXMbitFU82zp5QKw5I/mF9Y14xMO+bpPRJ/nlKhvCtLBVal9B+wiPkE9LOVMugpYP2fzt3
 zGcB/t492OS3nyXShpPnHtiYaF5QqTp/jSErOSQTzILfEksBGYpNagfEwIubK7agDJ8S3n7md
 ZlvWD/3kJgx99menlurz5LlY3DDHYQ9EVEaBG1LfOCpGdF/MgdEl9cOe0pTXL0b1jTLsLkpvg
 7dfsvwsvfg82N/Fl0I2vWqe1vK8WaRbr3tdZeuECmDdYNHPMWv8vHul+2fLdCyOnLMNZ6ElBt
 ldpIpL+iC4BLq5wNdqKyqdCcHdPGRmTSKbyhZRmvqoZ6mU0bvU0oG5VGIJaTjxe9abnGvoDJu
 HMUEAXdb4wjT6BLNK6I6b39bU26SCTtE9zBnPgiA32bUS7NwbkIRVPeSRipSyl9yQjfgoYIOz
 nx3g/ZUc3g8gpMuYKzkQg7FaIrPt1SnZeG8CfLOy44cxciSAAWwfs6zGISMiWC6OTRg3aFAat
 Gkp2JzqQhH6slNdKuURletsB80W79/hk7BiDP/MAroTcBRcrYUX8W4qRRh6Wlm6SCCENa4kaN
 hb7k0xUGPu/Rcjp8ChR8HvQnL3AeEwP0VIvQA4I6pw5xUdZgDvH50d2lv0GqzACnfQVJRH08Z
 Woh6eLU++BrrfH7xYkWRbDRlVTUQshSSKfcp9SpYPdeJH4atXWdds6HTBj/++1PmNAqUOazIY
 w2CHEInvSgniMTdDsp6GTuxNNwCk7rJ7YG9+0DBSbd6egE0qN8qsPyyNnRDB5a+YmHSLFjO6Q
 6Ix8uhZgetBzdkELtpjm8/k2XvizqLkxSACXlX+EvWb2nThwuo+Lc8lIXHPpfsQ7Im4U8Z/79
 7id9N59sdoEkeeQSdxPyox38wqKTu/A8XXJs4+ZfEBqTRvWMqhEfr6SkcLxrYJ/c7tuy43Yxm
 JwQ9XcLpy2yL6gJQc4CR3Jpwm5IhC9n+Er2OIlRP3eOChrdxS/YdcHGonhOz4gdHR6iTrc0uD
 ae8PeY1fRgW04oMZ6Rr6qOOPXdX5GHk92YsXanN0z9MlgkUW9lDxBVGklwJ/EnnlPRkMqF40O
 klEUHcvi/mHTvvbrae6OUFukgTsXDHsg7Jl4OUckuNDzE92u4VEyPySiO41yPmVSSWjlJv/Fc
 jy0PqXmkBAEWVCcetoa9RB9mbVVEfW2qMuljO4lfve5xaakV3yMdTpel92hj5kT5+z6gviv/n
 AdTJ2tAMiwpnHyhwXEElc75Bot7JRWu0Mnrc0EPxnr6Fn+2UZ03UVIXu00lCbVCVKBun0qPrm
 TPyjX5wOhsnpk3rrr3eHUd/a46gFFWEqipOP/wpyFUR+89pNTLlx+f5ihkk/tu8VtBFyezpV4
 /37nD2JVtgqgZm0UqYO1T9TdhrlOi1rXIBXf24KQpgIlzcjjBwpKD26QdQCId1dqzwT9Aepy1
 1AaQDC+evM/jiPBtHxDob+Eo2Qmm+O468Ldd1oql7Nfl8TqlHhy/VSCY9l+xHZl7oKPOwzPXo
 h5bvv7m9tibb/eWtIUh81fsqxI5Fq1/TlL+TwbIaFZ0IAXM3FIA1dU4W/Y6Y/1Vwf4o40z8ws
 d12nXaFWrrunCuXTkNTYC+48h25SoOkIn9FupKr/f5h0y/KiSoRfC6JbBJYWften1cGB/W5ZV
 ekpaOX9eIIC3NpY5p98r+5IAIdIpWRJK0y0LeAd4FrkKD9O72bVcSfS/bbA53FoGBUfrvHzTk
 2q0LjDEMznW4lXVzqsme+FO12pEnTUNEPC+GPspmUOx41FmUy9rftlFy8tG8eN1V9aZn/tHNv
 +yG+XSG

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
[ Backport to 5.10.y: 5.10 lacks d472e9853d7b ("netfilter: nf_tables:
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
index 63592c73a7a1..9862a34010d0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2341,8 +2341,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
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

