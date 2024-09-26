Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28161AC8BF
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344616; cv=none; b=hl2/EG4p8VM0vqmTKb2Rdau1ZpwBEaFx48rolTvcE4O5leZnfrQejAUbxLzFbDJKgJFPhTIT21wj9iPHfeWgqrJmkH6jjRrUIbjE/VPy/RkpO3ohuntHLW9n8uOrna69SZa7WtkpjSHsPz82mOyO9zjJwJv4Kx+7PFU+Br1qB54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344616; c=relaxed/simple;
	bh=SD2Z7Y1ZlKyF1Qfr2j0zDPbLxQAwWG70rB3NrMgw0H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf0D3ocaZd7Kf9dWJeE5xFDqwWDgWZv4m5StMf16CTqGjl1eHZISQszkoMXNxMzw02yGyz0flznqVwyGZhVU8xfJFClBG6DSQhd1NVtkZHnIkkEJPoIuqncYjC2V3R4VirqptkXwGIFBNsTOM2i0NAOZABwsYi2H4zvhoKSE+ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PZwaikzP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PZwaikzP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Slkj+5MCrGDekkSdHNwUGTnqD0LcPoVvz4kmOhp9FoA=; b=PZwaikzPE2FRjvPIa31evIOg6U
	CpphrD6tx+oVbVlhDQ14ChddktFwBvtMVqMUpUBzXFYVY/vANVpqEKyiuxRh4U3CefFfDwsB2GtbN
	5rYsWLQbBMqDKf41PYU3AogyK5iV5rrP7p8Y3gO78FMWLRfpVrwZYw3U/aYxuUx7kK/JRkPqqK0w/
	L/LyTedhhn+wR/TR2LTWfeFwXTWZBYwI5F/FvgesJMRbHMNKn4gbID46EPlSfS0AifICZ94y3OYps
	QDsDYzj32i3sETZ1jBb6DoJl8wpSYPdLVjhXnJoVxNkhCIlczRzjbX2hwEr0OA4/lg1rmHQDAT5fS
	aPbEWMBw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEz-000000006Fz-0IlW;
	Thu, 26 Sep 2024 11:56:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 01/18] netfilter: nf_tables: Flowtable hook's pf value never varies
Date: Thu, 26 Sep 2024 11:56:26 +0200
Message-ID: <20240926095643.8801-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When checking for duplicate hooks in nft_register_flowtable_net_hooks(),
comparing ops.pf value is pointless as it is always NFPROTO_NETDEV with
flowtable hooks.

Dropping the check leaves the search identical to the one in
nft_hook_list_find() so call that function instead of open coding.

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 042080aeb46c..b85f15ed77ed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8571,7 +8571,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *hook2, *next;
+	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
@@ -8580,12 +8580,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			list_for_each_entry(hook2, &ft->hook_list, list) {
-				if (hook->ops.dev == hook2->ops.dev &&
-				    hook->ops.pf == hook2->ops.pf) {
-					err = -EEXIST;
-					goto err_unregister_net_hooks;
-				}
+			if (nft_hook_list_find(&ft->hook_list, hook)) {
+				err = -EEXIST;
+				goto err_unregister_net_hooks;
 			}
 		}
 
-- 
2.43.0

