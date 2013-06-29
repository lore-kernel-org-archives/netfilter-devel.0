From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Issue with latest nftables
Date: Sat, 29 Jun 2013 11:45:03 +0200
Message-ID: <20130629094503.GA3805@localhost>
References: <1372450120.8772.5.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41451 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3F2JpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 05:45:09 -0400
Content-Disposition: inline
In-Reply-To: <1372450120.8772.5.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 28, 2013 at 10:08:40PM +0200, Eric Leblond wrote:
> Hi,
> 
> I've found an issue when using the libnftables based nft.
> 
> If you use nft-add-rule from libnftables examples and you try to list
> the rules afterward with nft, there is a problem with the added rules
> which are not displayed correctly.
> 
> Here is the output of "nft list table filter -n -a --debug=all":
> 
> family=ip table=filter chain=output handle=9 flags=0 match name=iprange rev=1 payload dreg=1 base=1 offset=9 len=1 target name=LOG rev=0 
> table filter {
>         chain input {
>                  hook NF_INET_LOCAL_IN 0;
>         }
> 
>         chain forward {
>                  hook NF_INET_FORWARD 0;
>         }
> 
>         chain output {
>                  hook NF_INET_LOCAL_OUT 0;
>                  ip daddr 1.2.3.4 drop # handle 4
>                  ip daddr 1.2.3.5 drop # handle 5
>                  ip daddr 1.2.3.6 drop # handle 6
>                  # handle 9
>         }
> }
> netlink: Error: unknown expression type 'match'
> name=iprange rev=1 
> 
> 
> netlink: Error: unknown expression type 'target'
> name=LOG rev=0 
> 
> Should this problem be trivial for someone, I let him do the job. If
> not, I will start to work on it.

We don't have support for compat from nft yet. That should be
relatively easy to fix.
