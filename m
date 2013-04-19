From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables manpage: Update SNAT target
Date: Fri, 19 Apr 2013 02:56:35 +0200
Message-ID: <20130419005635.GD4689@localhost>
References: <516593CC.1010908@chello.at>
 <51659835.9050103@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55375 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967711Ab3DSA4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:56:44 -0400
Content-Disposition: inline
In-Reply-To: <51659835.9050103@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 10, 2013 at 06:49:57PM +0200, Mart Frauenlob wrote:
> On 10.04.2013 18:32, netfilter-devel-owner@vger.kernel.org wrote:
> >Hello,
> >
> >this patch renames libipt_SNAT.man to libxt_SNAT.man thus informing
> >about the IPv6 version.
> >Also the list of valid protocols for port mapping is updated to:
> >tcp, udp, dccp and sctp.

Applied, thanks.
