From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: iptables + geoip
Date: Mon, 11 Feb 2008 04:38:15 -0500
Message-ID: <dd45289d0802110138k6521957cp5f966b52e8ee80f9@mail.gmail.com>
References: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
	 <dd45289d0802110054t1ceeb84fk53f6b9a086bdd8ca@mail.gmail.com>
	 <32880.193.36.79.206.1202720426.squirrel@webmail.tdd.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: rob@thirddimensiondesign.co.uk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:40383 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYBKJiP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:38:15 -0500
Received: by wf-out-1314.google.com with SMTP id 28so162417wff.4
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Feb 2008 01:38:15 -0800 (PST)
In-Reply-To: <32880.193.36.79.206.1202720426.squirrel@webmail.tdd.org.uk>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Robert,

1- UK isn't an ISO3166 valid code.

    UNITED KINGDOM -> GB
    UKRAINE -> UA
see:
http://www.iso.org/iso/country_codes/iso_3166_code_lists/english_country_names_and_code_elements.htm#u..

2- Personally I get no segfault.

wyn:/home/acidfu# iptables -A INPUT -p tcp --dport 22 -m geoip !
--src-cc UK -j DROP
iptables v1.4.0: geoip match: sorry, 'UK' isn't in the database

3- what files you have into /var/geoip ?

4- You just tried to patch your kernel and iptables or what ? or its
an old patched kernel and you tried to update iptables ?

cheers,

Nicolas Bouliane

On Feb 11, 2008 4:00 AM, Robert Bruce <rob@thirddimensiondesign.co.uk> wrote:
> I wanted to block everything but the UK from ssh access, so
>
> iptables -A INPUT -p tcp --dport 22 -m geoip ! --src-cc UK -j DROP
>
> I have the 2.6.18-5 kernel
>
>
> On Mon, February 11, 2008 8:54 am, NICOLAS BOULIANE wrote:
> > Hello Robert,
> >
> > Can you tell me the exact rule syntax you used ?
> >
> > p.s. I'm actually updating geoip so it use the xtables framework,
> >
> > cheers,
> >
> > Nicolas Bouliane
> >
> > On Feb 11, 2008 3:30 AM, Robert Bruce <rob@thirddimensiondesign.co.uk>
> > wrote:
> >> Hello
> >>
> >> I tried to send this to the developers of geoip, but the email got
> >> returned to me. I can't put this on bugzilla as it is down at the
> >> moment...
> >>
> >> Original Email:
> >>
> >> Hi Guys
> >>
> >> I've just tried to install geoip with iptables 1.4.0, everything is fine
> >> until I try to add a rule which uses the geoip module and I get a
> >> Segmentation fault. So I did some digging, compiled with -g for gdb and
> >> found that the problem is on line 229 as match is passed in with an
> >> address to 0x0.
> >>
> >> I dunno how to fix that though..
> >>
> >>
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe
> >> netfilter-devel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
>
>
>
