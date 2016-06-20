From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if
 the packet is non-TCP
Date: Mon, 20 Jun 2016 12:48:29 -0300
Message-ID: <20160620154829.GD18341@localhost.localdomain>
References: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbcFTPsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 11:48:33 -0400
Content-Disposition: inline
In-Reply-To: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

On Mon, Jun 20, 2016 at 09:26:28PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In iptables, if the user add a rule to send tcp RST and specify the
> non-TCP protocol, such as UDP, kernel will reject this request. But
> in nftables, this validity check only occurs in nft tool, i.e. only
> in userspace.
> 
> This means that user can add such a rule like follows via nfnetlink:
>   "nft add rule filter forward ip protocol udp reject with tcp reset"
> 
> This will generate some confusing tcp RST packets. So we should send
> tcp RST only when it is TCP packet.
> 
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  net/ipv4/netfilter/nf_reject_ipv4.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index b6ea57e..fd82202 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -24,6 +24,9 @@ const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
>  	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
>  		return NULL;
>  
> +	if (ip_hdr(oldskb)->protocol != IPPROTO_TCP)
> +		return NULL;
> +
>  	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
>  				 sizeof(struct tcphdr), _oth);
>  	if (oth == NULL)

A different check/log is made for ip6:
nf_reject_ip6_tcphdr_get():
        /* IP header checks: fragment, too short. */
        if (proto != IPPROTO_TCP || *otcplen < sizeof(struct tcphdr)) {
                pr_debug("proto(%d) != IPPROTO_TCP or too short (len = %d)\n",
                         proto, *otcplen);
                return NULL;
        }

Would be nice to have some consistency on this log message as it
increases debug-ability.

  Marcelo

