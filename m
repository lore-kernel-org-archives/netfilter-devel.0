From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables manpage: Update LOG target
Date: Fri, 19 Apr 2013 02:57:48 +0200
Message-ID: <20130419005748.GE4689@localhost>
References: <5165937E.4060302@chello.at>
 <516597A4.4090606@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55440 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967733Ab3DSA5w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:57:52 -0400
Content-Disposition: inline
In-Reply-To: <516597A4.4090606@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 10, 2013 at 06:47:32PM +0200, Mart Frauenlob wrote:
> On 10.04.2013 18:30, netfilter-devel-owner@vger.kernel.org wrote:
> >Hello,
> >
> >this patch on the man page unifies the IPv4 and IPv6 entries of the LOG
> >target.

The new manpage has no more references about IPv6. It seems you have
used IPv4 manpage with no mangling to also talk about IPv6. Fix this
and resubmit. Thanks.
