From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT
	value
Date: Tue,  9 Jan 2007 17:29:57 +0100 (MET)
Message-ID: <20070109162957.6229.95451.sendpatchset@localhost.localdomain>
References: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
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

[NETFILTER]: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value

IP_CT_TCP_FLAG_CLOSE_INIT is a flag and should have a value of 0x4 instead
of 0x3, which is IP_CT_TCP_FLAG_WINDOW_SCALE | IP_CT_TCP_FLAG_SACK_PERM.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7931808e6b7fb622372dcff7dad12f39d9d1d943
tree a81259cc0e8bb657baed2582655a3e99a3f05351
parent 36e2c322ad2424a161b8a2a89c251dc9c71764bb
author Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 15:27:34 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 09 Jan 2007 15:27:34 +0100

 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 6b01ba2..2f4e98b 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -25,7 +25,7 @@ #define IP_CT_TCP_FLAG_WINDOW_SCALE		0x0
 #define IP_CT_TCP_FLAG_SACK_PERM		0x02
 
 /* This sender sent FIN first */
-#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
+#define IP_CT_TCP_FLAG_CLOSE_INIT		0x04
 
 #ifdef __KERNEL__
 
