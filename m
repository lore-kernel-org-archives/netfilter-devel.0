From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: conntrack: fix SYSCTL=n compile
Date: Tue, 25 Jul 2006 05:26:56 +0200 (MEST)
Message-ID: <20060725032656.25063.63057.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: fix SYSCTL=n compile

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4aed24265c0b6270d328362ff66b51fed56a9d1a
tree fd66f207da170da399330d7dbc26691b8a8a7488
parent 559fa54b6c0d2813de1d4753964587fc3655bbf1
author Adrian Bunk <bunk@stusta.de> Tue, 25 Jul 2006 00:04:54 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:04:54 +0200

 net/ipv4/netfilter/ip_conntrack_standalone.c |    4 ++--
 net/netfilter/nf_conntrack_standalone.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 7bd3c22..7a9fa04 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -534,6 +534,8 @@ static struct nf_hook_ops ip_conntrack_o
 
 /* Sysctl support */
 
+int ip_conntrack_checksum = 1;
+
 #ifdef CONFIG_SYSCTL
 
 /* From ip_conntrack_core.c */
@@ -568,8 +570,6 @@ extern unsigned int ip_ct_generic_timeou
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
 
-int ip_conntrack_checksum = 1;
-
 static struct ctl_table_header *ip_ct_sysctl_header;
 
 static ctl_table ip_ct_sysctl_table[] = {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 5fcab2e..4ef8366 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -428,6 +428,8 @@ #endif /* CONFIG_PROC_FS */
 
 /* Sysctl support */
 
+int nf_conntrack_checksum = 1;
+
 #ifdef CONFIG_SYSCTL
 
 /* From nf_conntrack_core.c */
@@ -459,8 +461,6 @@ extern unsigned int nf_ct_generic_timeou
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
 
-int nf_conntrack_checksum = 1;
-
 static struct ctl_table_header *nf_ct_sysctl_header;
 
 static ctl_table nf_ct_sysctl_table[] = {
