From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: iptables + geoip
Date: Mon, 11 Feb 2008 21:34:33 -0500
Message-ID: <dd45289d0802111834y274d8391h1a4a05b49750cdd0@mail.gmail.com>
References: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
	 <20080212010409.GA19332@69.17.112.251>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Robert Bruce" <rob@thirddimensiondesign.co.uk>,
	netfilter-devel@vger.kernel.org
To: "Nick Pasich" <NewsLetters@nickandbarb.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:15549 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYBLCef (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:34:35 -0500
Received: by wr-out-0506.google.com with SMTP id c48so4337198wra.23
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Feb 2008 18:34:35 -0800 (PST)
In-Reply-To: <20080212010409.GA19332@69.17.112.251>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Nick,

I updated geoip,

now the new pom-ng url is:
http://people.netfilter.org/acidfu/patchlets/

change it manually in your pom-ng/sources.list ....
Peejix will send a patch soon so the url will be directly change.

Keep me in touch,
thank you

Nicolas Bouliane

On Feb 11, 2008 8:04 PM, Nick Pasich <NewsLetters@nickandbarb.net> wrote:
>
> I got the same thing using iptables 1.4.0.
>
> I used patch geoip-match-2.6.22.patch.gz that I've
> been using for quite awhile ... there is no other patch available.
>
> My kernel version is 2.6.23.13
>
> I went back to iptables 1.3.8 and everything is fine.
>
>              ---( Nick )---
>
>
>
>
> On Mon, Feb 11, 2008 at 08:30:56AM -0000, Robert Bruce wrote:
> > Hello
> >
> > I tried to send this to the developers of geoip, but the email got
> > returned to me. I can't put this on bugzilla as it is down at the
> > moment...
> >
> > Original Email:
> >
> > Hi Guys
> >
> > I've just tried to install geoip with iptables 1.4.0, everything is fine
> > until I try to add a rule which uses the geoip module and I get a
> > Segmentation fault. So I did some digging, compiled with -g for gdb and
> > found that the problem is on line 229 as match is passed in with an
> > address to 0x0.
> >
> > I dunno how to fix that though..
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
