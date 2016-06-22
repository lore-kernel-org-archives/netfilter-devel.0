From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] nft: Add support for inverted bitwise value list
Date: Wed, 22 Jun 2016 18:14:07 +0200
Message-ID: <20160622161407.GB10213@breakpoint.cc>
References: <20160622154945.GA12610@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34032 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbcFVQON (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 12:14:13 -0400
Content-Disposition: inline
In-Reply-To: <20160622154945.GA12610@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laura Garcia Liebana <nevola@gmail.com> wrote:
> Add support for inverted state and status bitwise value list required in the
> ct match.
> 
> Before this patch, nft didn't support the rule:
> 
> $ nft add rule ip filter INPUT ct state != new,related counter accept
> <cmdline>:1:41-41: Error: syntax error, unexpected comma, expecting end of file or newline or semicolon
> add rule ip filter INPUT ct state != new,related counter accept
                                         ^
I don't like nft foo,bar syntax since

'state new,related' looks a lot like 'state { new, related }' but its not the same...

Maybe we should use 'state new|related' instead for flag type too?

[ Maybe better discuss it at nfws ]
