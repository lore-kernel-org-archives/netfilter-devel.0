From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnfnetlink license
Date: Wed, 7 Aug 2013 20:57:43 +0200
Message-ID: <20130807185743.GA4311@localhost>
References: <5202698A.6070109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab3HGS5x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:57:53 -0400
Content-Disposition: inline
In-Reply-To: <5202698A.6070109@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 05:36:42PM +0200, Thomas Woerner wrote:
> Hello,
> 
> according to the libnfnetlink README the license is GPLv2+, but the
> information in src/iftable.c and src/rtnl.c is "GNU GPLv2" without
> the "+". Is this intentional?
> 
> src/iftable.c: * This software is Free Software and licensed under
> GNU GPLv2.
> src/rtnl.c: * This software is free software and licensed under GNU GPLv2.
> README:This library is released under GPLv2+.

Those are leftovers, fixed here.

http://git.netfilter.org/libnfnetlink/commit/?id=617fe823da5bef47dac77c19bf811ce211f148e9
