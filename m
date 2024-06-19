Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981C8155386;
	Wed, 19 Jun 2024 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816754; cv=none; b=M6upv+uP6mBN3z2JIs1AOAfJ8h4Yskl9bDKpuRq3esjgMVwfq57s23rkfVrC7fHUhSLF1bsyMg798sE6wjuB4dB6gaI7ny1DfwZQukvrCxvyoEkRnChBGbhVHd/0FmfGyKfbjgm6ZNsGzBaHn9dojR0898sYj+9lOEifWv5Cvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816754; c=relaxed/simple;
	bh=5jL9Ly/pKLGqRlM2BXQaVGsUiVRHyC4DgcHE5FynEh4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HRh0OWuSLlJyFzr9AmYMj569B7uZls7n2jq20ILG77qT9ifLZ9tzU2fDs2Vp2GX/dR+aFAUTWa9J55+ZU+xnZXgi2Dmkge4i5VX4i2hklD7Tcj8966YCvYPfymkIxGhs3GLQArV4+FR8UGprcMrNHdRC/yrcMLBoYV2iGtHQhgY=
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
Subject: [PATCH net 2/5] seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors
Date: Wed, 19 Jun 2024 19:05:34 +0200
Message-Id: <20240619170537.2846-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240619170537.2846-1-pablo@netfilter.org>
References: <20240619170537.2846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianguo Wu <wujianguo@chinatelecom.cn>

input_action_end_dx4() and input_action_end_dx6() are called NF_HOOK() for
PREROUTING hook, in PREROUTING hook, we should passing a valid indev,
and a NULL outdev to NF_HOOK(), otherwise may trigger a NULL pointer
dereference, as below:

    [74830.647293] BUG: kernel NULL pointer dereference, address: 0000000000000090
    [74830.655633] #PF: supervisor read access in kernel mode
    [74830.657888] #PF: error_code(0x0000) - not-present page
    [74830.659500] PGD 0 P4D 0
    [74830.660450] Oops: 0000 [#1] PREEMPT SMP PTI
    ...
    [74830.664953] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
    [74830.666569] RIP: 0010:rpfilter_mt+0x44/0x15e [ipt_rpfilter]
    ...
    [74830.689725] Call Trace:
    [74830.690402]  <IRQ>
    [74830.690953]  ? show_trace_log_lvl+0x1c4/0x2df
    [74830.692020]  ? show_trace_log_lvl+0x1c4/0x2df
    [74830.693095]  ? ipt_do_table+0x286/0x710 [ip_tables]
    [74830.694275]  ? __die_body.cold+0x8/0xd
    [74830.695205]  ? page_fault_oops+0xac/0x140
    [74830.696244]  ? exc_page_fault+0x62/0x150
    [74830.697225]  ? asm_exc_page_fault+0x22/0x30
    [74830.698344]  ? rpfilter_mt+0x44/0x15e [ipt_rpfilter]
    [74830.699540]  ipt_do_table+0x286/0x710 [ip_tables]
    [74830.700758]  ? ip6_route_input+0x19d/0x240
    [74830.701752]  nf_hook_slow+0x3f/0xb0
    [74830.702678]  input_action_end_dx4+0x19b/0x1e0
    [74830.703735]  ? input_action_end_t+0xe0/0xe0
    [74830.704734]  seg6_local_input_core+0x2d/0x60
    [74830.705782]  lwtunnel_input+0x5b/0xb0
    [74830.706690]  __netif_receive_skb_one_core+0x63/0xa0
    [74830.707825]  process_backlog+0x99/0x140
    [74830.709538]  __napi_poll+0x2c/0x160
    [74830.710673]  net_rx_action+0x296/0x350
    [74830.711860]  __do_softirq+0xcb/0x2ac
    [74830.713049]  do_softirq+0x63/0x90

input_action_end_dx4() passing a NULL indev to NF_HOOK(), and finally
trigger a NULL dereference in rpfilter_mt()->rpfilter_is_loopback():

    static bool
    rpfilter_is_loopback(const struct sk_buff *skb,
          	       const struct net_device *in)
    {
            // in is NULL
            return skb->pkt_type == PACKET_LOOPBACK ||
          	 in->flags & IFF_LOOPBACK;
    }

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/seg6_local.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 24e2b4b494cb..c434940131b1 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -941,8 +941,8 @@ static int input_action_end_dx6(struct sk_buff *skb,
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
-			       dev_net(skb->dev), NULL, skb, NULL,
-			       skb_dst(skb)->dev, input_action_end_dx6_finish);
+			       dev_net(skb->dev), NULL, skb, skb->dev,
+			       NULL, input_action_end_dx6_finish);
 
 	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -991,8 +991,8 @@ static int input_action_end_dx4(struct sk_buff *skb,
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
-			       dev_net(skb->dev), NULL, skb, NULL,
-			       skb_dst(skb)->dev, input_action_end_dx4_finish);
+			       dev_net(skb->dev), NULL, skb, skb->dev,
+			       NULL, input_action_end_dx4_finish);
 
 	return input_action_end_dx4_finish(dev_net(skb->dev), NULL, skb);
 drop:
-- 
2.30.2

