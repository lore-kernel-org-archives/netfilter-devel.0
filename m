From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 19/19]: fix stats in __ip_conntrack_confirm
Date: Mon, 25 Oct 2004 02:50:11 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DC3.3060604@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010804030804050500000509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
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
--------------010804030804050500000509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

net_rx_softirq can preempt the calling process while incrementing the stats,
call CONNTRACK_STAT_INC within the locked section.



--------------010804030804050500000509
Content-Type: text/x-patch;
 name="19.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="19.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/25 01:11:17+02:00 pablo@eurodev.net 
#   [NETFILTER]: fix stats in __ip_conntrack_confirm
#   
#   net_rx_softirq can preempt the calling process while incrementing the stats.
#   I think that we can fix this moving both CONNTRACK_STAT_INC to the locked
#   section. 
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/10/25 01:11:10+02:00 pablo@eurodev.net +3 -2
#   [NETFILTER]: fix stats in __ip_conntrack_confirm
#   
#   net_rx_softirq can preempt the calling process while incrementing the stats.
#   I think that we can fix this moving both CONNTRACK_STAT_INC to the locked
#   section. 
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-25 01:14:06 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-25 01:14:06 +02:00
@@ -434,13 +434,14 @@
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
 

--------------010804030804050500000509--
