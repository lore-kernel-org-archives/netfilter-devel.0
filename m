From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft: parser problem, can use mark as datatype in sets and maps
Date: Mon, 10 Aug 2015 19:09:20 +0200
Message-ID: <20150810170920.GA3487@salvia>
References: <1027218717.2766569.1439214492178.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbbHJRDn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 13:03:43 -0400
Content-Disposition: inline
In-Reply-To: <1027218717.2766569.1439214492178.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 10, 2015 at 03:48:12PM +0200, Andreas Schultz wrote:
> Hi,
> 
> The data type definition for mark and the general idea of the parser
> indicate that the following nft statements should work:
>  
>   # nft add map filter MAP1 { type ipv4_addr : mark\; }
>   # nft add set filter SET1 { type mark\; }
> 
> However, both fail with a similar error message:
> 
>   <cmdline>:1:40-43: Error: syntax error, unexpected mark, expecting string
>   add map filter MAP1 { type ipv4_addr : mark; }
>   <cmdline>:1:28-31: Error: syntax error, unexpected mark, expecting string
>   add set filter SET1 { type mark; }
> 
> The problem is parser, it expects a string as data type spec, but
> mark is already declared as a token.
> 
> I don't have much experience with bison, so does anyone have a quick
> work-around for this?

This is fixed by 2baf59c ("parser_bison: allow to use mark as datatype
for maps and sets").
