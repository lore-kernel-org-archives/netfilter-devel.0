From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables manpage: Update REDIRECT target
Date: Fri, 19 Apr 2013 02:56:05 +0200
Message-ID: <20130419005605.GB4689@localhost>
References: <516593A2.8040308@chello.at>
 <516597F1.80707@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55338 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967630Ab3DSA4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:56:10 -0400
Content-Disposition: inline
In-Reply-To: <516597F1.80707@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 10, 2013 at 06:48:49PM +0200, Mart Frauenlob wrote:
> On 10.04.2013 18:31, netfilter-devel-owner@vger.kernel.org wrote:
> >Hello,
> >
> >this patch renames libipt_REDIRECT.man to libxt_REDIRECT.man thus
> >informing about the IPv6 version.
> >Also the list of valid protocols for port mapping is updated to:
> >tcp, udp, dccp and sctp.
> >
> >I hope the address provided for IPv6 localhost ::1 is correct?

Yes. Also applied, thanks.
