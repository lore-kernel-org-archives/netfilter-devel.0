From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] simplify list handing in ifname2index infrastructure
Date: Thu, 22 May 2008 15:09:20 +0200
Message-ID: <20080522130920.GM7436@bayen.regit.org>
References: <483564C0.2000100@netfilter.org> <20080522125443.GL7436@bayen.regit.org> <48356EFD.4000704@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Anton <anton.vazir@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:38765 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010AbYEVNH5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 09:07:57 -0400
Content-Disposition: inline
In-Reply-To: <48356EFD.4000704@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thursday, 2008 May 22 at 15:02:53 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> > 
> > On Thursday, 2008 May 22 at 14:19:12 +0200, Pablo Neira Ayuso wrote:
> >> Hi!
> >>
> >> The patch attached simplifies the ifname2index list handling by using
> >> linux list and it introduces minor cleanups such as remove iftb_log()
> >> calls. This patch also fixes the leak in the nlif_close path (we forgot
> >> to release the ifindex nodes from the hashes) that Anton has reported.
> >>
> >> Slightly tested here. If you are OK with it I'll apply it asap.
> > 
> > Maybe, this patch is a little too much for a code which should disappear for
> > libnl ?
> 
> Well, the current code is broken and we have to fix it anyway. If you
> don't have any other objection I'll apply it asap.

My patch fixes the issue without too much changes and we use current
code in NuFW without trouble for years. As we have only one open, we
don't suffer from the memory leak.

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
