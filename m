From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] src: proto: fixed a rreply symbol
Date: Mon, 17 Feb 2014 10:46:43 +0000
Message-ID: <20140217104643.GA31632@macbook.localnet>
References: <1392633683-5485-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48538 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaBQKqr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:46:47 -0500
Content-Disposition: inline
In-Reply-To: <1392633683-5485-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 11:41:23AM +0100, Ana Rey wrote:
> There is a bug with rreply symbol. The rreply and reply symbol were the same.
> 
> There is a reproduction of this bug here:
> $ sudo nft add rule arp art-t filter arp operation reply
> $ sudo nft list table arp art-t
> table arp art-t {
>         chain filter {
>                  type filter hook input priority 0;
>                  arp operation 512
>         }
> }
> 
> $ sudo nft add rule arp art-t filter arp operation rreply
> $ sudo nft list table arp art-t
> table arp art-t {
>         chain filter {
>                  type filter hook input priority 0;
>                  arp operation 512  <=====
>                  arp operation 512  <=====
>         }
> }

Applied, thanks.

Please remember to sign off your patches next time.

> 
>  src/proto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/proto.c b/src/proto.c
> index cc073af..3e62f92 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -661,7 +661,7 @@ static const struct symbol_table arpop_tbl = {
>  		SYMBOL("request",	ARPOP_REQUEST),
>  		SYMBOL("reply",		ARPOP_REPLY),
>  		SYMBOL("rrequest",	ARPOP_RREQUEST),
> -		SYMBOL("rreply",	ARPOP_REPLY),
> +		SYMBOL("rreply",	ARPOP_RREPLY),
>  		SYMBOL("inrequest",	ARPOP_InREQUEST),
>  		SYMBOL("inreply",	ARPOP_InREPLY),
>  		SYMBOL("nak",		ARPOP_NAK),
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
