From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: arp_tables: missing unregistration on module
	unload
Date: Thu, 12 Oct 2006 11:54:21 +0200 (MEST)
Message-ID: <20061012095550.11462.1768.sendpatchset@localhost.localdomain>
References: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
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

---
commit 7f7a882296c917251a7936b41ee001e545a09e6c
tree 9cf7af01ce1b1d8e97caa59d6efceeefab9a3b5b
parent c7b1507f3c040c02efa1b955f7180a33a232c4d9
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 09:24:54 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 09:24:54 +0200

 net/ipv4/netfilter/arp_tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 17e1a68..0849f1c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1196,6 +1196,8 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
+	xt_unregister_target(&arpt_error_target);
+	xt_unregister_target(&arpt_standard_target);
 	xt_proto_fini(NF_ARP);
 }
 
