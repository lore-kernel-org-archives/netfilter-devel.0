From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 10:41:05 +0100
Message-ID: <43C62431.1030800@trash.net>
References: <BAY103-F18706C52D2ACDEFC5D91E6B2240@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050101030006060001000507"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F18706C52D2ACDEFC5D91E6B2240@phx.gbl>
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
--------------050101030006060001000507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Marco Berizzi wrote:
> Chain FORWARD (policy DROP 0 packets, 0 bytes)
> pkts bytes target     prot opt in     out     source               
> destination
>   19  1140 ACCEPT     all  --  any    any     anywhere             
> anywhere            policy match dir out pol ipsec strict [0] [1] [2] 
> [3] mode tunnel tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir in pol ipsec strict [0] [1] [2] [3] 
> mode tunnel tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24

There was actually a real problem, the first rule should never have
matched because its length doesn't match the number of used transforms.
I've fixed it with this patch (and added the additional checks to
the userspace part).

--------------050101030006060001000507
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Check policy length in policy match strict mode

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d98b092ef1a291d2fd31cbf1152bd16cca2e925d
tree bceb1f3d982e680b9ab3eb02e04e07a401bcd5db
parent a4fc7ab1d065a9dd89ed0e74439ef87d4a16e980
author Patrick McHardy <kaber@trash.net> Thu, 12 Jan 2006 10:38:26 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 12 Jan 2006 10:38:26 +0100

 net/ipv4/netfilter/ipt_policy.c  |    2 +-
 net/ipv6/netfilter/ip6t_policy.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
index 709debc..8d1111e 100644
--- a/net/ipv4/netfilter/ipt_policy.c
+++ b/net/ipv4/netfilter/ipt_policy.c
@@ -89,7 +89,7 @@ match_policy_out(const struct sk_buff *s
 			return 0;
 	}
 
-	return strict ? 1 : 0;
+	return strict ? i == info->len : 0;
 }
 
 static int match(const struct sk_buff *skb,
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index 13fedad..33bd60e 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -91,7 +91,7 @@ match_policy_out(const struct sk_buff *s
 			return 0;
 	}
 
-	return strict ? 1 : 0;
+	return strict ? i == info->len : 0;
 }
 
 static int match(const struct sk_buff *skb,

--------------050101030006060001000507--
