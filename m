From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_tcp: print space before, not after "flags:"
Date: Tue, 21 Aug 2012 12:37:10 +0200
Message-ID: <20120821103710.GA31073@1984>
References: <m2k3wt4iaz.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schwab <schwab@linux-m68k.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59863 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab2HUKhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:37:15 -0400
Content-Disposition: inline
In-Reply-To: <m2k3wt4iaz.fsf@igel.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 20, 2012 at 06:52:36PM +0200, Andreas Schwab wrote:
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  extensions/libxt_tcp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
> index e849fa2..bbdec45 100644
> --- a/extensions/libxt_tcp.c
> +++ b/extensions/libxt_tcp.c
> @@ -278,11 +278,10 @@ static void
>  print_flags(uint8_t mask, uint8_t cmp, int invert, int numeric)
>  {
>  	if (mask || invert) {
> -		printf("flags:%s", invert ? "!" : "");
> +		printf(" flags:%s", invert ? "!" : "");
>  		if (numeric)
> -			printf(" 0x%02X/0x%02X", mask, cmp);
> +			printf("0x%02X/0x%02X", mask, cmp);
>  		else {
> -			printf(" ");
>  			print_tcpf(mask);
>  			printf("/");
>  			print_tcpf(cmp);

Right, iptables -L -n is broken indeed:

tcp dpt:10flags: 0x17/0x02

Applied, thanks.
