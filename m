From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 09/11] Minor __nf_ct_refresh_acct() whitespace cleanup
Date: Wed, 01 Nov 2006 22:08:54 +0100
Message-ID: <20061101210914.498422106@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=__nf_ct_refresh_acct-cleanup
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

Minor whitespace cleanup.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 net/netfilter/nf_conntrack_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:10.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:13.000000000 +0100
@@ -878,9 +878,11 @@ void __nf_ct_refresh_acct(struct nf_conn
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
 			skb->len - (unsigned int)(skb->nh.raw - skb->data);
-	if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-	    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-		event |= IPCT_COUNTER_FILLING;
+
+		if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
+		    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000)) {
+			event |= IPCT_COUNTER_FILLING;
+		}
 	}
 #endif
 

--
/Martin
