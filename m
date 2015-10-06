From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft] segfault in expr_clone()
Date: Tue, 6 Oct 2015 12:15:06 +0200
Message-ID: <20151006101506.GB12921@breakpoint.cc>
References: <CAOkSjBgyW232aqidQ-EPPinpAqkd21pjqV3W0VE_0N3RVL89pg@mail.gmail.com>
 <CAOkSjBgHradNUToxoUdQ_6H3yyUaGSJ=4RroZTxBLtAcGdz7bw@mail.gmail.com>
 <20151006092315.GB1568@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57544 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbbJFKPJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 06:15:09 -0400
Content-Disposition: inline
In-Reply-To: <20151006092315.GB1568@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 06, 2015 at 10:58:08AM +0200, Arturo Borrero Gonzalez wrote:
> > On 6 October 2015 at 10:48, Arturo Borrero Gonzalez
> > <arturo.borrero.glez@gmail.com> wrote:
> > > Hi,
> > >
> > > debian users are reporting [0] a segfault related to expr_clone().
> > >
> > > Is this the issue fixed by Florian's patch [1] ?
> > 
> > Ok, I've checked myself. Florian's patch address the issue.
> 
> Florian, please push out this fix.

pushed and marked accepted in patchwork.

