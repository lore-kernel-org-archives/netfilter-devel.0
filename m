From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.11]: Clear NAT status bits on module unload
Date: Sat, 05 Feb 2005 03:53:16 +0100
Message-ID: <4204351C.8010701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030607070806010007070608"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------030607070806010007070608
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

another patch which I think should go in 2.6.11, it fixes a crash
when unloading, then reloading iptable_nat.

Regards
Patrick



--------------030607070806010007070608
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/05 03:49:38+01:00 kaber@coreworks.de 
#   [NETFILTER]: Clear NAT status bits on module unload
#   
#   ip_nat_core doesn't clear the status bits in struct ip_conntrack on
#   module unload, but zeroes out the nat area. When the module is loaded
#   again and a connection times out ip_nat_cleanup_conntrack tries to
#   list_del the zeroed list-head and crashes. There are probably more
#   conditions under which it can crash or cause other misbehaviour.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2005/02/05 03:49:28+01:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: Clear NAT status bits on module unload
#   
#   ip_nat_core doesn't clear the status bits in struct ip_conntrack on
#   module unload, but zeroes out the nat area. When the module is loaded
#   again and a connection times out ip_nat_cleanup_conntrack tries to
#   list_del the zeroed list-head and crashes. There are probably more
#   conditions under which it can crash or cause other misbehaviour.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2005-02-05 03:50:14 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2005-02-05 03:50:14 +01:00
@@ -543,6 +543,7 @@
 static int clean_nat(struct ip_conntrack *i, void *data)
 {
 	memset(&i->nat, 0, sizeof(i->nat));
+	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
 

--------------030607070806010007070608--
