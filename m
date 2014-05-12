From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [contrack-tools PATCH] build: do not compile nfct if we disabled
 cttimeout
Date: Mon, 12 May 2014 17:23:54 +0200
Message-ID: <20140512152354.GA6781@localhost>
References: <1399543345-3634-1-git-send-email-liuhangbin@gmail.com>
 <20140509112959.GA3812@localhost>
 <20140509115411.GJ25631@localhost.localdomain>
 <20140509135942.GA11325@localhost>
 <20140510025123.GK25631@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaELPYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 11:24:39 -0400
Content-Disposition: inline
In-Reply-To: <20140510025123.GK25631@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 10, 2014 at 10:51:23AM +0800, Hangbin Liu wrote:
> On Fri, May 09, 2014 at 03:59:42PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, May 09, 2014 at 07:54:11PM +0800, Hangbin Liu wrote:
> > > On Fri, May 09, 2014 at 01:29:59PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, May 08, 2014 at 06:02:25PM +0800, Hangbin Liu wrote:
> > > > > If we do not have libnetfilter_cttimeout and disabled cttimeout, conntrack-tools
> > > > > will compile fail because nfct.c include nfnetlink_cttimeout.h. Fix it by only
> > > > > compile nfct when we have enabled cttimeout
> > 
> > OK, I see. That's not nfnetlink_cttimeout.h, it's
> > libnetfilter_cttimeout.h.
> 
> Ah, sorry, my mistake

Please, give a try to the attached patch.

Thanks.
