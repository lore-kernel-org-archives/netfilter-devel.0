From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: Fix small information leak in SO_ORIGINAL_DST
	(CVE-2006-1343)
Date: Mon, 29 May 2006 01:06:31 +0200 (MEST)
Message-ID: <20060528230631.6318.43002.sendpatchset@localhost.localdomain>
References: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Fix small information leak in SO_ORIGINAL_DST (CVE-2006-1343)

It appears that sockaddr_in.sin_zero is not zeroed during
getsockopt(...SO_ORIGINAL_DST...) operation. This can lead
to an information leak (CVE-2006-1343).

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 31ce0405d43d58f359431362ef676735d8ccc7eb
tree fac8f79c318f37d4cb6795e540b77be61c9d1f5d
parent 705af309505681f197f81618440954d10f120dc0
author Marcel Holtmann <marcel@holtmann.org> Fri, 26 May 2006 16:34:34 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 26 May 2006 16:34:34 +0200

 net/ipv4/netfilter/ip_conntrack_core.c         |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 979a2ea..a297da7 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1318,6 +1318,7 @@ getorigdst(struct sock *sk, int optval, 
 			.tuple.dst.u.tcp.port;
 		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.ip;
+		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
 
 		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
 		       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5bc9f64..77d9744 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -348,6 +348,7 @@ getorigdst(struct sock *sk, int optval, 
 			.tuple.dst.u.tcp.port;
 		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.u3.ip;
+		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
 
 		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
 		       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
