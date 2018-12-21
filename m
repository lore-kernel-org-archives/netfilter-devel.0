From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 30/37] netfilter: conntrack: udp: set stream timeout to 2 minutes
Date: Fri, 21 Dec 2018 01:28:34 +0100
Message-ID: <20181221002841.28587-31-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We have no explicit signal when a UDP stream has terminated, peers just
stop sending.

For suspected stream connections a timeout of two minutes is sane to keep
NAT mapping alive a while longer.

It matches tcp conntracks 'timewait' default timeout value.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.txt | 2 +-
 net/netfilter/nf_conntrack_proto_udp.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index 1669dc2419fd..e69b2e6a4a29 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -157,7 +157,7 @@ nf_conntrack_udp_timeout - INTEGER (seconds)
 	default 30
 
 nf_conntrack_udp_timeout_stream - INTEGER (seconds)
-	default 180
+	default 120
 
 	This extended timeout will be used in case there is an UDP stream
 	detected.
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 9f2e05adba69..b4f5d5e82031 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -29,7 +29,7 @@
 
 static const unsigned int udp_timeouts[UDP_CT_MAX] = {
 	[UDP_CT_UNREPLIED]	= 30*HZ,
-	[UDP_CT_REPLIED]	= 180*HZ,
+	[UDP_CT_REPLIED]	= 120*HZ,
 };
 
 static unsigned int *udp_get_timeouts(struct net *net)
-- 
2.11.0
