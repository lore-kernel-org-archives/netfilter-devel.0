Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846175;
	b=zcr3gobuEz8Z9swz0z6IOChzJPc9YS+g2yeCeaI3VX4BkkbJn76XAqBkP9gfGon3E013
	 T+29j7/xV9Su3pq1mwjd5f90qGy+AuFHOL4qtdGhHXtJ5YHTQvo2WmpfnDXybTMeB8IXD
	 BGtHC55xaIKyDdvms3Jgi/j9nfUjNgT/sj6y27whyWuOMJY7x5bBE0U1ov80b+QlsMNf3
	 50/KJzv3myi5q+5nWYlYuVyqNomHLg1l1sHMLxNRLeq5I5Z12oS9kEaHydM9anQMqWO6u
	 JN8QlLeg7A0wrhns75Ui1ogamAZgQZnBhY7d9l7bGlJMI+N6QvN9go8PfdFvWcho2eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846175;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Lp8+hS4P4IBqivKXmiImtgF1gbjF6bKeKIU99a5ytAo=;
	b=npLPyiFjhWU2btme5sULn3aXx2S3kGJOgc8seql2FKTIWPVVM9Me/uK1puCzM+X2AmVI
	 CxFxWGCsYfDpE4tlihWXt6uUW6cVYj2qtsVaYHOErTb3GHjH6WOsVOfOXh8VcBDgnT6rH
	 coYVt6cKbz04tRs38/LWX3zmdfcFqr4gDbDxP+gksX5oWYSfQHu4hX7AgucqhtHaaHcYV
	 PYO7VwfwH+KXM7UVh9Ws4PP6+cschA4w2b55HdtQDzq/emfKWZ7Pn7WBo1q3hJaFcadcL
	 F/OmeOAgNyQsI+gKtG86CnncrYzJG0ufyPHMMGBl2LeVeJzDnmI41eLHfodCuxmoo4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.131
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29559606A31A;
	Sat, 24 Oct 2026 12:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29559606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue009
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1M9Wqa-1xF7XM0voK-008bIt; Sat, 24
 Oct 2026 14:49:32 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.10.y] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Sat, 24 Oct 2026 14:49:31 +0200
Message-ID: <20261024124931.5443-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:95NGEPfXKfW8O5uyrtjL42PJE+wysClETBTDjqLKhhm3ClC7NOs
 JbNybnvZp3QGLY0k9P8gSnmkA6BQ42BWRw+hnKyH0ZgphqyNC19WprPPqfkEs5HkLGL4TLX
 yPwaYhqQdr/rSburW+5FPuZpX++GeGvZto1f4/d70Ieff030bDO4NwK/fQHVAoVuYwYA6eE
 YmPARkmkHP4pr9B3WUxiA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6bHX6ZM4GMU=;6IBkQNMM1KqD0UpHqoWJ4v4oDaH
 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
 ffDoiOy7pF+vJvivT3/6cJKdRNpmA==

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d73f4b53aaaea4c95f245e491aa5eeb8a21874ce ]

Call synchronize_rcu() after unregistering the hooks from error path,
since a hook that already refers to this flowtable can be already
registered, exposing this flowtable to packet path and nfnetlink_hook
control plane.

This error path is rare, it should only happen by reaching the maximum
number hooks or by failing to set up to hardware offload, just call
synchronize_rcu().

There is a check for already used device hooks by different flowtable
that could result in EEXIST at this late stage. The hook parser can be
updated to perform this check earlier to this error path really becomes
rarely exercised.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: 5.10 registers the flowtable hooks before the
  transaction is allocated and has no err_flowtable_hooks label. As in
  the 5.15.y backport of this fix, call synchronize_rcu() in the
  nft_register_flowtable_net_hooks() failure branch, before the hooks
  and the flowtable are released. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
Not a clean cherry-pick (see the bracketed note): resolved the same way
as the 5.15.y backport already in the stable queue -- synchronize_rcu()
in the nft_register_flowtable_net_hooks() failure branch.

Build-tested on arm64; boot-tested under QEMU with KASAN: flowtable
create/delete and the failure path run without KASAN reports.

 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63592c73a7a1..95a03b01014e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7296,6 +7296,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
+		synchronize_rcu();
 		nft_flowtable_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
-- 
2.50.1 (Apple Git-155)

