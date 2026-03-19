Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8711EF091;
	Thu, 19 Mar 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773913125; cv=none; b=qWKzBaF5YykQLNPTEzh1CcjQeTzHlaDM/XpOV0aTXW7Dzz5RuSnU0FecBpb7Zzu4Z4xyAgibQhXrlzgsN+vbcm0orDZHU84VcezOAktKA8VsfI9uanHWlIOBHQHEJclvDtwelYnT1Uw7vtG+Phbd1hlhiAlDhTDejbkH2tX2IpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773913125; c=relaxed/simple;
	bh=XAadaQyYMoAWVnvWU53k2VGwog6L4zz6uXLPI2Yp1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTAPsSa5QKEumzk3RcGiptd20NG/v9ZbYs/o2AQpTNc9dzylqeH0gqWpFwybc9AF00tmrDmlV7drWlHSv8ckG66iUmPHe3/Rph7AnrOlbJTw3VOtSsV03afQqluoH5j3c1I6d7mzfTOny0y3WKsHiGNACUzF1fzfqbofFJxHhdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F59F606E1; Thu, 19 Mar 2026 10:38:42 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/3] netfilter: bpf: defer hook memory release until rcu readers are done
Date: Thu, 19 Mar 2026 10:38:32 +0100
Message-ID: <20260319093834.19933-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260319093834.19933-1-fw@strlen.de>
References: <20260319093834.19933-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yiming Qian reports UaF when concurrent process is dumping hooks via
nfnetlink_hooks:

BUG: KASAN: slab-use-after-free in nfnl_hook_dump_one.isra.0+0xe71/0x10f0
Read of size 8 at addr ffff888003edbf88 by task poc/79
Call Trace:
 <TASK>
 nfnl_hook_dump_one.isra.0+0xe71/0x10f0
 netlink_dump+0x554/0x12b0
 nfnl_hook_get+0x176/0x230
 [..]

Defer release until after concurrent readers have completed.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_bpf_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 6f3a6411f4af..c20031891b86 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -170,7 +170,7 @@ static int bpf_nf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
 
 static const struct bpf_link_ops bpf_nf_link_lops = {
 	.release = bpf_nf_link_release,
-	.dealloc = bpf_nf_link_dealloc,
+	.dealloc_deferred = bpf_nf_link_dealloc,
 	.detach = bpf_nf_link_detach,
 	.show_fdinfo = bpf_nf_link_show_info,
 	.fill_link_info = bpf_nf_link_fill_link_info,
-- 
2.52.0

