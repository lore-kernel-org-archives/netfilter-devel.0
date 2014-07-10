From: giorgio.nicole@arcor.de
Subject: Aw: Re: [PATCH 4/7] autotools conversion: include the header
 'config.h' in every C source file.
Date: Thu, 10 Jul 2014 12:32:18 +0200 (CEST)
Message-ID: <1421640070.472816.1404988338916.JavaMail.ngmail@webmail23.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:52569 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbaGJKcU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:32:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 


----- Original Nachricht ----
Von:     Patrick McHardy <kaber@trash.net>
An:      Giorgio Dal Molin <giorgio.nicole@arcor.de>
Datum:   10.07.2014 12:04
Betreff: Re: [PATCH 4/7] autotools conversion: include the header 'config.h'
 in every C source file.

> On Mon, Jul 07, 2014 at 04:19:28PM +0200, Giorgio Dal Molin wrote:
> > Added an #include <config.h> to all the C source files so that the
> results
> > of the tests in the configure script are available to all the compilation
> > units.
> > 
> > We could have added the include also to 'yacc_parser.y' and 'scanner.l'
> > but we don't, because it is not strictly needed and to avoid to define
> > the variable 'VERSION' two times.
> 
> > --- a/src/cli.c
> > +++ b/src/cli.c
> > @@ -11,6 +11,9 @@
> >   *
> >   * Development of this code funded by Astaro AG (http://www.astaro.com/)
> >   */
> > +#ifdef HAVE_CONFIG_H
> > +#include <config.h>
> > +#endif
> 
> Do we really need those ifdefs?
>

Hi,

do you mean just the #ifdefs or the whole #include <config.h> ?

The config.h should be included, unless there are real problems with it; one I've found
is the preprocessor variable VERSION defined in the yacc source 'src/yacc_parser.y':
it would conflict with the same variable defined in the 'config.h'.

Actually, if you just build the package under linux, using the ./configure... && make all install
you will always generate / include the config.h, so the #ifdef is not strictly needed.

giorgio
