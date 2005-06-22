From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip6t_REJECT.c vs 2.6.12.
Date: Wed, 22 Jun 2005 20:39:23 +0200
Message-ID: <42B9B05B.6010005@trash.net>
References: <200506221406.01960.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@agmk.net>
In-Reply-To: <200506221406.01960.pluto@agmk.net>
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

Pawel Sikora wrote:
> Hi,
> 
> In 2.6.12 the net/ipv6.h was changed.
> 
> (...)
> extern int ipv6_skip_exthdr(const struct sk_buff *, int start,
> -                           u8 *nexthdrp, int len);
> +                           u8 *nexthdrp);
> 
> ip6t_REJECT.c needs minor fix.

I already have a fixed version queued and will submit it with my
next batch of patches.

Regards
Patrick
