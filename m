From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH 1/2] netfilter: xt_TCPMSS: fix handling of malformed TCP
 header
Date: Wed, 31 Jul 2013 22:54:16 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1307312236050.1863@ja.ssi.bg>
References: <1375279852-4059-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:57059 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753245Ab3GaTxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:53:07 -0400
In-Reply-To: <1375279852-4059-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

On Wed, 31 Jul 2013, Pablo Neira Ayuso wrote:

> Make sure the packet has enough room for the TCP header and
> that it is not malformed.
> 
> While at it, store tcph->doff*4 in a variable, as it is used
> several times.
> 
> Reported-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/xt_TCPMSS.c |   27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> index 7011c71..2883c1c 100644
> --- a/net/netfilter/xt_TCPMSS.c
> +++ b/net/netfilter/xt_TCPMSS.c

> @@ -87,8 +91,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>  		newmss = info->mss;
>  
>  	opt = (u_int8_t *)tcph;
> -	for (i = sizeof(struct tcphdr); i < tcph->doff*4; i += optlen(opt, i)) {
> -		if (opt[i] == TCPOPT_MSS && tcph->doff*4 - i >= TCPOLEN_MSS &&
> +	for (i = sizeof(struct tcphdr); i < tcp_hdrlen; i += optlen(opt, i)) {

	If we also want to avoid the wrong access in optlen()
we have 2 options for the above line:

1. Use 'i < tcp_hdrlen - 1' or 'i <= tcp_hdrlen - 2'

2. Use 'i <= tcp_hdrlen - TCPOLEN_MSS' and remove the
below 'tcp_hdrlen - i >= TCPOLEN_MSS' check

> +		if (opt[i] == TCPOPT_MSS && tcp_hdrlen - i >= TCPOLEN_MSS &&
>  		    opt[i+1] == TCPOLEN_MSS) {
>  			u_int16_t oldmss;

Regards

--
Julian Anastasov <ja@ssi.bg>
