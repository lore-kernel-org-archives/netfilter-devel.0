From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 05/15] netfilter: xt_LOG: fix mark logging for IPv6 packets
Date: Tue,  2 Jul 2013 16:50:55 +0200
Message-ID: <1372776665-6795-5-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: Michal Kube=C4=8Dek <mkubecek@suse.cz>

In dump_ipv6_packet(), the "recurse" parameter is zero only if
dumping contents of a packet embedded into an ICMPv6 error
message. Therefore we want to log packet mark if recurse is
non-zero, not when it is zero.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: d660164d79b67f879db35a7d61e47d3b99bc714e

 net/netfilter/xt_LOG.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index fa40096..ca402a7 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -730,7 +730,7 @@ static void dump_ipv6_packet(struct sbuff *m,
 		dump_sk_uid_gid(m, skb->sk);
=20
 	/* Max length: 16 "MARK=3D0xFFFFFFFF " */
-	if (!recurse && skb->mark)
+	if (recurse && skb->mark)
 		sb_add(m, "MARK=3D0x%x ", skb->mark);
 }
=20
--=20
1.7.10.4
