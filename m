Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5D19B5AC
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578066; cv=none; b=bW6he8vhhgXko0lVW2HuYhn0i0ojosIfT4MJlqFj5xAOE3GgQaX8NTx/4leDzNtyV9BoB9+bIITSsut0gqHBifZapwmSiGlf8VMNF7jNeEMKbtO+JDASmLftUddcNXRIQOGNUfb7oxZ5wkIGxBpxFH4Noqcz4zSzB7KI+UvfTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578066; c=relaxed/simple;
	bh=TVF7TBx5N5OgMUQNbqVHB2rmXlW3TzhngSp9KRT7q/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JuljVE3PG9HedPNRQOe1Oveb173tffv1Az3F61HFVwHBYUz/HQ8nQP5iYT3pEO9t5ZOHP4z6Hux2DCuH9BEHUQ39ICm3oT8QXf23Qci4aBn4jCTZBUJqi+h/C4NGjfwmcj3HfWzGNOHG5LSS/pq+ogTHQWpcbeMkXbhD78ykiP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1syw7I-0002gj-LP; Thu, 10 Oct 2024 18:34:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	"Lai, Yi" <yi1.lai@linux.intel.com>
Subject: [PATCH nf] netfilter: bpf: must hold reference on net namespace
Date: Thu, 10 Oct 2024 18:34:05 +0200
Message-ID: <20241010163414.797374-1-fw@strlen.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.47.0

