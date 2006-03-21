From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 09/09]: futher {ip,ip6,arp}_tables unification
Date: Tue, 21 Mar 2006 14:12:48 +0100
Message-ID: <441FFBD0.3010808@trash.net>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
	<200603211056.02339.dim@sw.ru> <441FC06E.60902@trash.net>
	<200603211221.01041.dim@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080207020008040104010507"
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@sw.ru>
In-Reply-To: <200603211221.01041.dim@sw.ru>
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
--------------080207020008040104010507
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Dmitry Mishin wrote:
> On Tuesday 21 March 2006 11:59, Patrick McHardy wrote:
> 
>>Sorry, I haven't figured out the problem yet, but it seems your
>>patch wasn't responsible. Anyway, I'll fix it once I figure it
>>out, so don't worry.
> 
> Could it be due to alignment checks in user or kernel space? I don't check it, 
> but think that current ip6_tables compatibility layer isn't sufficient, as it 
> is for ip_tables compatibility.

No, the problem is that nf_getsockopt is not called anymore because
do_ipv6_getsockopt doesn't return -ENOPROTOOPT but -EINVAL for
unknown options. I've queued this patch to fix it.

--------------080207020008040104010507
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

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
 

--------------080207020008040104010507--
