From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] utils: fix arp family number
Date: Mon, 20 Oct 2014 12:38:30 +0200
Message-ID: <20141020103830.GA6272@salvia>
References: <20141020102619.22301.43766.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaJTKhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:37:23 -0400
Content-Disposition: inline
In-Reply-To: <20141020102619.22301.43766.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 12:26:20PM +0200, Arturo Borrero Gonzalez wrote:
> NFPROTO_ARP = 3 in kernel space.
> 
> We need the same value here in userspace in order to correctly communicate
> with the kernel.
> 
> The failure solved by this patch made that {XML|JSON}-parsed tables of ARP
> family unable to be directly injected into kernel.
> 
> To prevent future errors, this patch changes raw and AF_* values by the mathing
> NFPROTO_* couterpart as seen in linux/netfilter.h in both functions:
>  * nft_family2str()
>  * nft_str2family()
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/utils.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/src/utils.c b/src/utils.c
> index d70fbf1..d70d073 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -23,15 +23,15 @@
>  const char *nft_family2str(uint32_t family)
>  {
>  	switch (family) {
> -	case AF_INET:
> +	case NFPROTO_IPV4:
>  		return "ip";
> -	case AF_INET6:
> +	case NFPROTO_IPV6:
>  		return "ip6";
> -	case 1:
> +	case NFPROTO_INET:
>  		return "inet";
> -	case AF_BRIDGE:
> +	case NFPROTO_BRIDGE:
>  		return "bridge";
> -	case 3: /* NFPROTO_ARP */
> +	case NFPROTO_ARP:
>  		return "arp";
>  	default:
>  		return "unknown";

Good, could send a new version that reworks+fix this to look like:

static const char *nft_family_str[NFPROTO_MAX] = {
        [NFPROTO_IPV4]  = "ip",
        ...
};

const char *nft_family2str(uint32_t family)
{
        if (nft_family_str[family] == NULL)
                return "unknown";

        return nft_family_str[family];
}

> @@ -41,15 +41,15 @@ const char *nft_family2str(uint32_t family)
>  int nft_str2family(const char *family)
>  {
>  	if (strcmp(family, "ip") == 0)
> -		return AF_INET;
> +		return NFPROTO_IPV4;
>  	else if (strcmp(family, "ip6") == 0)
> -		return AF_INET6;
> +		return NFPROTO_IPV6;
>  	else if (strcmp(family, "inet") == 0)
> -		return 1;
> +		return NFPROTO_INET;
>  	else if (strcmp(family, "bridge") == 0)
> -		return AF_BRIDGE;
> +		return NFPROTO_BRIDGE;
>  	else if (strcmp(family, "arp") == 0)
> -		return 0;
> +		return NFPROTO_ARP;
>  
>  	errno = EAFNOSUPPORT;
>  	return -1;

In this case you can do:

const char *nft_str2family(const char *family)
{
        for (i = 0; i < NFPROTO_MAX; i++) {
                if (nft_family_str[i] == NULL)
                        continue;

                if (strcmp(nft_family_str[i], family) == 0)
                        return i;
        }
        return "unknown";
}

so you reuse nft_family_str. Thanks.
