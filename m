From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [RFC][PATCH] {ip,nf}_conntrack: fix infinite loop on clearnup
Date: Sun, 25 Dec 2005 16:34:53 +0900 (JST)
Message-ID: <200512250734.jBP7YsM1006458@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Dec_25_16_34_53_2005_248)--"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Sun_Dec_25_16_34_53_2005_248)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, all,

I noticed that "rmmod nf_conntrack_ipv4" didn't return in some situations.
But "rmmod ip_conntrack" could return immediately.

I struggled with this problem and found the reason, but I think it's too bad
timing to fix. So I want comments whether my temporary fix is preferable or
not.

The datail is as follows. For example, if incoming packets are dropped after
PRE_ROUTING, bound conntrack to it is unconfirmed and grabbed by only event
cache. In this situation, if users try to unload l3proto or proto module,
nf_ct_iterate_cleanup() goes to loop which gets and puts it, until the event
cache of it is delivered. But it might not be delivered forever.

I think that the origin of the problem is that event cache isn't deliverd
when skb has been freed. Then best solution is to force to deliver it
at that point, I think.

But to do that, we have to add a function to include/linux/skbuff.h
and use it in net/core/skbuff.c like nf_conntrack_put(). I'm not sure such
change is applied at this timing. I feel 2.6.15 is released soon.

Then 2nd solution is attached patch which forces to deliver event cache
at nf_ct_iterate_cleanup().

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

About ip_conntrack, this problem arises only when unloading
ip_conntrack_sctp.ko after dropping some SCTP packets. So that's rere case,
I think.

Comments ?

-- Yasuyuki Kozakai

----Next_Part(Sun_Dec_25_16_34_53_2005_248)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-cleanup.patch"

[NETFILTER] {ip,nf}_conntrack: fix infinite loop on clearnup

For example, if incoming packets are dropped after PRE_ROUTING, bound
conntrack to it is unconfirmed and grabbed by only event cache. In this
situation, if users try to unload l3proto or proto module,
nf_ct_iterate_cleanup() goes to loop which gets and puts it,
until the event cache of it is delivered. But it might not be delivered
forever. 

This fix forces to deliver the event cache of the conntrack
before putting it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 581e05e15a8e6b699d663b5c89afcd3015ca0a7d
tree ea52413401bce5274f1aa0033fa9f41b90465390
parent cdcdb28623fb74d9564b102cd1cbe3854071e855
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 25 Dec 2005 13:43:01 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 25 Dec 2005 13:43:01 +0900

 net/ipv4/netfilter/ip_conntrack_core.c |    1 +
 net/netfilter/nf_conntrack_core.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 84c66db..128861c 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1274,6 +1274,7 @@ ip_ct_iterate_cleanup(int (*iter)(struct
 			death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
+		ip_ct_deliver_cached_events(ct);
 		ip_conntrack_put(ct);
 	}
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a7c7b49..31b0313 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1347,6 +1347,7 @@ nf_ct_iterate_cleanup(int (*iter)(struct
 			death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
+		nf_ct_deliver_cached_events(ct);
 		nf_ct_put(ct);
 	}
 }

----Next_Part(Sun_Dec_25_16_34_53_2005_248)----
