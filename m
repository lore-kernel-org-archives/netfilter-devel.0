From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] src: proto: Add missing packet type
Date: Tue, 1 Mar 2016 14:17:40 +0100
Message-ID: <20160301131740.GD22817@breakpoint.cc>
References: <20160301123912.GA6905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48940 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbcCANRr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 08:17:47 -0500
Content-Disposition: inline
In-Reply-To: <20160301123912.GA6905@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> Add missing packet type "invalid" for DCCP.
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  src/proto.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/proto.c b/src/proto.c
> index 0ed98ed..4d049f5 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -443,6 +443,7 @@ static const struct symbol_table dccp_pkttype_tbl = {
>  		SYMBOL("reset",		DCCP_PKT_RESET),
>  		SYMBOL("sync",		DCCP_PKT_SYNC),
>  		SYMBOL("syncack",	DCCP_PKT_SYNCACK),
> +		SYMBOL("invalid",	DCCP_PKT_INVALID),

I don't think this is a good idea -- when user asks to match
'invalid' then this will check type == DCCP_PKT_INVALID; however
the correct way would be to ask for type '> synack' (i.e.,
outside of the range of types specified).
