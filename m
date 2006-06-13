From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] entry_data
Date: Tue, 13 Jun 2006 17:19:49 +0200
Message-ID: <448ED795.3010509@netfilter.org>
References: <200606050029.08602.max@nucleus.it>	<200606120119.16503.max@nucleus.it>
	<448D38DA.8000404@us.es> <200606121445.42157.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606121445.42157.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Monday 12 June 2006 11:50 am, Pablo Neira Ayuso wrote:
>  
>>Fine, please next time send an incremental diff so we all can notice the
>>changes by having a look at the attachment. Thanks.
> 
> OK. Here it is. Some of the changes in this diff are due to the 2.6.17 
> porting, but they are minor.
> 
> ------------------------------------------------------------------------
> 
> diff -Nru linux-2.6.16/net/netfilter/xt_condition.c linux-2.6.17-entry_data/net/netfilter/xt_condition.c
> --- linux-2.6.16/net/netfilter/xt_condition.c	2006-04-26 12:07:52.000000000 +0200
> +++ linux-2.6.17-entry_data/net/netfilter/xt_condition.c	2006-06-12 01:49:05.000000000 +0200
> @@ -116,42 +116,32 @@
>  
>  static int
>  match(const struct sk_buff *skb, const struct net_device *in,
> -      const struct net_device *out, const void *matchinfo, int offset,
> -      unsigned int protoff, int *hotdrop)
> +      const struct net_device *out, const struct xt_match *match,
> +      const void *matchinfo, int offset,
> +      unsigned int protoff, int *hotdrop, void *entry_data)

Hm, then you must have a patch to modify the interface match()?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
