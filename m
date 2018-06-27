From: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH v2 net-next 2/2] skbuff: preserve sock reference when scrubbing the skb.
Date: Wed, 27 Jun 2018 10:34:26 -0300
Message-ID: <20180627133426.3858-3-fbl@redhat.com>
References: <20180627133426.3858-1-fbl@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Flavio Leitner <fbl@redhat.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627133426.3858-1-fbl@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The sock reference is lost when scrubbing the packet and that breaks
TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
performance impacts of about 50% in a single TCP stream when crossing
network namespaces.

XPS breaks because the queue mapping stored in the socket is not
available, so another random queue might be selected when the stack
needs to transmit something like a TCP ACK, or TCP Retransmissions.
That causes packet re-ordering and/or performance issues.

TSQ breaks because it orphans the packet while it is still in the
host, so packets are queued contributing to the buffer bloat problem.

Preserving the sock reference fixes both issues. The socket is
orphaned anyways in the receiving path before any relevant action
and on TX side the netfilter checks if the reference is local before
use it.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 Documentation/networking/ip-sysctl.txt | 10 +++++-----
 net/core/skbuff.c                      |  1 -
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ce8fbf5aa63c..f4c042be0216 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -733,11 +733,11 @@ tcp_limit_output_bytes - INTEGER
 	Controls TCP Small Queue limit per tcp socket.
 	TCP bulk sender tends to increase packets in flight until it
 	gets losses notifications. With SNDBUF autotuning, this can
-	result in a large amount of packets queued in qdisc/device
-	on the local machine, hurting latency of other flows, for
-	typical pfifo_fast qdiscs.
-	tcp_limit_output_bytes limits the number of bytes on qdisc
-	or device to reduce artificial RTT/cwnd and reduce bufferbloat.
+	result in a large amount of packets queued on the local machine
+	(e.g.: qdiscs, CPU backlog, or device) hurting latency of other
+	flows, for typical pfifo_fast qdiscs.  tcp_limit_output_bytes
+	limits the number of bytes on qdisc or device to reduce artificial
+	RTT/cwnd and reduce bufferbloat.
 	Default: 262144
 
 tcp_challenge_ack_limit - INTEGER
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b1f274f22d85..f59e98ca72c5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4911,7 +4911,6 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 		return;
 
 	ipvs_reset(skb);
-	skb_orphan(skb);
 	skb->mark = 0;
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
-- 
2.14.3
