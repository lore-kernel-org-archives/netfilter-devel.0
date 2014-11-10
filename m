From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] nft-arp: fix inversion of matches
Date: Mon, 10 Nov 2014 18:30:29 +0100
Message-ID: <20141110173029.GA29762@salvia>
References: <20141108213434.27991.30805.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbaKJR2l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:28:41 -0500
Content-Disposition: inline
In-Reply-To: <20141108213434.27991.30805.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 08, 2014 at 10:35:49PM +0100, Arturo Borrero Gonzalez wrote:
> Inversion of matches is failing because NFT_CMP_EQ is used unconditionally.
> 
> The family agnostic functions don't need this fix, because arp inv flags
> are translated to ipt inv flags, and these flags are well handled there.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> NOTES: This patch is for the master branch of iptables tree.
>        Compile-tested only. Please comment.

Please, no compile-tested patches, submit RFC or tested stuff.

>  iptables/nft-arp.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index f45ad0f..cb3623d 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -164,6 +164,7 @@ static int nft_arp_add(struct nft_rule *r, void *data)
>  	struct arptables_command_state *cs = data;
>  	struct arpt_entry *fw = &cs->fw;
>  	uint8_t flags = arpt_to_ipt_flags(fw->arp.invflags);

I prefer if you kill arpt_to_ipt_flags(), so add_iniface() uses
native NFT_CMP_{EQ,NEQ} as third parameter. Thus, add_iniface() will
be consistent with other existing add_cmp_*() functions.

This will require some extra code in nft-ipv4 and nft-ipv6 though, but
I'd like to avoid this arpt to ipt flags conversion.

> +	uint32_t op = NFT_CMP_EQ;
>  	int ret = 0;
>  
>  	if (fw->arp.iniface[0] != '\0')
> @@ -174,12 +175,24 @@ static int nft_arp_add(struct nft_rule *r, void *data)
>  
>  	if (fw->arp.arhrd != 0) {
>  		add_payload(r, offsetof(struct arphdr, ar_hrd), 2);
> -		add_cmp_u16(r, fw->arp.arhrd, NFT_CMP_EQ);
> +
> +		if (fw->arp.invflags & ARPT_INV_ARPHRD)
> +			op = NFT_CMP_NEQ;
> +		else
> +			op = NFT_CMP_EQ;
> +
> +		add_cmp_u16(r, fw->arp.arhrd, op);

This is a good example of what I would like to see in the family
specific nft code, use this pattern consistently in this code. Thanks.
