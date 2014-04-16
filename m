From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] build: delete useless characters
Date: Wed, 16 Apr 2014 18:50:46 +0200
Message-ID: <20140416165046.GA951@macbook.localnet>
References: <20140416161038.1237.5216.stgit@nfdev.cica.es>
 <20140416163258.GA30296@macbook.localnet>
 <CAOkSjBiF2pv5z+wvguL0bTkB2vB=s7QA9-X=koZYP689TjFWoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49243 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaDPQuu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:50:50 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiF2pv5z+wvguL0bTkB2vB=s7QA9-X=koZYP689TjFWoQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 16, 2014 at 06:38:50PM +0200, Arturo Borrero Gonzalez wrote:
> On 16 April 2014 18:32, Patrick McHardy <kaber@trash.net> wrote:
> >
> > I assume you're on debian? The -e is needed to interpret the backslash
> > sequences like \t. Something is broken about the echo command in debian,
> > I'd assume its using the shell internal one instead of /bin/echo.
> >
> 
> Yes, you are right. Then forget this patch.
> 
> I was reading a bit the build system, wondering how to get the actual
> form of the CC commands.

Try using the full path to echo perhaps.
