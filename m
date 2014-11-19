From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 adjust policy in user-defined chains
Date: Wed, 19 Nov 2014 13:36:04 +0100
Message-ID: <20141119123604.GA8544@salvia>
References: <20141117123622.11349.43033.stgit@nfdev.cica.es>
 <20141118184343.GA5179@salvia>
 <CAOkSjBjFf9vi98B8oJ1y2LGjaYg+s4nP1uMKn0bqCUYh2wxRFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbaKSMeC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:34:02 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjFf9vi98B8oJ1y2LGjaYg+s4nP1uMKn0bqCUYh2wxRFg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 19, 2014 at 01:23:01PM +0100, Arturo Borrero Gonzalez wrote:
> On 18 November 2014 19:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>                       if (command == 'N' && c == 'P') {
> >> -                             command = c;
> >> -                             optind--; /* No table specified */
> >> -                             goto handle_P;
> >> +                             xtables_error(PARAMETER_PROBLEM,
> >> +                                           "The default policy in user-defined"
> >> +                                           " chains is RETURN (mandatory)");
> >>                       }
> >
> > I'd really prefer to avoid changes in the ebtables parser. Could you
> > perform this checking from later on, when validating the
> > configuration.
> >
> >         if (strcmp(chain, "INPUT") != 0 &&
> >             strcmp(chain, "FORWARD") != 0 &&
> >             ...                           &&
> >             strcmp(policy, "RETURN") != 0)
> >                 xtables_error("...);
> >
> 
> In the user-defined chain creation path, the code jumps to several
> places (the goto handle_P; thing). I don't see clearly a zone where to
> put these validations.
> 
> Could you please point to where would you like to put this code?

This will leave the while ((c = getopt_long ...) loop at some point,
right? So perform the validation after the parsing is done.
