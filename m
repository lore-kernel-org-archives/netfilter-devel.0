From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] fix stats in __ip_conntrack_confirm
Date: Thu, 21 Oct 2004 00:30:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4176E6EB.1070008@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040407050409020408000403"
Cc: Eric Lemoine <eric.lemoine@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040407050409020408000403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've been discussing this with Eric. __ip_conntrack_confirm is entered from
both process context and net_rx_softirq context and "++" operations aren't
atomic.

So net_rx_softirq can preempt the calling process while incrementing the 
stats.
I think that we can fix this moving both CONNTRACK_STAT_INC to the locked
section.

regards,
Pablo

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------040407050409020408000403
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== net/ipv4/netfilter/ip_conntrack_core.c 1.62 vs edited =====
--- 1.62/net/ipv4/netfilter/ip_conntrack_core.c	Mon Oct  4 01:23:58 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Mon Oct 18 21:53:02 2004
@@ -490,13 +490,14 @@
 		add_timer(&ct->timeout);
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
-		WRITE_UNLOCK(&ip_conntrack_lock);
 		CONNTRACK_STAT_INC(insert);
+		WRITE_UNLOCK(&ip_conntrack_lock);
 		return NF_ACCEPT;
 	}
 
-	WRITE_UNLOCK(&ip_conntrack_lock);
 	CONNTRACK_STAT_INC(insert_failed);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
 	return NF_DROP;
 }
 

--------------040407050409020408000403--
