From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/15] netfilter: Fix handling simultaneous open in TCP conntrack
Date: Mon, 14 May 2018 00:36:42 +0200
Message-ID: <20180513223656.10077-2-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Dominique Martinet reported a TCP hang problem when simultaneous open was used.
The problem is that the tcp_conntracks state table is not smart enough
to handle the case. The state table could be fixed by introducing a new state,
but that would require more lines of code compared to this patch, due to the
required backward compatibility with ctnetlink.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: Dominique Martinet <asmadeus@codewreck.org>
Tested-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_tcp.h |  3 +++
 net/netfilter/nf_conntrack_proto_tcp.c          | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_tcp.h b/include/uapi/linux/netfilter/nf_conntrack_tcp.h
index 74b91151d494..bcba72def817 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tcp.h
@@ -46,6 +46,9 @@ enum tcp_conntrack {
 /* Marks possibility for expected RFC5961 challenge ACK */
 #define IP_CT_EXP_CHALLENGE_ACK 		0x40
 
+/* Simultaneous open initialized */
+#define IP_CT_TCP_SIMULTANEOUS_OPEN		0x80
+
 struct nf_ct_tcp_flags {
 	__u8 flags;
 	__u8 mask;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e97cdc1cf98c..8e67910185a0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -981,6 +981,17 @@ static int tcp_packet(struct nf_conn *ct,
 			return NF_ACCEPT; /* Don't change state */
 		}
 		break;
+	case TCP_CONNTRACK_SYN_SENT2:
+		/* tcp_conntracks table is not smart enough to handle
+		 * simultaneous open.
+		 */
+		ct->proto.tcp.last_flags |= IP_CT_TCP_SIMULTANEOUS_OPEN;
+		break;
+	case TCP_CONNTRACK_SYN_RECV:
+		if (dir == IP_CT_DIR_REPLY && index == TCP_ACK_SET &&
+		    ct->proto.tcp.last_flags & IP_CT_TCP_SIMULTANEOUS_OPEN)
+			new_state = TCP_CONNTRACK_ESTABLISHED;
+		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET)
-- 
2.11.0
