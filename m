From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/5]: Fix deadlock in ip6_queue
Date: Fri, 22 Jul 2005 09:35:34 +0200
Message-ID: <42E0A1C6.3040300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060501020806030207080709"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------060501020806030207080709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are a couple of patches for 2.6.13. I've CCed
stable@kernel.org on all patches that I think should also
go in -stable.

Regards
Patrick

--------------060501020806030207080709
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Fix deadlock in ip6_queue

Already fixed in ip_queue, ip6_queue was missed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bbdfd0b519cf535692a25adc5aa7cab3079220b4
tree 19d321b73864f5078ed2638e227575d0998fe64e
parent f60f700876cd51de9de69f3a3c865d95e287a24d
author Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:21:59 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:21:59 +0200

 net/ipv6/netfilter/ip6_queue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -76,7 +76,9 @@ static DECLARE_MUTEX(ipqnl_sem);
 static void
 ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 {
+	local_bh_disable();
 	nf_reinject(entry->skb, entry->info, verdict);
+	local_bh_enable();
 	kfree(entry);
 }
 

--------------060501020806030207080709--
