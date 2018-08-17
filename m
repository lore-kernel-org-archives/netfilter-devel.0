From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/15] netfilter: doc: Add nf_tables part in tproxy.txt
Date: Fri, 17 Aug 2018 21:41:02 +0200
Message-ID: <20180817194106.2878-2-pablo@netfilter.org>
References: <20180817194106.2878-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817194106.2878-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

Recently, transparent proxy support has been added to nf_tables so that
this document should be updated with the new information.

- Nft commands are added as alternatives to iptables ones.
- The link for a patched iptables is removed as it is already part of
  the mainline iptables implementation (and the link is dead).
- tcprdr is added as an example implementation of a transparent proxy

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: KOVACS Krisztian <hidden@sch.bme.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/tproxy.txt | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/tproxy.txt b/Documentation/networking/tproxy.txt
index ec11429e1d42..b9a188823d9f 100644
--- a/Documentation/networking/tproxy.txt
+++ b/Documentation/networking/tproxy.txt
@@ -5,19 +5,28 @@ This feature adds Linux 2.2-like transparent proxy support to current kernels.
 To use it, enable the socket match and the TPROXY target in your kernel config.
 You will need policy routing too, so be sure to enable that as well.
 
+From Linux 4.18 transparent proxy support is also available in nf_tables.
 
 1. Making non-local sockets work
 ================================
 
 The idea is that you identify packets with destination address matching a local
-socket on your box, set the packet mark to a certain value, and then match on that
-value using policy routing to have those packets delivered locally:
+socket on your box, set the packet mark to a certain value:
 
 # iptables -t mangle -N DIVERT
 # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
 # iptables -t mangle -A DIVERT -j MARK --set-mark 1
 # iptables -t mangle -A DIVERT -j ACCEPT
 
+Alternatively you can do this in nft with the following commands:
+
+# nft add table filter
+# nft add chain filter divert "{ type filter hook prerouting priority -150; }"
+# nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
+
+And then match on that value using policy routing to have those packets
+delivered locally:
+
 # ip rule add fwmark 1 lookup 100
 # ip route add local 0.0.0.0/0 dev lo table 100
 
@@ -57,17 +66,28 @@ add rules like this to the iptables ruleset above:
 # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
   --tproxy-mark 0x1/0x1 --on-port 50080
 
+Or the following rule to nft:
+
+# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
+
 Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
 IP_TRANSPARENT) for the listening socket.
 
+As an example implementation, tcprdr is available here:
+https://git.breakpoint.cc/cgit/fw/tcprdr.git/
+This tool is written by Florian Westphal and it was used for testing during the
+nf_tables implementation.
 
-3. Iptables extensions
-======================
+3. Iptables and nf_tables extensions
+====================================
 
-To use tproxy you'll need to have the 'socket' and 'TPROXY' modules
-compiled for iptables. A patched version of iptables is available
-here: http://git.balabit.hu/?p=bazsi/iptables-tproxy.git
+To use tproxy you'll need to have the following modules compiled for iptables:
+ - NETFILTER_XT_MATCH_SOCKET
+ - NETFILTER_XT_TARGET_TPROXY
 
+Or the floowing modules for nf_tables:
+ - NFT_SOCKET
+ - NFT_TPROXY
 
 4. Application support
 ======================
-- 
2.11.0
