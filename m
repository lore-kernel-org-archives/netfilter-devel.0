Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235C9282ED;
	Fri, 22 Nov 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732282375; cv=none; b=XqaXhwUo08X17rH3BveFNcA3QFjVdfDnlosQ3bRtgJExAsEbDtOfts1IjrJqYZnTXMYgv6flefCCNvJU8XaX3G9XOlisNYt00CF2Ghb3UJ7YLFLOTaY8d005a5A9OwDYFk6zUHZaijHUcwoMaAA/ZoXGLF3LPdzuDSn4u/aKcrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732282375; c=relaxed/simple;
	bh=o/u0zzhvdelx5XXWutThbe85X9jIBiHT42M5J5a/aJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fpHxWRnYBqXnwdQzoOFmtWztj54S5SnhDy47I5gz/fi85k5hQ8s5wuSAN3U5lHuRtALwQfIvMaIK8tokoTbl2rBbDWcP2sLrctnhOl+vJJbR+igMxpkOSqNRvcdY0tPmxPSEzRNjM1o3DIwMkGOE9WkGuKa71ULF7hJpEoMHExk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3ef02798a8d611efa216b1d71e6e1362-20241122
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:44afb5f4-d0e9-4687-96b2-9c1a5f7c496c,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:40
X-CID-INFO: VERSION:1.1.38,REQID:44afb5f4-d0e9-4687-96b2-9c1a5f7c496c,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:40
X-CID-META: VersionHash:82c5f88,CLOUDID:e8e15e6b9e1d71576f9db8af536c06e4,BulkI
	D:241122213243QGMXP6HB,BulkQuantity:0,Recheck:0,SF:17|19|23|38|43|66|74|81
	|82|102,TC:nil,Content:0,EDM:5,IP:-2,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-UUID: 3ef02798a8d611efa216b1d71e6e1362-20241122
X-User: xiaopei01@kylinos.cn
Received: from xp-virtual-machine.. [(119.39.76.12)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 244390903; Fri, 22 Nov 2024 21:32:40 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
Cc: syzkaller-bugs@googlegroups.com,
	Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] netfilter: nf_tables: Use get_cpu_ptr in nft_inner_eval
Date: Fri, 22 Nov 2024 21:32:13 +0800
Message-Id: <804e05fe4615cfd51f0cc72307f578ea34a701b4.1732281838.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <673fca0e.050a0220.363a1b.012a.GAE@google.com>
References: <673fca0e.050a0220.363a1b.012a.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot complain about using smp_processor_id in preemptible.
use get_cpu_ptr to preempt_disable.

BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 1 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=84d0441b9860f0d63285
Fixes: 0e795b37ba04 ("netfilter: nft_inner: add percpu inner context")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 net/netfilter/nft_inner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 928312d01eb1..ae85851bab77 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -248,7 +248,7 @@ static bool nft_inner_parse_needed(const struct nft_inner *priv,
 static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
 {
-	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	struct nft_inner_tun_ctx *tun_ctx = get_cpu_ptr(&nft_pcpu_tun_ctx);
 	const struct nft_inner *priv = nft_expr_priv(expr);
 
 	if (nft_payload_inner_offset(pkt) < 0)
-- 
2.34.1

