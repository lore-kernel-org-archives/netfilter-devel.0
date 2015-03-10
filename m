From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] src: add tee statement support
Date: Tue, 10 Mar 2015 16:51:46 +0100
Message-ID: <20150310155144.GC9129@acer.localdomain>
References: <20150309193820.6763.36920.stgit@nfdev.cica.es>
 <CAOkSjBhq2z0kmq3Xd_smgcj+JoVCn7kEJHCRz2ccRc5FTVpiGw@mail.gmail.com>
 <20150310113445.GA3814@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41395 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbCJPvv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 11:51:51 -0400
Content-Disposition: inline
In-Reply-To: <20150310113445.GA3814@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.03, Pablo Neira Ayuso wrote:
> On Tue, Mar 10, 2015 at 11:31:00AM +0100, Arturo Borrero Gonzalez wrote:
> > On 9 March 2015 at 20:38, Arturo Borrero Gonzalez
> > <arturo.borrero.glez@gmail.com> wrote:
> > > The syntax is:
> > >  tee gw <addr> [oifname <str>]
> > >
> > [...]
> > >
> > > +tee_stmt               :       tee_stmt_alloc  tee_stmt_opt
> > > +                       ;
> > > +
> > > +tee_stmt_alloc         :       TEE
> > > +                       {
> > > +                               $$ = tee_stmt_alloc(&@$);
> > > +                       }
> > > +                       ;
> > > +
> > > +tee_stmt_opt           :       GW              expr
> > > +                       {
> > > +                               $<stmt>0->tee.gw = $2;
> > > +                       }
> > > +                       |       OIFNAME         STRING
> > > +                       {
> > > +                               $<stmt>0->tee.oifname = strdup($2);
> > > +                       }
> > > +                       ;
> > > +
> > 
> > This grammar is not completely right.
> > 
> > However, using something like this:
> > 
> > tee_stmt                :       TEE             tee_stmt_opts
> >                         {
> >                                 $$ = tee_stmt_alloc(&@$);
> >                         }
> >                         ;
> > 
> > tee_stmt_opts           :       tee_stmt_opts   tee_stmt_opt
> >                         |       tee_stmt_opt
> >                         ;
> > 
> > tee_stmt_opt            :       GW              expr
> >                         {
> >                                 $<stmt>0->tee.gw = $2;
> >                         }
> >                         |       OIFNAME         string
> >                         {
> >                                 $<stmt>0->tee.oifname = strdup($2);
> >                         }
> >                         ;
> > 
> > lead to shift/reduce conflicts, because expr can be `OIFNAME string'.
> > 
> > Any idea?
> 
> You use STRING instead for GW and make sure from the evaluation step
> that this is a valid address?

Never use string please, it breaks symbol resolution. symbol_expr would
be a better choice.
