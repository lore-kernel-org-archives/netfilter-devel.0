From: "David S. Miller" <davem@redhat.com>
Subject: Re: Linux 2.6.9-rc1
Date: Wed, 25 Aug 2004 16:44:01 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040825164401.12259308.davem@redhat.com>
References: <Pine.LNX.4.58.0408240031560.17766@ppc970.osdl.org>
	<412CDFEE.1010505@triplehelix.org>
	<20040825203206.GS5824@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: joshk@triplehelix.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040825203206.GS5824@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Aug 2004 22:32:06 +0200
Harald Welte <laforge@netfilter.org> wrote:

Harald, a question about this fix.

> +__ip_nat_find_helper(const struct ip_conntrack_tuple *tuple)
> +{
> +	return LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *, tuple);
> +}
> +
> +struct ip_nat_helper *
>  ip_nat_find_helper(const struct ip_conntrack_tuple *tuple)
>  {
>  	struct ip_nat_helper *h;
>  
>  	READ_LOCK(&ip_nat_lock);
> -	h = LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *, tuple);
> +	h = __ip_nat_find_helper(tuple);
>  	READ_UNLOCK(&ip_nat_lock);
>  

So we're converting over to using __ip_nat_find_helper().

> +EXPORT_SYMBOL(ip_nat_find_helper);

And adding an export of ip_nat_find_helper (ie. without the two underscore
prefix).  Why?

If we need to export one, then we need to export both.
