From: Loganaden Velvindron <logan@elandsys.com>
Subject: Re: Harden iptables memory allocator
Date: Fri, 22 May 2015 03:49:12 -0700
Message-ID: <20150522104912.GA4356@mx.elandsys.com>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com>
 <1432284611.3364.14.camel@stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loganaden Velvindron <loganaden@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:63088 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbbEVKtW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2015 06:49:22 -0400
Content-Disposition: inline
In-Reply-To: <1432284611.3364.14.camel@stressinduktion.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 22, 2015 at 10:50:11AM +0200, Hannes Frederic Sowa wrote:
> Hi,
> 
> On Do, 2015-05-21 at 18:42 +0000, Loganaden Velvindron wrote:
> > A number of Open Source projects such as OpenSSH, nsd, unbound,
> > OpenBSD and FreeBSD have implemented a safe replacement for
> > malloc(x*y) idiom which may lead to overflows.
> > 
> > Quoting from man page:
> > Consider calloc() or the extension reallocarray() when there is
> > multiplication in the size argument of malloc() or realloc(). For
> > example, avoid this common idiom as it may lead to integer overflow:
> > 
> > if ((p = malloc(num * size)) == NULL)
> > err(1, "malloc");
> > 
> > A drop-in replacement is the OpenBSD extension reallocarray():
> > 
> > if ((p = reallocarray(NULL, num, size)) == NULL)
> > err(1, "reallocarray");
> > 
> > 
> > Replacing malloc() with reallocarray() has led to one vulnerability
> > being mitigated:
> > See here: https://www.kb.cert.org/vuls/id/695940
> > 
> > The other advantage is that reallocarray() is faster than calloc(x*y)
> > as there is no zero'ing overhead.
> > 
> > Patch below with a few conversions to reallocarray(). -- Feedback welcomed !
> > 
> > diff --git a/include/xtables.h b/include/xtables.h
> > index bad11a8..e18b4cd 100644
> > --- a/include/xtables.h
> > +++ b/include/xtables.h
> > @@ -418,6 +418,7 @@ extern void xtables_init(void);
> >  extern void xtables_set_nfproto(uint8_t);
> >  extern void *xtables_calloc(size_t, size_t);
> >  extern void *xtables_malloc(size_t);
> > +extern void *xtables_reallocarray(void *, size_t, size_t);
> >  extern void *xtables_realloc(void *, size_t);
> > 
> >  extern int xtables_insmod(const char *, const char *, bool);
> > diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> > index 8db13b4..8964c1e 100644
> > --- a/iptables/ip6tables.c
> > +++ b/iptables/ip6tables.c
> > @@ -858,7 +858,7 @@ for_each_chain6(int (*fn)(const xt_chainlabel,
> > int, struct xtc_handle *),
> >   chain = ip6tc_next_chain(handle);
> >   }
> > 
> > - chains = xtables_malloc(sizeof(xt_chainlabel) * chaincount);
> > + chains = xtables_reallocarray(NULL, chaincount, sizeof(xt_chainlabel));
> >   i = 0;
> >   chain = ip6tc_first_chain(handle);
> >   while (chain) {
> > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > index 5357d12..1f62aa3 100644
> > --- a/libxtables/xtables.c
> > +++ b/libxtables/xtables.c
> > @@ -15,6 +15,23 @@
> >   * along with this program; if not, write to the Free Software
> >   * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> > 02110-1301, USA.
> >   */
> > +
> > +/* xtables_reallocarray.c is under:
> > + * Copyright (c) 2008 Otto Moerbeek <otto@drijf.net>
> > + *
> > + * Permission to use, copy, modify, and distribute this software for any
> > + * purpose with or without fee is hereby granted, provided that the above
> > + * copyright notice and this permission notice appear in all copies.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> > + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> > + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> > + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> > + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> > + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> > + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> > +*/
> > +
> >  #include "config.h"
> >  #include <ctype.h>
> >  #include <errno.h>
> > @@ -308,6 +325,23 @@ void *xtables_malloc(size_t size)
> >   return p;
> >  }
> > 
> > +/*
> > + * This is sqrt(SIZE_MAX+1), as s1*s2 <= SIZE_MAX
> > + * if both s1 < MUL_NO_OVERFLOW and s2 < MUL_NO_OVERFLOW
> > + */
> > +#define MUL_NO_OVERFLOW ((size_t)1 << (sizeof(size_t) * 4))
> > +
> > +void *
> > +xtables_reallocarray(void *optr, size_t nmemb, size_t size)
> > +{
> > + if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
> 
> if ((nmemb|size) >= MUL_NO_OVERFLOW) && ...
> 
> > +    nmemb > 0 && SIZE_MAX / nmemb < size) {
> > + perror("ip[6]tables: reallocarray failed");
> > + exit(1);
> > + }
> 
> Since gcc5.1 you can use __builtin_umul_overflow to let the compiler
> handle that. Maybe you can abstract that away if needed.

If the compiler supports it, then we can take advantage of it. 

The advantage of sticking to the portable implementation of reallocarray
is that it's been extensively tested & mature.

> 
> Bye,
> Hannes
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
