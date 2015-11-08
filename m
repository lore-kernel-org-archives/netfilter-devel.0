From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1 net-next] net: bridge: netfilter: use vzalloc()
 instead of vmalloc() for counterstmp
Date: Sun, 8 Nov 2015 22:30:45 +0100
Message-ID: <20151108213045.GA4259@salvia>
References: <20151030123303.GA19481@mx.elandsys.com>
 <20151108204115.GA2629@salvia>
 <CAOp4FwTa91=dHkWmSz7QzojwbTEo97P1HRXqt7EN=FAKgC1Eaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loganaden Velvindron <logan@elandsys.com>,
	netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <loganaden@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbbKHVXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 16:23:19 -0500
Content-Disposition: inline
In-Reply-To: <CAOp4FwTa91=dHkWmSz7QzojwbTEo97P1HRXqt7EN=FAKgC1Eaw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 08, 2015 at 08:52:50PM +0000, Loganaden Velvindron wrote:
> On Sun, Nov 8, 2015 at 8:41 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Oct 30, 2015 at 05:33:03AM -0700, Loganaden Velvindron wrote:
> >> counterstmp is not cleared before it is used in get_counters(). it might be
> >> leaked partially when it is sent to userland later on.
> >
> > get_counters() is memcpy'ing the old counter to the counterstmp area
> > and updating it.
> >
> > Where is there leak?
> >
> 
> In this case, none, due to correct memcpy parameters in get_counters().
> 
> However, as this is exposed later on to userland through:
> 
>         if (copy_to_user(user, counterstmp,
>            nentries * sizeof(struct ebt_counter)))
> 
> zero'ing counterstmp malloc'ed memory, looks like a good idea.

We allocate room for nentries, then we get_counters() those nentries
that memcpy that area, and we copy back to user nentries.

Where is the problem?
