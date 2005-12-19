From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: Fix NAT init order
Date: Mon, 19 Dec 2005 11:21:48 +0100
Message-ID: <43A689BC.8080408@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020002080902000405060105"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020002080902000405060105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two simple bugfixes which should go in 2.6.15
if possible.



--------------020002080902000405060105
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Fix NAT init order

As noticed by Phil Oester, the GRE NAT protocol helper is initialized
before the NAT core, which makes registration fail.

Change the linking order to make NAT be initialized first.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 87704c86b3406255a2b68b1d1a68ff72baa6177e
tree 349f73319574ccb3a02acaefab7cec8edaa798f6
parent afe1ec2b866d310f47db2f368f1f4a7b4961ffed
author Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:17:20 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:17:20 +0100

 net/ipv4/netfilter/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 058c48e..d0a447e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -12,6 +12,7 @@ ip_nat_pptp-objs	:= ip_nat_helper_pptp.o
 
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_IP_NF_NAT) += ip_nat.o
 
 # conntrack netlink interface
 obj-$(CONFIG_IP_NF_CONNTRACK_NETLINK) += ip_conntrack_netlink.o
@@ -41,7 +42,7 @@ obj-$(CONFIG_IP_NF_IPTABLES) += ip_table
 # the three instances of ip_tables
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
-obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o ip_nat.o
+obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches

--------------020002080902000405060105--
