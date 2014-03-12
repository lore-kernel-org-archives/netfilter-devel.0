From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: some minor tweaks for building doc/man pages for nftables
Date: Wed, 12 Mar 2014 08:16:47 -0400 (EDT)
Message-ID: <alpine.LFD.2.11.1403120814010.6264@localhost>
References: <alpine.LFD.2.11.1403120529570.4122@localhost> <CAOkSjBiKQHg7TYU_nQmNgtC_fzybe3LOLsO-JktJx=7oQsYBCQ@mail.gmail.com> <alpine.LFD.2.11.1403120701510.5974@localhost> <CAOkSjBjJ7f_ANknUa3ojoaHF_+meYFe1dkOCBzOBFdAC3pxxkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter devel list <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:38644 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaCLMQv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:16:51 -0400
In-Reply-To: <CAOkSjBjJ7f_ANknUa3ojoaHF_+meYFe1dkOCBzOBFdAC3pxxkA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 12 Mar 2014, Arturo Borrero Gonzalez wrote:

> On 12 March 2014 12:03, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> >   quite possibly some of it, but surely the "nftables.xml" file
> > under doc/ should be updated to reflect that the command is now
> > "nft", not "nftables", no?
> >
>
> In Debian, my plan is to provide the same man page both for 'nft'
> and 'nftables' (one being a symlink to the other).

  ok, that sounds fine but, just for the record, the *official*
userspace command name is "nft", is it not? so linking to a man page
that purports to explain "nftables" is going to be a bit confusing.

> >   anyway, i'll leave this in the hands of the powers-that-be on
> > this list.
>
> In the docbook side, you could try to find a solution that covers
> all/most-important distributions. I would suggest to simply send
> patches so we can review your ideas.

  i'll see what i can come up with that isn't distro-specific.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
