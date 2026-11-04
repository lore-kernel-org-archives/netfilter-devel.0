Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782963;
	b=w0cf8j6zXeD44MkfQtv9CLdrmr3l5kfDevGLZg1UBjotbDkeH5ABL4cMxj/Nl7A/1+uB
	 h/EUaS76+fdi1Ty20OH4LPqKc19rMWeHzlT69nLETNos4ujDc3eksUfd3+svjTj055iWM
	 b5iw1Q5m4R7HKCm0XWvEGjrXB3T0Mv2t5gXyzRUEcb+G/7Ws6CbY/fpHwGjPvVEY+27Cw
	 bCYdalB7T3T/67MZ7pWWF6ds2ogxwwCKnU/ucMQTKQnVynXJTucOg7FZVbHdL++YHV46q
	 JmacAy5uczK6HmQ3git3dvE/0T9ixtON941RSnZGYLejy2dMoUwSTTXUb551rryS9sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782963;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=tGglPb/JNoW60gebCDiplQzdX4hezWP6upe63JPqTbE=;
	b=WEbpxApkfSCt+xdDTHFTYA1rEYHGr1aJ5ATUQY1W/mBVUsTPdTy2i2Oy8gCmbB5G7WDl
	 OMAG0WQ+9l1jx2NZClqqjJY0Hd0QuwkTnChj/YpUEaCdAWmqFfucDPbHxJbxKqmsnjIBB
	 TrFFSKqvmRjRCBmbnwIZvAFh0pOfIpkEOYicyU4xHckTNmWW5A7sCKo6Xb/Oodp4WEBib
	 t86gUK3ctzYTHZMNNo9M1AqdPLMCrqJNWroW+NhCPEthZ1xml2qzTDrC3ksZqfKljAxFl
	 lDt2WbeGAQsUdQ/7AHyeoSCTvNi+BEOZKJNyp+PG8aC7eSfHlWvaJ0uvhihaOz5SMyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VPxKba55;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC89606A32E;
	Wed,  4 Nov 2026 09:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECC89606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VPxKba55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782956;
	bh=tGglPb/JNoW60gebCDiplQzdX4hezWP6upe63JPqTbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPxKba55essc2y2lR8KjLxoO7R77kOPPS+cDj5xgeopFWxusWcKVzUbD6PXwQ5abA
	 ookmDCTz7+CsKkKKaDqeGIHeYxMOsChSCGqGF9HLIx4G9GWsH6VWooWSdG5ncDDBum
	 44dzlVQJ92aQoT0kklTPOC217DzhMSwy5hwHDJcAYV5JiJw+A78bj8DGtyTTijZnAM
	 /NU4GCTLJpoNvFGvXrQ1vXq+woYfetSwXrQdobVm2kQsNiAIdtZNPNxcHcRhuX+569
	 kVpBNFZ8mUVoMHaIy+VWUZNuiwVUlO4BGUd5tpDrYYbZOdEkEcv9SLZb6GYoOrj5ht
	 l92b6E54CYM2Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 959B360085;
	Wed,  4 Nov 2026 10:02:35 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 02/13] ipvs: Defer application parent freeing until after RCU readers
Date: Wed,  4 Nov 2026 10:02:13 +0100
Message-ID: <20261104090224.750548-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

unregister_ip_vs_app() removes each incarnation from its protocol list and
uses call_rcu() to defer freeing it, but frees the parent application
immediately. An RCU reader that already found an incarnation can still
access the parent through inc->app in ip_vs_app_inc_get().

During FTP helper module unload, the following interleaving is possible:

  CPU 0 (RCU reader)                 CPU 1 (module unload)
  tcp_app_conn_bind()
    find inc in protocol list
                                     unregister_ip_vs_app()
                                       ip_vs_app_inc_release(inc)
                                         list_del_rcu(&inc->p_list)
                                         call_rcu(&inc->rcu_head, ...)
                                       kfree(a)
    ip_vs_app_inc_get(inc)
      try_module_get(inc->app->module)

The helper module is already going away, so try_module_get() would fail,
but evaluating its argument first reads the freed parent. The subsequent
rcu_barrier() in pernet unregistration cannot protect this earlier free.
KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_app_inc_get+0x7c/0x90
  Call Trace:
   ip_vs_app_inc_get+0x7c/0x90
   tcp_app_conn_bind+0x1bc/0x290
   ip_vs_conn_new+0x1915/0x20d0
   ip_vs_schedule+0x697/0xea0
   tcp_conn_schedule+0x489/0x820
   ip_vs_in_hook+0x7bf/0x1f40
  Allocated by task 88:
   kmemdup_noprof+0x20/0x50
   register_ip_vs_app+0x12d/0x2c0
   __ip_vs_ftp_init+0x56/0x160 [ip_vs_ftp]
  Freed by task 104:
   kfree+0x131/0x3c0
   unregister_ip_vs_app+0x2f4/0x5b0
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   __do_sys_delete_module+0x346/0x510

Use kfree_rcu() with the existing rcu_head to keep the parent alive until
these readers finish. Successful helper references already prevent normal
module unload, and incarnation RCU callbacks do not access the parent.

Fixes: 363c97d7435e ("ipvs: convert app locks")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 11cbdbaf561d..2c1b47702da2 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -242,7 +242,7 @@ void unregister_ip_vs_app(struct netns_ipvs *ipvs, struct ip_vs_app *app)
 		}
 
 		list_del(&a->a_list);
-		kfree(a);
+		kfree_rcu(a, rcu_head);
 
 		/* decrease the module use count */
 		ip_vs_use_count_dec();
-- 
2.47.3

