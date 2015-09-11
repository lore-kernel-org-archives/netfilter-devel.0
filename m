From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: use existing table object from evaluation
 context
Date: Fri, 11 Sep 2015 14:32:49 +0200
Message-ID: <20150911123249.GA5700@salvia>
References: <1441843168-5632-1-git-send-email-pablo@netfilter.org>
 <CAOkSjBiXNzmiM5hWfEpn1_y0OiAV-6E-WpYwzRDWe-mMnpqAug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbbIKM0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2015 08:26:11 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiXNzmiM5hWfEpn1_y0OiAV-6E-WpYwzRDWe-mMnpqAug@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 10, 2015 at 08:31:25AM +0200, Arturo Borrero Gonzalez wrote:
> On 10 September 2015 at 01:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Skip table object lookup if we are in the context of table declaration already,
> > ctx->table already points to the right table we have to use during the
> > evalution. Otherwise, a list corruption occurs when using the wrong table
> > object when it already exists in the kernel.
> >
> > http://marc.info/?l=netfilter-devel&m=144179814209295&w=2
> >
> > Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/evaluate.c |   22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> >
> 
> I can't reproduce the issue with this patch, thanks.
> 
> Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Thanks for testing Arturo.
