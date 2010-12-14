From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: IPTables API (redux)
Date: Tue, 14 Dec 2010 15:41:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1012141534090.9787@ask.diku.dk>
References: <AANLkTinphM_EPoFVWm63qXEpvFZzUuMjrOVyMx7S-ArW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: James Nurmi <jdnurmi@qwe.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:53120 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab0LNOlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:41:18 -0500
In-Reply-To: <AANLkTinphM_EPoFVWm63qXEpvFZzUuMjrOVyMx7S-ArW@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 11 Dec 2010, James Nurmi wrote:

> I realize this has come up a few times, but I'd like to
> programmatically be able to  query and modify IPTables rules, without
> shelling out.
>
> After digging, it would seem theres been some discussion around this
> issue, but I was unable to find any resolution.

I have created a Perl CPAN module named IPTables::libiptc, for doing 
iptables manipulation directly from Perl.

The only problem with this Perl module is I have not had time to update it 
to use the newer libiptc API introduced (by Jan) in 1.4.3.  Thus, its only 
compatible below version 1.4.3.


> For curiosities sake, I did a bit of reverse engineering and
> discovered that the functionality I'm interested in appears to be
> handled through set/getsockopt and requires a large amount of handling
> for both COMPAT and not COMPAT kernel compilations, leading to
> structures potentially being packed differently on the way in then on
> the way out, so a "trivial" implementation was just out as far as I
> could tell.

You should use the libiptc for parsing the "blob".

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
