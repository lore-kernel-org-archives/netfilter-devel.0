From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 2/2] missing header for nf_conntrack tcp/udp
Date: Thu, 01 Sep 2005 13:11:09 +0900 (JST)
Message-ID: <200509010411.j814BA5g014973@toshiba.co.jp>
References: <200509010400.j8140uSW028989@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_13_11_09_2005_286)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200509010400.j8140uSW028989@toshiba.co.jp>
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

----Next_Part(Thu_Sep__1_13_11_09_2005_286)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Sorry for missing patch. :(

# mh, recently there are many misstakes... Clame down, me...

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 01 Sep 2005 13:00:55 +0900 (JST)

> 
> This patch fixes compling error where IPv6 stack isn't build.
> In this case, in6_addr is undefined.
> 
> Please apply to nf_conntrack tree.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> 

----Next_Part(Thu_Sep__1_13_11_09_2005_286)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-ipv6tcpudp.patch"

[NETFILTER] missing header for nf_conntrack tcp/udp

This patch fixes compling error where IPv6 stack isn't build.
In this case, in6_addr is undefined.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit fd181f7707c662f9a8b0dd8a284040b8d3a286d7
tree 886f7b87f30350c2a5980c70e56272dd2e766c14
parent 88b8f555d0553ad2d4a3ab16fe2da38c555eb8c3
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:16:48 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:16:48 +0900

 net/netfilter/nf_conntrack_proto_tcp.c |    1 +
 net/netfilter/nf_conntrack_proto_udp.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -34,6 +34,7 @@
 #include <linux/tcp.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
+#include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
 
 #include <net/tcp.h>
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -18,6 +18,8 @@
 #include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
 #include <net/checksum.h>
 #include <linux/netfilter.h>

----Next_Part(Thu_Sep__1_13_11_09_2005_286)----
