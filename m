From: Jeff Haran <Jeff.Haran@citrix.com>
Subject: RE: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Mon, 1 Jul 2013 17:06:29 +0000
Message-ID: <4E5779AD88B2F040B8A7E83ECF544D1A01B387@SJCPEX01CL02.citrite.net>
References: <cover.1371423775.git.mr.dash.four@googlemail.com>
 <51BE49D4.1010901@googlemail.com>
 <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu>
 <51CCBE8A.3080305@googlemail.com>
 <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
 <alpine.DEB.2.00.1306291307270.25929@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Dash Four <mr.dash.four@googlemail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:29587 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3GARGb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:06:31 -0400
In-Reply-To: <alpine.DEB.2.00.1306291307270.25929@blackhole.kfki.hu>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Jozsef Kadlecsik [mailto:kadlec@blackhole.kfki.hu]
> Sent: Saturday, June 29, 2013 4:10 AM
> To: Jeff Haran
> Cc: Dash Four; Pablo Neira Ayuso; Netfilter Core Team
> Subject: RE: [PATCH v2 2/5] ipset: add "inner" flag implementation
> 
> On Thu, 27 Jun 2013, Jeff Haran wrote:
> 
> > ...
> > > I disagree. By having "return false" (or "return 0", "return -1" and so
> > > on) instead of "goto err" it is not immediately apparent to someone who
> > > studies/reviews/uses the code that this is an error condition/path. I
> > > have been in that situation many times when I have to go back and look
> > > at a particular function call to see what "return false" or "return 0"
> > > actually means.
> > >
> > > By including "goto err" instead of multiple "return false" statement,
> > > that makes it instantly obvious what the purpose of that statement is
> > > without having to look elsewhere.
> >
> > I suppose as an alternative you could go way against the usual practice
> > and put some text in a function header comment block indicating what the
> > return code means. I know it doesn't get used much but C has had this /*
> > comment */ thing for a long time. I've never understood why more people
> > don't use it.
> 
> In general I'd agree with you, but this is a boolean function. So why
> should the the meaning of the return value "true" and "false" be
> explained? (This is also why I regard the goto unnecessary.)
> 
I was just pointing out that if there was some concern by the author of this code that the intent of the function would not be clear to other readers, instead of "commenting" it via a coding standard (using the goto) it would be easier and clearer to simply write a function header comment describing it. In this particular case where the return code is a bool and the function is setting something, then it's pretty clear that if it returns true it worked and if it returns false it didn't, but the author described other cases where he had to research "what 'return false' or 'return 0' actually means in other kernel sources and he didn't want to create the same issue for others reading his code. I personally can sympathize with that, I've often been in the same boat trying to understand what t
 he author of some piece of code had intended by a return of 0. Comments are easy to write and they remove ambiguity so long as they are kept up to date. They also serve to document what an author intended the code to do, which is not always what it actually does.

Jeff Haran

