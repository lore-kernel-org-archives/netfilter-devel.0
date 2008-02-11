From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: iptables + geoip
Date: Mon, 11 Feb 2008 05:45:28 -0500
Message-ID: <dd45289d0802110245k7620a640l87c97b1cdaae60c3@mail.gmail.com>
References: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
	 <dd45289d0802110054t1ceeb84fk53f6b9a086bdd8ca@mail.gmail.com>
	 <32880.193.36.79.206.1202720426.squirrel@webmail.tdd.org.uk>
	 <dd45289d0802110134l366f8bafnefec41c9141feb71@mail.gmail.com>
	 <31029.193.36.79.206.1202725118.squirrel@webmail.tdd.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: rob@thirddimensiondesign.co.uk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:21663 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbYBKKpc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:45:32 -0500
Received: by wx-out-0506.google.com with SMTP id h31so4725084wxd.4
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Feb 2008 02:45:29 -0800 (PST)
In-Reply-To: <31029.193.36.79.206.1202725118.squirrel@webmail.tdd.org.uk>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Robert,

I still get no segfault,

If you could reproduce it and send me the debugging output would be nice.

cheers,

Nicolas

On Feb 11, 2008 5:18 AM, Robert Bruce <rob@thirddimensiondesign.co.uk> wrote:
> apologies, it was GB I used. I'm not at my PC where I tried it, so that
> syntax is from what I can remember.
>
> I compiled the csv from maxmind.com using the csv2bin utility.
>
> I patched my kernel and iptables, enabled the option in my kernel and
> re-compiled for both. When I got the error I re-compiled with debug
> support and ran the command under gdb, which is how I could tell that the
> match parameter being passed into the parse function was a pointer 0x0.
>
> I don't believe it's a problem with the kernel as it works for iptables
> 1.3.6, but not 1.4.0.
>
> here's some system specs, the kernel -dedicated is the suffix I've given
> to the custom kernel with the ipt_geoip module
>
> > uname -a
> Linux debian 2.6.18.5-dedicated #1 SMP Thu Feb 7 21:56:01 GMT 2008 x86_64
> GNU/Linux
> > gcc -v
> Using built-in specs.
> Target: x86_64-linux-gnu
> Configured with: ../src/configure -v
> --enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr
> --enable-shared --with-system-zlib --libexecdir=/usr/lib
> --without-included-gettext --enable-threads=posix --enable-nls
> --program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu
> --enable-libstdcxx-debug --enable-mpfr --enable-checking=release
> x86_64-linux-gnu
> Thread model: posix
> gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
>
> Is there anything else I could do to help?
>
>
> On Mon, February 11, 2008 9:34 am, NICOLAS BOULIANE wrote:
> > Robert,
> >
> > 1- UK isn't an ISO3166 valid code.
> >
> >      UNITED KINGDOM -> GB
> >      UKRAINE -> UA
> > see:
> > http://www.iso.org/iso/country_codes/iso_3166_code_lists/english_country_names_and_code_elements.htm#u..
> >
> > 2- Personally I get no segfault.
> >
> > wyn:/home/acidfu# iptables -A INPUT -p tcp --dport 22 -m geoip !
> > --src-cc UK -j DROP
> > iptables v1.4.0: geoip match: sorry, 'UK' isn't in the database
> >
> > 3- what files you have into /var/geoip ?
> >
> > 4- You just tried to patch your kernel and iptables or what ? or its
> > an old patched kernel and you tried to update iptables ?
> >
> > cheers,
> >
> > Nicolas Bouliane
> >
> >
> > On Feb 11, 2008 4:00 AM, Robert Bruce <rob@thirddimensiondesign.co.uk>
> > wrote:
> >> I wanted to block everything but the UK from ssh access, so
> >>
> >> iptables -A INPUT -p tcp --dport 22 -m geoip ! --src-cc UK -j DROP
> >>
> >> I have the 2.6.18-5 kernel
> >>
> >>
> >> On Mon, February 11, 2008 8:54 am, NICOLAS BOULIANE wrote:
> >> > Hello Robert,
> >> >
> >> > Can you tell me the exact rule syntax you used ?
> >> >
> >> > p.s. I'm actually updating geoip so it use the xtables framework,
> >> >
> >> > cheers,
> >> >
> >> > Nicolas Bouliane
> >> >
> >> > On Feb 11, 2008 3:30 AM, Robert Bruce <rob@thirddimensiondesign.co.uk>
> >> > wrote:
> >> >> Hello
> >> >>
> >> >> I tried to send this to the developers of geoip, but the email got
> >> >> returned to me. I can't put this on bugzilla as it is down at the
> >> >> moment...
> >> >>
> >> >> Original Email:
> >> >>
> >> >> Hi Guys
> >> >>
> >> >> I've just tried to install geoip with iptables 1.4.0, everything is
> >> fine
> >> >> until I try to add a rule which uses the geoip module and I get a
> >> >> Segmentation fault. So I did some digging, compiled with -g for gdb
> >> and
> >> >> found that the problem is on line 229 as match is passed in with an
> >> >> address to 0x0.
> >> >>
> >> >> I dunno how to fix that though..
> >> >>
> >> >>
> >> >> -
> >> >> To unsubscribe from this list: send the line "unsubscribe
> >> >> netfilter-devel" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >> >
> >>
> >>
> >>
> >
>
>
>
