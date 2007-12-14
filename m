From: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [BUG?] ip6tables: 32bit userspace doesn't work with 64bit kernel
Date: Fri, 14 Dec 2007 21:19:13 +0100
Message-ID: <68676e00712141219j671d37f5mde4c805cf28d7d0@mail.gmail.com>
References: <20071208223737.GA8885@dreamland.darkstar.lan>
	 <475C1425.7070608@trash.net>
	 <68676e00712100509q1fcbf42dx6bcb46e95467ac91@mail.gmail.com>
	 <475F9DA4.4000502@trash.net> <47601606.5010009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:8646 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbXLNUTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:19:15 -0500
Received: by wr-out-0506.google.com with SMTP id c49so963586wra.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Dec 2007 12:19:14 -0800 (PST)
In-Reply-To: <47601606.5010009@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 12, 2007 6:10 PM, Patrick McHardy <kaber@trash.net> wrote:
> Patrick McHardy wrote:
> > Luca Tettamanti wrote:
> >
> >> Ok, feel free to throw patches this way for testing ;-)
> >
> > I've completed the compat support, but its about 25 patches -
> > do you want me to start throwing? :) Otherwise just wait for
> > a few days, I'll send them upstream as soon as the iptables
> > compat fix is in net-2.6.25 since they depend on that one.
>
>
> I figured out how to tell git to export them all as one big
> patch, so if you want to do some testing, please go ahead.
> Might apply to Linus' current -git tree, otherwise please
> use net-2.6.25.

I'm currently running net-2.6.25 plus the patch (plus trivial mergin):
so far so good :)

thanks,
Luca
