From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/08]: arp_tables: missing unregistration on module
	unload
Date: Fri, 17 Nov 2006 06:35:46 +0100 (MET)
Message-ID: <20061117053546.10231.16864.sendpatchset@localhost.localdomain>
References: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
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

[NETFILTER]: arp_tables: missing unregistration on module unload

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 6b22b99ecd431b63aece1fa5b1faa01b75a8302e
tree 7969fd96d4daad6eaf8a10a0659702ca3e404439
parent 0ef4760e162ea44c847cca7393b36e5bcac5414e
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:24:43 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:24:43 +0100

 net/ipv4/netfilter/arp_tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 9ea7869..aff5cb5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1211,6 +1211,8 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
+	xt_unregister_target(&arpt_error_target);
+	xt_unregister_target(&arpt_standard_target);
 	xt_proto_fini(NF_ARP);
 }
 
