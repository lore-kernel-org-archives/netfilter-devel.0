From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/10] netfilter: Fix removal of GRE expectation entries created by PPTP
Date: Wed, 11 Nov 2015 18:33:39 +0100
Message-ID: <1447263223-22662-7-git-send-email-pablo@netfilter.org>
References: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>

The uninitialized tuple structure caused incorrect hash calculation
and the lookup failed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=106441
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_pptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 657d230..b3ca21b 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -45,7 +45,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	struct net *net = nf_ct_net(ct);
 	const struct nf_conn *master = ct->master;
 	struct nf_conntrack_expect *other_exp;
-	struct nf_conntrack_tuple t;
+	struct nf_conntrack_tuple t = {};
 	const struct nf_ct_pptp_master *ct_pptp_info;
 	const struct nf_nat_pptp *nat_pptp_info;
 	struct nf_nat_range range;
-- 
2.1.4
