From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] conntrack-event-api
Date: Wed, 20 Jul 2005 10:45:30 +0200
Message-ID: <42DE0F2A.5050609@tac.ch>
References: <20050719201646.GH3768@rama>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050719201646.GH3768@rama>
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

> Here's a revamped conntrack-event-api patch.  Instead of using
> skb->nfcache, we now use a per-cpu data structure.  This saves 32bit in
> sk_buff.

I see that netconf really gets the ball rolling ;).

> +static inline void 
> +ip_conntrack_event_cache(enum ip_conntrack_events event,
> +			 const struct sk_buff *skb)
> +{
> +	struct ip_conntrack_ecache *ecache = 
> +					&__get_cpu_var(ip_conntrack_ecache);
> +
> +	if (unlikely((struct ip_conntrack *) skb->nfct != ecache->ct)) {
> +		if (net_ratelimit()) {
> +			printk(KERN_ERR "ctevent: skb->ct != ecache->ct !!!\n");

Not important, but: s/skb->ct/skb->nfct/ and could you maybe drop the
!!!'s? ;)

> +			dump_stack();

Is this trace reliable regarding per-CPU structures?

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
