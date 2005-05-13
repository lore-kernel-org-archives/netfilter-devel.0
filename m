From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Fri, 13 May 2005 07:43:09 +0200
Message-ID: <20050513054309.GA5962@roonstrasse.net>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
	<20050508205821.GE393@oknodo.bof.de>
	<1115588688.2031.11.camel@www.l-chr.com.ar>
	<20050512080820.GA19043@roonstrasse.net>
	<1115953825.2050.22.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
Content-Disposition: inline
In-Reply-To: <1115953825.2050.22.camel@www.l-chr.com.ar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On 2005/05/13 05:10, Christian Hentschel <chentschel@arnet.com.ar> wrote:
> > * parse_ipaddr(): don't cast (const char*) to (char*) - endp should be
> >   "const char**". same in epaddr_len.
> > 
> Why?

Casting const to non-const is bad code style. If you're declaring
something const, there's a reason, therefore it should stay const. If
you have to deconst something, there is something really wrong in your
code. I pointed out to you what's wrong: there are functions which
want non-const parameters, where const suffices. Change that, remove
the cast, everything ok.

> 
> > * in ip_nat_sip.c, you should not parse the packet again - this has
> >   already been done in in_conntrack_sip.c. sip_help() should pass the
> >   offsets it found over to ip_nat_sip() - see the other conntrack
> >   helpers, they all have "unsigned int matchoff, unsigned int
> >   matchlen" as parameter
> > 
> I think it's kind of impossible with SIP. But if u have an idea, please
> let me know.

I havn't read the code that much, and I don't know SIP. But I'll look
at it later.


> > * again, I'm not sure: in ct_sip_get_info(), you use strncmp() to work
> >   with dptr, implying that dptr is a null-terminated string. You
> >   should check the length of dptr, not that of hnfo->lname, which _is_
> >   a null terminated string. I believe, hnfo->lnlen and hnfo->snlen are
> >   superfluous for this reason.
> 
> You r wrong. dptr is not null terminated. 

Exactly that's my point - dptr is *not* null terminated, that is why
you must not use it with strncmp(), unless you give strncmp() the
correct limit, which you do not.

   if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&

What if length_of(dptr) happens to be smaller than hnfo->lnlen?
strncmp() will violate dptr's boundary => kernel crashing.

> Thanks Max, i'll post some patches fixing and changeing some things
> after i get the code into pom-ng. Some help with testing would be highly
> appreciated. I'll try to add some nfsim testsuite too.

The netfilter people are quite busy, don't wait for them.

Max
