From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_connbytes: fix handling of --connbytes FROM
Date: Fri, 23 Dec 2011 14:57:32 +0100
Message-ID: <20111223135731.GB10482@1984>
References: <1324056846-557-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42381 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab1LWN5f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:57:35 -0500
Content-Disposition: inline
In-Reply-To: <1324056846-557-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 16, 2011 at 06:34:06PM +0100, Florian Westphal wrote:
> quoting man page:
> 
> match packets  from  a  connection  whose packets/bytes/average
> packet size is more than FROM and less than TO bytes/packets. if
> TO is omitted only FROM check is done.
> 
> But, when TO was omitted, we did treat it like "x:x" which is not
> the same at all.
> 
> Before commit 09631dc60ce41bc484a42fcf4d4ddf7036820bd1
> (libxt_connbytes: use guided option parser), we failed to parse
> "--connbytes x" ('Bad range "x"'), but treated "x:" like "x:0xffffffff".
> 
> Also, restore the "from must be smaller than to" check.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks!
