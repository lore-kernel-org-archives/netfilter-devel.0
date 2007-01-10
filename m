From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT
	value
Date: Wed, 10 Jan 2007 08:04:49 +0100 (MET)
Message-ID: <20070110070448.13495.34404.sendpatchset@localhost.localdomain>
References: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
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
commit c209c563107b15f3c452266b5c2e5bd0fa75a470
tree 5523490f570660543e8866ab7add54a7694f749d
parent 19dd639a05e28a91962032bcb820437068023095
author Patrick McHardy <kaber@trash.net> Wed, 10 Jan 2007 05:44:18 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 10 Jan 2007 05:44:18 +0100

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
 
