From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: add tee statement support
Date: Tue, 10 Mar 2015 12:34:45 +0100
Message-ID: <20150310113445.GA3814@salvia>
References: <20150309193820.6763.36920.stgit@nfdev.cica.es>
 <CAOkSjBhq2z0kmq3Xd_smgcj+JoVCn7kEJHCRz2ccRc5FTVpiGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40390 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbbCJLbB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 07:31:01 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhq2z0kmq3Xd_smgcj+JoVCn7kEJHCRz2ccRc5FTVpiGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 11:31:00AM +0100, Arturo Borrero Gonzalez wrote:
> On 9 March 2015 at 20:38, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > The syntax is:
> >  tee gw <addr> [oifname <str>]
> >
> [...]
> >
> > +tee_stmt               :       tee_stmt_alloc  tee_stmt_opt
> > +                       ;
> > +
> > +tee_stmt_alloc         :       TEE
> > +                       {
> > +                               $$ = tee_stmt_alloc(&@$);
> > +                       }
> > +                       ;
> > +
> > +tee_stmt_opt           :       GW              expr
> > +                       {
> > +                               $<stmt>0->tee.gw = $2;
> > +                       }
> > +                       |       OIFNAME         STRING
> > +                       {
> > +                               $<stmt>0->tee.oifname = strdup($2);
> > +                       }
> > +                       ;
> > +
> 
> This grammar is not completely right.
> 
> However, using something like this:
> 
> tee_stmt                :       TEE             tee_stmt_opts
>                         {
>                                 $$ = tee_stmt_alloc(&@$);
>                         }
>                         ;
> 
> tee_stmt_opts           :       tee_stmt_opts   tee_stmt_opt
>                         |       tee_stmt_opt
>                         ;
> 
> tee_stmt_opt            :       GW              expr
>                         {
>                                 $<stmt>0->tee.gw = $2;
>                         }
>                         |       OIFNAME         string
>                         {
>                                 $<stmt>0->tee.oifname = strdup($2);
>                         }
>                         ;
> 
> lead to shift/reduce conflicts, because expr can be `OIFNAME string'.
> 
> Any idea?

You use STRING instead for GW and make sure from the evaluation step
that this is a valid address?
