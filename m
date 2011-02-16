From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: can libnetfilter_conntrack be used to write a userspace connection
 tracker?
Date: Thu, 17 Feb 2011 00:12:13 +0100
Message-ID: <4D5C59CD.3080701@netfilter.org>
References: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>	<4D2E1EF6.1010003@netfilter.org>	<AANLkTi=CjQZW5mOmgsk8yjk3Q10iDQp4VLYFqM43T+Ah@mail.gmail.com>	<4D5BCF12.5010001@netfilter.org> <AANLkTim9ANWYvJ5NGBt_8roRLzC21Kep1ZGHU48nwkPY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53317 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab1BPXMX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:12:23 -0500
In-Reply-To: <AANLkTim9ANWYvJ5NGBt_8roRLzC21Kep1ZGHU48nwkPY@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/02/11 18:52, Sam Roberts wrote:
> On Wed, Feb 16, 2011 at 5:20 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Probably you have hit one of the bugs that went into 2.6.37. Please, try
>> the patch attached. IIRC, this is fixed in -stable and 2.6.38 and later
>> kernels.
> 
> Since I'm not yet building my kernels from source, its easier for me
> to build a newer kernel than to find an old one and patch it.
> 
> Stable is 2.6.37, I'll try 2.6.38-rc5.

I'm using 2.6.37 with the patch that I sent you in one of my firewalls:

$ uname -a
Linux debian2 2.6.37 #7 SMP Mon Feb 7 10:34:10 UTC 2011 x86_64 GNU/Linux

Everything works fine.

> userspace connection trackers seems a bit bleading edge, I'd be happy
> to build your latest code from git if you point me to it.

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=summary

It's stable, I'll release 1.0 soon.

Some more work can be done on it to port it to libmnl, add H323 and SIP
support, active-active support, among tons of many other improvements.
But that can be done in the future.

> I'm now two steps back since upgrading from ubuntu's default kernel
> 2.6..35 and tools 0.9.14.
> 
> It used to be everything but setting expectations was working for me,
> but I no longer get updates at all about the conntrack table, and
> neither does conntrack -E or -L:
> 
> % sudo conntrack -L conntrack
> conntrack v0.9.15 (conntrack-tools): 0 flow entries have been shown.

As said, here works fine with the patch that I attached ;-)
