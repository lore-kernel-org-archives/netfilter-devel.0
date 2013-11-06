From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: arp: inhibate -l option so only a
 fixed size arhln is in use
Date: Wed, 6 Nov 2013 14:50:20 +0100
Message-ID: <20131106135020.GA4652@localhost>
References: <1383738669-25602-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab3KFNu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:50:27 -0500
Content-Disposition: inline
In-Reply-To: <1383738669-25602-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 06, 2013 at 01:51:09PM +0200, Tomasz Bursztyka wrote:
> This is a temporary fallback mechanism until variable interface hardware
> address length can be handled through nftables.
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  iptables/xtables-arp.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
> index 18f285c..97dbca9 100644
> --- a/iptables/xtables-arp.c
> +++ b/iptables/xtables-arp.c
> @@ -272,7 +272,8 @@ static int getmac_and_mask(char *from, char *to, char *mask)
>  	return 0;
>  }
>  
> -static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
> +/* Necessary when -l will be supported */
> +/*static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
>  {
>  	char *p, *buffer;
>  	int i;
> @@ -290,7 +291,7 @@ static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
>  		return -1;
>  	*to = (uint8_t)i;
>  	return 0;
> -}
> +}*/
>  
>  static int get16_and_mask(char *from, uint16_t *to, uint16_t *mask, int base)
>  {
> @@ -974,6 +975,9 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
>  	    demand-load a protocol. */
>  	opterr = 0;
>  
> +	/*-l is currently not supported: falling back to a fixed sized arhln*/
> +	fw.arp.arhln = 6;
> +
>  	while ((c = getopt_long(argc, argv,
>  	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:l:i:vnt:m:c:",
>  					   opts, NULL)) != -1) {
> @@ -1140,11 +1144,13 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
>  			break;
>  
>  		case 'l':/* hardware length */
> -			check_inverse(optarg, &invert, &optind, argc);
> +			xtables_error(PARAMETER_PROBLEM, "not supported");

This is a bit agressive, I prefer if you check if you pass something
different from '-l 6', in that case you spot the "currently
unsupported, sorry" message.

> +
> +			/*check_inverse(optarg, &invert, &optind, argc);
>  			set_option(&options, OPT_H_LENGTH, &fw.arp.invflags,
>  				   invert);
>  			getlength_and_mask(argv[optind - 1], &fw.arp.arhln,
> -					   &fw.arp.arhln_mask);
> +					   &fw.arp.arhln_mask);*/
>  			break;
>  
>  		case 8:/* protocol length */
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
