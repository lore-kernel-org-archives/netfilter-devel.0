From: Florian Westphal <fw@strlen.de>
Subject: Re: kernel 4.5.1 issue at system boot
Date: Mon, 23 May 2016 12:08:11 +0200
Message-ID: <20160523100811.GA9385@breakpoint.cc>
References: <CAOkSjBh-P0RNKhNeR8fBmRVda7mtU9332punaUufO4Rx3aqpqA@mail.gmail.com>
 <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbcEWKIO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2016 06:08:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> On 23 May 2016 at 08:49, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > This was in the log of my system boot today:
> >
> 
> Probably more readable in this link:
> 
> http://paste.debian.net/695904/

This looks like an ABBA-style deadlock of
net_mutex and nfnl_lock(NFNL_SUBSYS_NFTABLES).

