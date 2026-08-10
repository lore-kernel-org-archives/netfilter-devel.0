Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944DB43B3D8;
	Mon, 10 Aug 2026 19:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388811; cv=none; b=RKUfqZx068MeHNABwS+mvyEX/aNo2iY50YfRgmnaNPt5fyMVSX52OgVhD/SXyz52/2bvpgZvcBii3bwTqAcv9F6WVtchyl+j4Hq4U5O8j2bNC2PIlUw+VZuF8q2Os6eRu0DH//617+FD4eDJu/WPwf71eWrRG0DB3PADgA8m488=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388811; c=relaxed/simple;
	bh=cYGQ0k2vo1qUPyPgE4nGLEQs9eTKlTcggQhaodq6oEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mik550DyACO4oPW85JwS19l0BD7IYRc6MplDAPdmPETbU3kEl0doO3Y3w/u6TFwZjeJO2s2I+WFTpVzC8Y368BUHjA6268p1XXOHDvSX90OG6LEl9h84Khhc9MeAaRDDgxPnaJ7zShz+auPkbEtWn5bD5M1OEFyfbUz4u0KraLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lt9IGfzh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lt9IGfzh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27C7E6028C;
	Mon, 10 Aug 2026 21:06:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388807;
	bh=a1+jVSRwwE2lkU5kAZHpLkb+xYD6RSYb15iwWxd1+eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt9IGfzhhP/Hf29yuFFeF7BkAqhZbfiylRZoyAhWQ73xbsjw+OxSlDyYweyL+1mWl
	 V3huyNLzUWFJJcCpUnzPBN2wkViM1qVWNuAJIGj/4A6mlHr37oPWiY62o7UePAfXrF
	 nlNVqTactj8VwP9E3UuzDsvwfmPpGLra2nr/Qk+ZyGneJWJ03fBVs6bFzyfeS+s1Rp
	 ybIH93nwx84rOE/jxEfYTgFD+NHcopmGVEVGXuHC43GEB7c0O7mPgWCUyiPqebrQx+
	 AvkvUXyR1SHipVYWzCwuNBnumN7uUvLxLAZ07pK5ANF26iRx0lRUewvHRWe6+JFlKE
	 Nzyy0Haxn2ycg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 10/13] netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path
Date: Mon, 10 Aug 2026 21:06:18 +0200
Message-ID: <20260810190621.894119-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

In nft_flow_rule_offload_abort(), WARN_ON_ONCE(err) is triggered on every
error during rollback, including -ENOMEM. Memory allocation failures are
expected under low-memory conditions and do not indicate a kernel bug.

Trace for example:
nft_flow_offload_chain() // FLOW_BLOCK_BIND
  nft_flow_block_chain()
    nft_chain_offload_cmd()
      nft_block_offload_cmd()
        ->ndo_setup_tc()
        nsim_setup_tc()
          flow_block_cb_setup_simple()
            flow_block_cb_alloc() // fails to -ENOMEM

The warning was reproduced on the 5.10 stable kernel under memory pressure
via fault injection, but the underlying bug exists in mainline as well,
as demonstrated by the ENOMEM trace above. The following splat was
triggered during nf_tables transaction processing:

WARNING: CPU: 0 PID: 8567 at net/netfilter/nf_tables_offload.c:532 nft_flow_rule_offload_abort net/netfilter/nf_tables_offload.c:532 [inline]
WARNING: CPU: 0 PID: 8567 at net/netfilter/nf_tables_offload.c:532 nft_flow_rule_offload_commit+0x971/0xcd0 net/netfilter/nf_tables_offload.c:591
Modules linked in:
CPU: 0 PID: 8567 Comm: syz-executor.0 Not tainted 5.10.260-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:nft_flow_rule_offload_abort net/netfilter/nf_tables_offload.c:532 [inline]
RIP: 0010:nft_flow_rule_offload_commit+0x971/0xcd0 net/netfilter/nf_tables_offload.c:591
Call Trace:
 nf_tables_commit+0x3bd/0x4bd0 net/netfilter/nf_tables_api.c:8604
 nfnetlink_rcv_batch+0xb1e/0x1f20 net/netfilter/nfnetlink.c:509
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:579 [inline]
 nfnetlink_rcv+0x3b3/0x420 net/netfilter/nfnetlink.c:597
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x6cd/0xa00 net/netfilter/af_netlink.c:1340
 netlink_sendmsg+0x906/0xe10 net/netfilter/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 __sock_sendmsg+0x155/0x190 net/socket.c:663
 ____sys_sendmsg+0x705/0x870 net/socket.c:2379
 ___sys_sendmsg+0x100/0x170 net/socket.c:2433
 __sys_sendmsg+0xe9/0x1c0 net/socket.c:2462
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

Change the condition to WARN_ON_ONCE(err && err != -ENOMEM) so that
warnings are only emitted for unexpected errors. This aligns with the
common kernel practice of not warning on -ENOMEM.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 8998a24651ff..0ac3c26dfb3d 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -558,7 +558,7 @@ static void nft_flow_rule_offload_abort(struct net *net,
 			break;
 		}
 
-		if (WARN_ON_ONCE(err))
+		if (WARN_ON_ONCE(err && err != -ENOMEM))
 			break;
 	}
 }
-- 
2.47.3

