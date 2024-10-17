Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0132D1DCB2C;
	Thu, 17 Oct 2024 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168472; cv=none; b=sz9mdsuyZDrQprpWAANF5xHFZL39pBJo8tU5c7c11rDSxesK6NokM1sqmuJmsnAln7rGyLTvxAmxPnNjO9qYp6U64dbx2eQyFEqgaShnq6DNBf08nmq/jv/ZJtxLgwet2rHKkmH5TWLUO/KqnenNR6jNU5VlscTAoqULuBJx1w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168472; c=relaxed/simple;
	bh=gE/KGPEvM1V9/wAW3ScJUD3z+1VvJN5NaMa+a0gpYF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sYMx5LMFQ7WU5abBzhxXkdef4IojtndNVliWlGaSonqcMsuhDgMGThVKaUHb1pB31mhaurLsxUXNGk+OzJn2aulLGSJSrsQVktCwdxsi65eiSrwfccZqP2FmhTDKFAtcCBN0AcPU6rk3iA/n/UGFXA6bUmFqZUVxV4ElvBLZv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/1] netfilter: bpf: must hold reference on net namespace
Date: Thu, 17 Oct 2024 14:34:13 +0200
Message-Id: <20241017123413.4306-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241017123413.4306-1-pablo@netfilter.org>
References: <20241017123413.4306-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

BUG: KASAN: slab-use-after-free in __nf_unregister_net_hook+0x640/0x6b0
Read of size 8 at addr ffff8880106fe400 by task repro/72=
bpf_nf_link_release+0xda/0x1e0
bpf_link_free+0x139/0x2d0
bpf_link_release+0x68/0x80
__fput+0x414/0xb60

Eric says:
 It seems that bpf was able to defer the __nf_unregister_net_hook()
 after exit()/close() time.
 Perhaps a netns reference is missing, because the netns has been
 dismantled/freed already.
 bpf_nf_link_attach() does :
 link->net = net;
 But I do not see a reference being taken on net.

Add such a reference and release it after hook unreg.
Note that I was unable to get syzbot reproducer to work, so I
do not know if this resolves this splat.

Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_bpf_link.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 5257d5e7eb09..e5e79a08c10b 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -23,6 +23,7 @@ static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb,
 struct bpf_nf_link {
 	struct bpf_link link;
 	struct nf_hook_ops hook_ops;
+	netns_tracker ns_tracker;
 	struct net *net;
 	u32 dead;
 	const struct nf_defrag_hook *defrag_hook;
@@ -120,6 +121,7 @@ static void bpf_nf_link_release(struct bpf_link *link)
 	if (!cmpxchg(&nf_link->dead, 0, 1)) {
 		nf_unregister_net_hook(nf_link->net, &nf_link->hook_ops);
 		bpf_nf_disable_defrag(nf_link);
+		put_net_track(nf_link->net, &nf_link->ns_tracker);
 	}
 }
 
@@ -257,6 +259,8 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		return err;
 	}
 
+	get_net_track(net, &link->ns_tracker, GFP_KERNEL);
+
 	return bpf_link_settle(&link_primer);
 }
 
-- 
2.30.2

