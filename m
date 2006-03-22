From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/10]: Fix undefined references to get_h225_addr
Date: Wed, 22 Mar 2006 19:47:58 +0100 (MET)
Message-ID: <20060322184758.5655.168.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix undefined references to get_h225_addr

get_h225_addr is exported, but declared static, which fails when linking
statically.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcfb97c3f64155032c1730210967011b216e5089
tree fe3fa93a8c3d6c777267cd968b0663d725e5743e
parent bcf32a11bc08c3fbf6e983a68ab2a40e95f22e43
author Patrick McHardy <kaber@trash.net> Wed, 22 Mar 2006 18:44:41 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 22 Mar 2006 18:44:41 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 20da673..daeb139 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -639,8 +639,8 @@ void ip_conntrack_h245_expect(struct ip_
 }
 
 /****************************************************************************/
-static int get_h225_addr(unsigned char *data, TransportAddress * addr,
-			 u_int32_t * ip, u_int16_t * port)
+int get_h225_addr(unsigned char *data, TransportAddress * addr,
+		  u_int32_t * ip, u_int16_t * port)
 {
 	unsigned char *p;
 
