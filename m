From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] ct: add support for setting ct mark
Date: Thu, 13 Mar 2014 14:17:46 +0100
Message-ID: <20140313131746.GA6346@localhost>
References: <20140312180319.5029.59536.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41897 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaCMNRv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:17:51 -0400
Content-Disposition: inline
In-Reply-To: <20140312180319.5029.59536.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 12, 2014 at 07:03:19PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds the possibility to set ct keys using nft. Currently, the
> connection mark is supported. This functionality enables creating rules
> performing the same action as iptables -j CONNMARK --save-mark. For example:
> 
> table ip filter {
> 	chain postrouting {
> 		type filter hook postrouting priority 0;
> 		ip protocol icmp ip daddr 8.8.8.8 ct mark set meta mark
> 	}
> }
> 
> My patch is based on the original http://patchwork.ozlabs.org/patch/307677/
> by Kristian Evensen <kristian.evensen@gmail.com>.
> 
> I simply did a rebase and some testing. To test, I added rules like these:
>  counter meta mark set 1 counter
>  counter ct mark set mark counter
>  counter ct mark 1 counter
> 
> The last matching worked as expected, which means the second rule is also
> working as expected.

Applied, thanks for recovering this patch Arturo!
