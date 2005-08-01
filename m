From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: atomic counter underflow at
 ip_conntrack_event_cache_init+0x91/0xb0 (with patch)
Date: Mon, 01 Aug 2005 16:27:53 +0200
Message-ID: <42EE3169.6070604@trash.net>
References: <20050801141327.GA3909@inferi.kami.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070607080204070300000801"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mattia Dongili <malattia@gmail.com>
In-Reply-To: <20050801141327.GA3909@inferi.kami.home>
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
--------------070607080204070300000801
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Mattia Dongili wrote:
> Hello,
> 
> got this one while trying out 2.6.13-rc4-mm1 (not there in -r2-mm1),
> from a quick look it seems to me that ip_conntrack_{get,put} are not
> simmetric in updating the use count, thus simply adding this line might
> help (it does actually, but I'm not aware if there could be any drawback):
> 
> --- include/linux/netfilter_ipv4/ip_conntrack.h.clean	2005-08-01 15:09:49.000000000 +0200
> +++ include/linux/netfilter_ipv4/ip_conntrack.h	2005-08-01 15:08:52.000000000 +0200
> @@ -298,6 +298,7 @@ static inline struct ip_conntrack *
>  ip_conntrack_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
>  {
>  	*ctinfo = skb->nfctinfo;
> +	nf_conntrack_get(skb->nfct);
>  	return (struct ip_conntrack *)skb->nfct;
>  }

This creates lots of refcnt leaks, which is probably why it makes the
underflow go away :) Please try this patch instead.


--------------070607080204070300000801
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix refcnt underflow in ip_conntrack_event_cache_init

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5d55b8c6bfba6e6e2ffe26c2a2e2561e278428b7
tree d43366a793d2fa3058c15a752010ef0fd22894cc
parent df2e0392536ecdd6385f4319f746045fd6fae38f
author Patrick McHardy <kaber@trash.net> Mon, 01 Aug 2005 16:25:53 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 01 Aug 2005 16:25:53 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -146,6 +146,7 @@ void ip_conntrack_event_cache_init(const
 
 		/* initialize for this conntrack/packet */
 		ecache->ct = ip_conntrack_get(skb, &ctinfo);
+		nf_conntrack_get(&ecache->ct->ct_general);
 		/* ecache->events cleared by __deliver_cached_devents() */
 	} else {
 		DEBUGP("ecache: re-entered for conntrack %p.\n", ct);

--------------070607080204070300000801--
