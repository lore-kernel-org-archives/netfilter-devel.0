From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft] proto: add missing fields for ARP with
 IPv4/Ethernet
Date: Thu, 26 Nov 2015 14:15:24 +0100
Message-ID: <20151126131524.GA32716@breakpoint.cc>
References: <1448541796-23535-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36926 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbbKZNP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 08:15:27 -0500
Content-Disposition: inline
In-Reply-To: <1448541796-23535-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> If we agree to do it like this for now, what about naming? I don't like the
> token names very much, but I also want to avoid excessively long tokens.
> If someone has a nice reasonable suggestion please let me know.

> +%token SHA			"sha"

shwaddr?  Or just saddr.

> +%token THA			"tha"

thwadddr, or taddr.

> +%token SIP			"sip"
> +%token TIP			"tip"

rfc826 calls these ar$spa ar$tpa ('source/target protocol address').
Perhaps 'srcip' and 'targetip'?

I don't think we should care about more generic
term since ...

> +		[ARPHDR_SIP]		= ARPHDR_IP_ADDR("sip", ar_sip),

... we expect an IP address anyway.
