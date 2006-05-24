From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] log dropped ICMP redirects
Date: Wed, 24 May 2006 18:26:10 +0200
Message-ID: <44748922.4060207@trash.net>
References: <20060524040441.111049000@snapgear.com>
	<20060524040951.092582000@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: philipc@snapgear.com
In-Reply-To: <20060524040951.092582000@snapgear.com>
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

philipc@snapgear.com wrote:
> Log dropped ICMP redirects for untracked connections.
> 
> This was required to meet a certification test.  But there are
> many more locations that can drop packets without logging them,
> which weren't tested for certification.  Should all instances of
> NF_DROP in netfilter/iptables have a call to nf_log_packet?


There was a patch called "dropped table" once that hooked in kfree_skb.
I'm also not completely satisfied with the current situation .. but
I don't think adding excessive packet logging is the best solution,
often drops just occur because of failed validity checks which can
just as well happen outside of the netfilter code.

In this case I'm actually having trouble understanding what the code
is supposed to do, why would we receive an ICMP redirect for a
unhashed connection (unhashed == first packet hasn't even left the
box yet)?

> @@ -132,8 +133,13 @@ ip_nat_fn(unsigned int hooknum,
>  						(*pskb)->nh.iph->ihl*4,
>  						sizeof(_hdr), &_hdr);
>  			if (hp != NULL &&
> -			    hp->type == ICMP_REDIRECT)
> +			    hp->type == ICMP_REDIRECT) {
> +				if (LOG_INVALID(IPPROTO_ICMP))
> +					nf_log_packet(PF_INET, 0, *pskb,
> +						NULL, NULL, NULL, "ip_nat: "
> +						"untracked ICMP redirect ");
>  				return NF_DROP;
> +			}
>  		}
>  		return NF_ACCEPT;
>  	}
> 
> --
> 
> 
