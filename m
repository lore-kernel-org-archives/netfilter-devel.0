From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/22] ipvs: Document sysctl sync_ports
Date: Mon, 20 Mar 2017 11:08:47 +0100
Message-ID: <1490004530-9128-20-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

Document sysctl sync_ports based on commit f73181c8288f ("ipvs: add support
for sync threads").

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 Documentation/networking/ipvs-sysctl.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 159d70b6dff3..a6feecd467cd 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -231,6 +231,14 @@ sync_sock_size - INTEGER
 	Configuration of SNDBUF (master) or RCVBUF (slave) socket limit.
 	Default value is 0 (preserve system defaults).
 
+sync_ports - INTEGER
+	default 1
+
+	The number of threads that master and backup servers can use for
+	sync traffic. Every thread will use single UDP port, thread 0 will
+	use the default port 8848 while last thread will use port
+	8848+sync_ports-1.
+
 snat_reroute - BOOLEAN
 	0 - disabled
 	not 0 - enabled (default)
-- 
2.1.4
