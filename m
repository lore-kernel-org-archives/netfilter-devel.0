From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/17]: SNMP helper: fix debug module param type
Date: Tue, 30 May 2006 00:34:25 +0200 (MEST)
Message-ID: <20060529223425.24834.8944.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: SNMP helper: fix debug module param type

debug is the debug level, not a bool.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1782413b89b52410a4df654860145bc2a27db194
tree c7d0a7dea3b9a8b9260cc0500bfe702b62254de8
parent 33f076517f429291fcd71b128d3f14b141e3cbdc
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:34 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:34 +0200

 net/ipv4/netfilter/ip_nat_snmp_basic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_snmp_basic.c b/net/ipv4/netfilter/ip_nat_snmp_basic.c
index c332442..d20d557 100644
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c
@@ -1348,4 +1348,4 @@ static void __exit ip_nat_snmp_basic_fin
 module_init(ip_nat_snmp_basic_init);
 module_exit(ip_nat_snmp_basic_fini);
 
-module_param(debug, bool, 0600);
+module_param(debug, int, 0600);
