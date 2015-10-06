From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] segfault in expr_clone()
Date: Tue, 6 Oct 2015 11:23:15 +0200
Message-ID: <20151006092315.GB1568@salvia>
References: <CAOkSjBgyW232aqidQ-EPPinpAqkd21pjqV3W0VE_0N3RVL89pg@mail.gmail.com>
 <CAOkSjBgHradNUToxoUdQ_6H3yyUaGSJ=4RroZTxBLtAcGdz7bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbbJFJQT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 05:16:19 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgHradNUToxoUdQ_6H3yyUaGSJ=4RroZTxBLtAcGdz7bw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 06, 2015 at 10:58:08AM +0200, Arturo Borrero Gonzalez wrote:
> On 6 October 2015 at 10:48, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > Hi,
> >
> > debian users are reporting [0] a segfault related to expr_clone().
> >
> > Is this the issue fixed by Florian's patch [1] ?
> 
> Ok, I've checked myself. Florian's patch address the issue.

Florian, please push out this fix.

I would like to have a closer look to the inet/ether conflicts.

Thanks!
