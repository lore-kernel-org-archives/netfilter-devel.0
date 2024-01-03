Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DCB18EA6;
	Wed,  3 Jan 2024 11:30:07 +0000 (UTC)
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
Subject: [PATCH net 1/2] netfilter: nf_nat: fix action not being set for all ct states
Date: Wed,  3 Jan 2024 12:30:00 +0100
Message-Id: <20240103113001.137936-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240103113001.137936-1-pablo@netfilter.org>
References: <20240103113001.137936-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Brad Cowie <brad@faucet.nz>

This fixes openvswitch's handling of nat packets in the related state.

In nf_ct_nat_execute(), which is called from nf_ct_nat(), ICMP/ICMPv6
packets in the IP_CT_RELATED or IP_CT_RELATED_REPLY state, which have
not been dropped, will follow the goto, however the placement of the
goto label means that updating the action bit field will be bypassed.

This causes ovs_nat_update_key() to not be called from ovs_ct_nat()
which means the openvswitch match key for the ICMP/ICMPv6 packet is not
updated and the pre-nat value will be retained for the key, which will
result in the wrong openflow rule being matched for that packet.

Move the goto label above where the action bit field is being set so
that it is updated in all cases where the packet is accepted.

Fixes: ebddb1404900 ("net: move the nat function to nf_nat_ovs for ovs and tc")
Signed-off-by: Brad Cowie <brad@faucet.nz>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_ovs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_ovs.c b/net/netfilter/nf_nat_ovs.c
index 551abd2da614..0f9a559f6207 100644
--- a/net/netfilter/nf_nat_ovs.c
+++ b/net/netfilter/nf_nat_ovs.c
@@ -75,9 +75,10 @@ static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+out:
 	if (err == NF_ACCEPT)
 		*action |= BIT(maniptype);
-out:
+
 	return err;
 }
 
-- 
2.30.2

