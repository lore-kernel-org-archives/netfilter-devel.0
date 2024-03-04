Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEC11C6AB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 22:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589980; cv=none; b=esJUNBMLrlB8ftZQ4ho59acMgEXQotQhJUpCouC3zRzPMdyLTXlaWTV+UOzy3A5BrjqliYNBHaoJUYQze8Xh0uz3YB1cSVQCHnZpQemZAPI89t2lLAvSgZiAFxKmiCLbewLfMUTuKM2M/f4G0QQ4b20WXRvR7FkdOYO0lZpkuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589980; c=relaxed/simple;
	bh=ZQTJDo+kKuGnSBcWRnPI1H3Ln6XNI9UkqZu9mV4E45Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sfYT85E550ozXVoK+sE2hQrKMOlegfKhe4N2f12erM5joVIn5ftKwlTJruNiSDJAFwB23gCXuf/2fH/HCGJcIcfVcLpzbxlA9m/bkKu1W/yCP37a7jm1MtGYYxhX7B6lZ/9ZWo2HsC7mfbhOTxTRDlX1AOSmV5cJLiNkLNtm3+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nf_tables: mark set as dead when deactivating anonymous set with timeout
Date: Mon,  4 Mar 2024 23:06:10 +0100
Message-Id: <20240304220610.183076-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets while it is being released from the
abort, commit and rule error path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to signal set gc
to skip sets from prepare_error, abort and commit paths.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: handle only anonymous sets per Florian Westphal.

 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fb07455143a5..52d76cc937c9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5430,6 +5430,7 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);
@@ -5500,10 +5501,12 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
-		if (nft_set_is_anonymous(set))
+		if (nft_set_is_anonymous(set)) {
+			set->dead = 1;
 			nft_deactivate_next(ctx->net, set);
-		else
+		} else {
 			list_del_rcu(&binding->list);
+		}
 
 		nft_use_dec(&set->use);
 		break;
-- 
2.30.2

