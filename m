From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: NAT: silence unused variable warnings with
	CONFIG_XFRM=n
Date: Tue,  2 May 2006 22:48:08 +0200 (MEST)
Message-ID: <20060502204808.7610.69032.sendpatchset@localhost.localdomain>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

[NETFILTER]: NAT: silence unused variable warnings with CONFIG_XFRM=n

net/ipv4/netfilter/ip_nat_standalone.c: In function 'ip_nat_out':
net/ipv4/netfilter/ip_nat_standalone.c:223: warning: unused variable 'ctinfo'
net/ipv4/netfilter/ip_nat_standalone.c:222: warning: unused variable 'ct'

Surprisingly no complaints so far ..

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1a8e196d1f5fbb3c43de5ce4e11c29c66188443c
tree 0474880ecfd42616f11fa8cf41ee6c7022746d53
parent fcf294628012638bc925b2c158c03efea2decb4c
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 22:02:49 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 22:02:49 +0200

 net/ipv4/netfilter/ip_nat_standalone.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 8f760b2..67e6767 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -219,8 +219,10 @@ ip_nat_out(unsigned int hooknum,
 	   const struct net_device *out,
 	   int (*okfn)(struct sk_buff *))
 {
+#ifdef CONFIG_XFRM
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
+#endif
 	unsigned int ret;
 
 	/* root is playing with raw sockets. */
