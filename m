Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B58471251;
	Thu,  6 Aug 2026 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786033158; cv=none; b=V/EVV73kh7tHsHt+7ZbzG1UvAhGpqwAjDcu6eF3hMJyN5EO4fZhvj+9wtxdceNyRrv2OfIxxsYoLuP0d1UqVzGxUFwFnOxFlExccGoCzT/hWUepmw+bt5g/H9Hx/R4sbfUR6fnHIaTUHMwsPb9p878FhtRsTySY+/dIK3tTZJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786033158; c=relaxed/simple;
	bh=wnGALZS6J+C0bv70/WY7aJUjvS1BtK+yfhWFyTniN98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SRlZJRGEQfkdSW0wBxwPhzCrkSgSRqpq9azuNXqBflBevA5G+WI9vpbhZTAwB6pq38y11Bi4e/rzWUQC9yF4fEC07jJQc5OkPaZA5IOIJfN6oAWR+ZFvPHMc0Nmn3z32epK2peh4N5ApYycAIff9syxIoE6m6bVdm4jfO2JNiRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Wf8YeOnb; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Wf8YeOnb"
Received: from VelichayshiyPC.Dlink (unknown [178.69.148.188])
	by mail.ispras.ru (Postfix) with ESMTPSA id 20C25406C750;
	Thu,  6 Aug 2026 16:12:03 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 20C25406C750
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1786032730;
	bh=jOs8stk6LIo68m3u3Mbi1LTdqWHJNdTfR3YYcvC9xWs=;
	h=From:To:Cc:Subject:Date:From;
	b=Wf8YeOnbEFL/kroUkhYNPfOTaslv1n9j+CjVtcdL1bgjDPtXobP50No5OUWmye8bi
	 2FF7Rh9P8CBBA8rYQyleQCRcJSNFeWSHv6gpFzuLRPTfnCdfUg1TA6gJaEd5IWbQLY
	 TPTP0646pfMQxPC9sF4Xd8qZwv55SBaAvszGx3j8=
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH net] netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path
Date: Thu,  6 Aug 2026 19:11:38 +0300
Message-ID: <20260806161139.458013-1-a.velichayshiy@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.43.0

