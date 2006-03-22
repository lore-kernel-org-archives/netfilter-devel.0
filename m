From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/10]: Fix ip6tables breakage from {get,
	set}sockopt compat layer
Date: Wed, 22 Mar 2006 19:47:42 +0100 (MET)
Message-ID: <20060322184742.5655.32343.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix ip6tables breakage from {get,set}sockopt compat layer

do_ipv6_getsockopt returns -EINVAL for unknown options, not -ENOPROTOOPT
as do_ipv6_setsockopt.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 28b7fea5433d3b5ddcba2948b17e6a0aa9fa0af6
tree eb28f95bba37326b306d4171c2c412daabb65bb6
parent ec1248e70edc5cf7b485efcc7b41e44e10f422e5
author Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:29:40 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:29:40 +0100

 net/ipv6/ipv6_sockglue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 602feec..4c20eeb 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -907,7 +907,7 @@ int ipv6_getsockopt(struct sock *sk, int
 	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen);
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible EINVALs except default case */
-	if (err == -ENOPROTOOPT && optname != IPV6_ADDRFORM &&
+	if (err == -EINVAL && optname != IPV6_ADDRFORM &&
 			optname != MCAST_MSFILTER) {
 		int len;
 
@@ -944,7 +944,7 @@ int compat_ipv6_getsockopt(struct sock *
 	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen);
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible EINVALs except default case */
-	if (err == -ENOPROTOOPT && optname != IPV6_ADDRFORM &&
+	if (err == -EINVAL && optname != IPV6_ADDRFORM &&
 			optname != MCAST_MSFILTER) {
 		int len;
 
