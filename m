Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A503F54CB;
	Wed,  1 Apr 2026 10:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039821; cv=none; b=rVqxZTbdEyBemPA10cFQjOAsZCLi42Ny9HoGmlG5FT6AIV7PQzUAX0FX0tpaqAJruvsIHO5mV5N6bRfSMqCmIJ5G5E4RQ7rSehh9acEIG02RKvj7q5tap66NxsEoPSqfYf1IDP1nUcLK31kuyXjGdk6i+pYoUei4r0IVylz3b48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039821; c=relaxed/simple;
	bh=gShAa7NnnYCC9RFxYT0qPEQldMCD0WLC/ctpQHLWUWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxmTVj/10XVjkoF/kOo74Lo8fqFD+yPvVHEVe2ppizmdDiWf+/hy6+iRmdo7MxHg5vzHpfVBl5ZqG/fQdgZlAVeik1dZvm+CaXvwZ5EZIXYWBSF5oA8eCXCmqR7MEWMaWJPcACTff+/KBfbZMXsi2AtZPZkDjc8Pt2g8S1JcoJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RwphFpw6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RwphFpw6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6A25660272;
	Wed,  1 Apr 2026 12:36:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039818;
	bh=pwvi4jCSImEyJFwxRg1jmJE0qOXahd+tq95vSzpM08w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwphFpw6F77p1LK1dquzjNwVcmIYhlZCp449SiN8nbpFeiHuj5CQTa3D2RY09yvJr
	 r6M74/Epcz+LCT15oX/gxT/qVFugHGHzuptwIpX+B2VxYBGyNHspv0IeI/G0+WIHOF
	 vnSJGQc8twkUpNZqjfUkJUneKBNuaIN2s/kntF87Ki+VV6UXjpJGsNnnSqO5Giy4YM
	 qIHiIK5qyVVM2+uOkG5if4ggvNaAKxllrvHBuQ9S+9ymTOL6cdHsCdPPCFaq+mmg1N
	 ihyy3EuwuCZWXs+6UZEgkZ8pGGucGfggQEQjqZ9ZMqHmK6RzeWjJ5vXwvWjfaVXI29
	 4jQvxqwc8FB3w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/10] netfilter: nf_conntrack_helper: pass helper to expect cleanup
Date: Wed,  1 Apr 2026 12:36:41 +0200
Message-ID: <20260401103646.1015423-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qi Tang <tpluszz77@gmail.com>

nf_conntrack_helper_unregister() calls nf_ct_expect_iterate_destroy()
to remove expectations belonging to the helper being unregistered.
However, it passes NULL instead of the helper pointer as the data
argument, so expect_iter_me() never matches any expectation and all
of them survive the cleanup.

After unregister returns, nfnl_cthelper_del() frees the helper
object immediately.  Subsequent expectation dumps or packet-driven
init_conntrack() calls then dereference the freed exp->helper,
causing a use-after-free.

Pass the actual helper pointer so expectations referencing it are
properly destroyed before the helper object is freed.

  BUG: KASAN: slab-use-after-free in string+0x38f/0x430
  Read of size 1 at addr ffff888003b14d20 by task poc/103
  Call Trace:
   string+0x38f/0x430
   vsnprintf+0x3cc/0x1170
   seq_printf+0x17a/0x240
   exp_seq_show+0x2e5/0x560
   seq_read_iter+0x419/0x1280
   proc_reg_read+0x1ac/0x270
   vfs_read+0x179/0x930
   ksys_read+0xef/0x1c0
  Freed by task 103:
  The buggy address is located 32 bytes inside of
   freed 192-byte region [ffff888003b14d00, ffff888003b14dc0)

Fixes: ac7b84839003 ("netfilter: expect: add and use nf_ct_expect_iterate helpers")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 1b330ba6613b..a715304a53d8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -415,7 +415,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
+	nf_ct_expect_iterate_destroy(expect_iter_me, me);
 	nf_ct_iterate_destroy(unhelp, me);
 
 	/* nf_ct_iterate_destroy() does an unconditional synchronize_rcu() as
-- 
2.47.3

