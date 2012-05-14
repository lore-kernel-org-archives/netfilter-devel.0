From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 2/6] netfilter: decnet: switch hook PFs to nfproto
Date: Mon, 14 May 2012 15:18:16 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6F0A@saturn3.aculab.com>
References: <1337003799-2517-2-git-send-email-alban.crequy@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Vincent Sanders" <vincent.sanders@collabora.co.uk>,
	"Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
	<netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
To: "Alban Crequy" <alban.crequy@collabora.co.uk>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Patrick McHardy" <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1337003799-2517-2-git-send-email-alban.crequy@collabora.co.uk>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

 
> NFPROTO_* constants were usually equal to PF_* constants but it is not
> necessary and it will waste less memory if we don't do so 
> (see commit 7e9c6e
> "netfilter: Introduce NFPROTO_* constants")
...
>  
>  static struct nf_hook_ops dnrmg_ops __read_mostly = {
>  	.hook		= dnrmg_hook,
> -	.pf		= PF_DECnet,
> +	.pf		= NFPROTO_DECNET,
>  	.hooknum	= NF_DN_ROUTE,
>  	.priority	= NF_DN_PRI_DNRTMSG,
>  };

Might it be worth renaming the .pf member to (say) .nfproto
to help avoid confusion?

	David
