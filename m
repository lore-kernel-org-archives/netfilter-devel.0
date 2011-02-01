From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 3/6] ipset: pass ipset_arg argument pointer
Date: Tue, 1 Feb 2011 21:10:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102012108360.24267@blackhole.kfki.hu>
References: <20110124213631.195499507@jonathan.eitzenberger.org> <20110124214012.012613658@jonathan.eitzenberger.org> <alpine.DEB.2.00.1101252139400.19580@blackhole.kfki.hu> <alpine.DEB.2.00.1101271104170.24771@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:52748 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1BAUKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:10:04 -0500
In-Reply-To: <alpine.DEB.2.00.1101271104170.24771@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 27 Jan 2011, Jozsef Kadlecsik wrote:

> Hi Holger,
> 
> On Tue, 25 Jan 2011, Jozsef Kadlecsik wrote:
> 
> > On Mon, 24 Jan 2011, Holger Eitzenberger wrote:
> > 
> > > Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> > > 
> > > Index: ipset/src/ipset.c
> > > ===================================================================
> > > --- ipset.orig/src/ipset.c
> > > +++ ipset/src/ipset.c
> > > @@ -208,7 +208,6 @@ call_parser(int *argc, char *argv[], con
> > >  {
> > >  	int i = 1, ret = 0;
> > >  	const struct ipset_arg *arg;
> > > -	const char *optstr;
> > >  	
> > >  	/* Currently CREATE and ADT may have got additional arguments */
> > >  	if (!args)
> > > @@ -221,7 +220,6 @@ call_parser(int *argc, char *argv[], con
> > >  				i++;
> > >  				continue;
> > >  			}
> > > -			optstr = argv[i];
> > >  			/* Shift off matched option */
> > >  			D("match %s", arg->name[0]);
> > >  			ipset_shift_argv(argc, argv, i);
> > > @@ -236,10 +234,7 @@ call_parser(int *argc, char *argv[], con
> > >  				/* Fall through */
> > >  			case IPSET_OPTIONAL_ARG:
> > >  				if (i + 1 <= *argc) {
> > > -					ret = ipset_call_parser(session,
> > > -							arg->parse,
> > > -							optstr, arg->opt,
> > > -							argv[i]);
> > > +					ret = ipset_call_parser(session, arg, argv[i]);
> > >  					if (ret < 0)
> > >  						return ret;
> > >  					ipset_shift_argv(argc, argv, i);
> > > @@ -247,10 +242,7 @@ call_parser(int *argc, char *argv[], con
> > >  				}
> > >  				/* Fall through */
> > >  			default:
> > > -				ret = ipset_call_parser(session,
> > > -							arg->parse,
> > > -							optstr, arg->opt,
> > > -							optstr);
> > > +				ret = ipset_call_parser(session, arg, argv[1]);
> > 
> > We can't do this, because then the flag-style options (no arg) cannot be 
> > parsed. So I cannot apply this patch and the next two ones based on it.
> 
> If optstr is kept, then that can be passed to the parser in the default 
> branch. Could you rewrite your patch that way and resend to me (and the 
> dependent ones too)?

I re-added the missing bits and applied your patches. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
