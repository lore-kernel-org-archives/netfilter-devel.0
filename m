From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] Enhanced error message which is displayed if an
 error occured while creating a chain.
Date: Tue, 10 Jun 2014 17:06:59 +0200
Message-ID: <20140610150659.GB13025@localhost>
References: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
 <1402412087-9825-2-git-send-email-hendrik@os-t.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hendrik Schwartke <hendrik@os-t.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37367 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaFJPHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:07:05 -0400
Content-Disposition: inline
In-Reply-To: <1402412087-9825-2-git-send-email-hendrik@os-t.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 04:54:47PM +0200, Hendrik Schwartke wrote:
> Creating a base chain which depends on unsupported kernel features
> (e.g. creating a chain with a nat hook without loading the nat
> kernel module) results in a confusing error message.
> This patch added a meaningful hint.
>
> @@ -500,8 +501,13 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
>          nft_chain_free(nlc);
>  
>          if (err < 0) {
> -                netlink_io_error(ctx, loc, "Could not add chain: %s",
> -                                 strerror(errno));
> +                const char *expl="";
> +                if(is_basechain && errno==ENOENT)
> +                        expl=" - perhaps some kernel modules are not"
> +                             " loaded or the kernel doesn't include"
> +                             " necessary features.";

I prefer to add this in the FAQ section in the nftables HOWTO [1] to
troubleshooting. I can create an account for you, so you can edit that
yourself.

[1] http://wiki.nftables.org/
