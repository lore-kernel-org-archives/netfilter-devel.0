From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables manpage: Update MASQUERADE target
Date: Fri, 19 Apr 2013 02:26:14 +0200
Message-ID: <20130419002614.GA24272@localhost>
References: <51659353.6080704@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967537Ab3DSA0T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:26:19 -0400
Content-Disposition: inline
In-Reply-To: <51659353.6080704@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 10, 2013 at 06:29:07PM +0200, Mart Frauenlob wrote:
> Hello,
> 
> this patch on the man page unifies the IPv4 and IPv6 entries of the
> MASQUERADE target and updates the list of protocols valid for port
> mapping.
> 
> Though there's no error thrown, if -p is used with --to-ports,
> the !portok error message does not talk about icmp,
> and I got no definite answer yet, and I don't think it does icmp
> type conversion, I choose to not put the icmp protocol into the
> list.
> Please correct me on that subject, if I'm wrong.

I don't think we support ICMP masquerading.
