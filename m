From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental3 PATCH 1/2] nft-bridge: fix
 inversion of matches
Date: Mon, 10 Nov 2014 18:33:23 +0100
Message-ID: <20141110173323.GB29762@salvia>
References: <20141108213750.28047.14081.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaKJRbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:31:35 -0500
Content-Disposition: inline
In-Reply-To: <20141108213750.28047.14081.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 08, 2014 at 10:39:33PM +0100, Arturo Borrero Gonzalez wrote:
> The inversion in bridge specific matches is failing because before this
> patch NFT_CMP_EQ is used unconditionally.
> 
> No need to change the invesion in family-agnostic functions, given
> ebt inv flags are translated to ipt inv flags and inversion is properly
> calculated there.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> NOTE: I think the previous patch to fix this isse was wrong in several aspects.
>       This is a new approach. Compile-tested only. Please comment.
> 
>  iptables/nft-bridge.c |   25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index 0e21b46..66bbefd 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -165,6 +165,7 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
>  	struct ebtables_command_state *cs = data;
>  	struct ebt_entry *fw = &cs->fw;
>  	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
> +	uint32_t op = NFT_CMP_EQ;
>  	char *addr;
>  
>  	if (fw->in[0] != '\0')
> @@ -182,18 +183,36 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
>  	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
>  	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
>  		add_payload(r, offsetof(struct ethhdr, h_source), 6);
> -		add_cmp_ptr(r, NFT_CMP_EQ, fw->sourcemac, 6);
> +
> +		if (fw->invflags & EBT_ISOURCE)
> +			op = NFT_CMP_NEQ;
> +		else
> +			op = NFT_CMP_EQ;
> +
> +		add_cmp_ptr(r, op, fw->sourcemac, 6);

Please, use ETH_ALEN instead of hardcoded values. I know this code is
full of this, but when it comes to source code readability, it's
always better to use something meaningful.

Apart from that, looks good. Please test and resubmit. Thanks.
