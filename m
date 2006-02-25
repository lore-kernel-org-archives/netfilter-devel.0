From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/6]: nf_queue: fix end-of-list check
Date: Sat, 25 Feb 2006 14:18:38 +0100 (MET)
Message-ID: <20060225131657.7400.27087.sendpatchset@localhost.localdomain>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_queue: fix end-of-list check

The comparison wants to find out if the last list iteration reached the
end of the list. It needs to compare the iterator with the list head to
do this, not the element it is looking for.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 37fcebcd2adf3cd2124437ff1fb7836be0a9c207
tree a0a6c39916362c4b1f7125282d66d97c67a397fa
parent 021fe2cbea0df98012b8c96e55855622f885817d
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:47 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:47 +0100

 net/netfilter/nf_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 913df7d..d9f0d7e 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -214,7 +214,7 @@ void nf_reinject(struct sk_buff *skb, st
   			break;
   	}
   
-	if (elem == &nf_hooks[info->pf][info->hook]) {
+	if (i == &nf_hooks[info->pf][info->hook]) {
 		/* The module which sent it to userspace is gone. */
 		NFDEBUG("%s: module disappeared, dropping packet.\n",
 			__FUNCTION__);
