From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 5/6] ipset: Support comments in the userspace library.
Date: Wed, 18 Sep 2013 20:49:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309182046450.21599@blackhole.kfki.hu>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379423605-22777-6-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309182022560.21599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:34072 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab3IRSt6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:58 -0400
In-Reply-To: <alpine.DEB.2.00.1309182022560.21599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 18 Sep 2013, Jozsef Kadlecsik wrote:

> On Tue, 17 Sep 2013, Oliver wrote:
> 
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > This adds support to the userspace portion of ipset for handling ipsets
> > with the comment extension enabled. The library revision has been raised
> > accordingly.
> > 
> > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > ---
> >  Make_global.am                  |  2 +-
> >  include/libipset/data.h         |  6 +++++-
> >  include/libipset/linux_ip_set.h |  7 +++++++
> >  include/libipset/parse.h        |  2 ++
> >  include/libipset/print.h        |  3 +++
> >  lib/data.c                      | 34 ++++++++++++++++++++++++++++++++++
> >  lib/debug.c                     |  1 +
> >  lib/errcode.c                   |  2 ++
> >  lib/libipset.map                |  6 ++++++
> >  lib/parse.c                     | 27 +++++++++++++++++++++++++++
> >  lib/print.c                     | 31 +++++++++++++++++++++++++++++++
> >  lib/session.c                   |  8 +++++++-
> >  lib/types.c                     |  4 ++--
> >  13 files changed, 128 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Make_global.am b/Make_global.am
> > index 29b5678..9c228cc 100644
> > --- a/Make_global.am
> > +++ b/Make_global.am
> > @@ -69,7 +69,7 @@
> >  # interface. 
> >  
> >  #            curr:rev:age
> > -LIBVERSION = 4:0:1
> > +LIBVERSION = 4:1:2
> >  
> >  AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
> >  	-I/usr/local/include
> > diff --git a/include/libipset/data.h b/include/libipset/data.h
> > index 2b6b8cd..ae0d099 100644
> > --- a/include/libipset/data.h
> > +++ b/include/libipset/data.h
> > @@ -57,6 +57,8 @@ enum ipset_opt {
> >  	IPSET_OPT_COUNTERS,
> >  	IPSET_OPT_PACKETS,
> >  	IPSET_OPT_BYTES,
> > +	IPSET_OPT_COMMENTS,
> > +	IPSET_OPT_COMMENT,
> 
> Both cases are here, and then used mixed below. Stick to "COMMENT" 
> everywhere.

Ohh, I got it: the first is for the create option and the second is for 
the attribute.

This is highly error prone. Please rename the first one to 
IPSET_OPT_CREATE_COMMENT, or the second one to IPSET_OPT_ADT_COMMENT, 
whichever you prefer.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
