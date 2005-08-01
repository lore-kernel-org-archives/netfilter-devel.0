From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 2/6]: Fix deadlock with ip_queue/ip6_queue
Date: Mon, 01 Aug 2005 02:42:25 +0200
Message-ID: <42ED6FF1.2020803@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="2.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="2.diff"
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

[NETFILTER]: Fix deadlock with ip_queue/ip6_queue

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 36d73751283413992a12837f7a6e4116b9e70d3f
tree cd19a0c9a2e183b887ef5fc8cfec8682fe3b24e3
parent 2a330e4e1da97267e1dd4a2ed3f8cd7cabdf21ca
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 18:48:38 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 18:48:38 +0200

 net/ipv4/netfilter/ip_queue.c  |    2 ++
 net/ipv6/netfilter/ip6_queue.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -62,7 +62,9 @@ static DECLARE_MUTEX(ipqnl_sem);
 static void
 ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 {
+	local_bh_disable();
 	nf_reinject(entry->skb, entry->info, verdict);
+	local_bh_enable();
 	kfree(entry);
 }
 
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -68,7 +68,9 @@ static DECLARE_MUTEX(ipqnl_sem);
 static void
 ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 {
+	local_bh_disable();
 	nf_reinject(entry->skb, entry->info, verdict);
+	local_bh_enable();
 	kfree(entry);
 }
 
