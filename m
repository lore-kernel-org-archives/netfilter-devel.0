From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [BISECTED][2.6.35 regression] iptables busted on Mac G5
Date: Mon, 23 Aug 2010 15:14:21 +0200
Message-ID: <19570.29741.746144.453539@pilspetsen.it.uu.se>
References: <19546.53659.970308.750410@pilspetsen.it.uu.se>
	<19570.25954.196694.563887@pilspetsen.it.uu.se>
	<20100823121644.GH1727@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:45588 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab0HWNOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:14:24 -0400
In-Reply-To: <20100823121644.GH1727@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal writes:
 > Mikael Pettersson <mikpe@it.uu.se> wrote:
 > >  > I'll try to narrow it down further next week when I'm at the
 > >  > machine's location again.  Meanwhile I would be grateful if
 > >  > anyone has any ideas about what the issue might be.  I'll add
 > >  > that a Mac G4 (ppc32) with similar kernel configuration and
 > >  > user-space works fine with 2.6.35 and iptables.
 > > 
 > > The bug is still present in 2.6.36-rc2.
 > 
 > sigh.
 > Do you run 64 bit kernel with 32bit userland?

Yes.

 > If so, yes, thats broken since 2.6.35. I submitted a fix
 > (http://marc.info/?l=netfilter-devel&m=128116762801769&w=2),
 > but it was not yet applied.
 > 
 > Will resend it later today.

That patch applied to 2.6.35 fixed the problem on my G5.  Thanks!

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

/Mikael
