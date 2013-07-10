From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements
 to the kernel code
Date: Wed, 10 Jul 2013 19:22:05 +0100
Message-ID: <51DDA64D.3000408@googlemail.com>
References: <514D9D45.6090804@googlemail.com> <20130323151213.GA4925@localhost> <515203F6.10503@googlemail.com> <20130403104647.GA5464@localhost> <515DE46F.9080505@googlemail.com> <20130411101803.GA4254@localhost> <516A7BE2.2050009@googlemail.com> <20130419020444.GA5605@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63222 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3GJSWP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:22:15 -0400
Received: by mail-lb0-f171.google.com with SMTP id 13so5909105lba.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:22:13 -0700 (PDT)
In-Reply-To: <20130419020444.GA5605@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,


Pablo Neira Ayuso wrote:
> On Sun, Apr 14, 2013 at 10:50:26AM +0100, Michael Zintakis wrote:
>> With placing these properties into the kernel they will also occupy
>> less memory and the performance would be better, compared to if all
>> this is done in user space (not to mention possible synchronization
>> issues as the code in user space needs to "track" nfacct objects in
>> the kernel and do that flawlessly).
> 
> Check /etc/iproute2/ files, they all contain mappings and information
> that are parsed from user-space utilities in runtime by many utilities
> and daemons. Nobody has put that information into the kernel.
Very true, but that information in this file is self-contained and relates to one logical object. The case with nfacct is very different since if we use both a file and kernel memory to store information about a single object (nfacct in this case), then the properties of that object will be in two separate places, which will require extra coding to "sync" both "sides" and even then, this is not guaranteed that the "file" side won't contain "useless" data.

Say I execute "nfacct flush" - what then? The kernel will clear the relevant part of the nfacct properties, leaving only nfacct objects intact which have been used by iptables. So, unless you make another extra round of kernel call to determine what is left in the main table, then the "file" side is bound to contain "useless" data as you mentioned it before.

I also mentioned in previous post that the information contained in the "file" side may, deliberately or otherwise, be changed, which at least in our case, is not desirable since the nfacct (executable), as well as nfacctd (the daemon) will rely heavily on it.
 
> And more relevantly, these fields you want to add are bloating the
> accounting structure for people that don't want your feature.
That is an unfair point Pablo! Like everything else in the kernel (and not only there - user space libraries or tools as well), when new features are introduced, they are not always "optional" - you don't have kernel config menu "bloated" with all 1000's of possible features of a given components since the beginning of time listed as y/n choices - the kernel config would look like a Christmas shopping list.
 
>> My concern with this is that even though you say it is extensible,
>> there will be quite a lot of redesigning and rewriting of code - the
>> ulogd2 primary function is to check packets and pipe this through
>> various "channels" defined in advance at start up, which is quite
>> different from the functionality required by the nfacct daemon.
> 
> ulogd2 is a generic framework in user-space for packet logging, it
> could be extended relatively easy to support what you need.
We decided at the end to go with the nfacctd (nfacct daemon) route because everything there will be tailored for the specific purpose of that daemon and we won't be "bloating" it with extra features/code we don't need as was the case with ulog daemon. We just completed a major part of the testing and the code is fairly stable - more or less.

In the next couple of posts I will enclose the latest nfacct patches (I am getting to know git better these days, hehe) where I followed your previous advice and "split" everything up in smaller "tasks" so that it makes it easier for you/anybody else to look at it. I also created these patches in a specific sequence so that the more "complex" features are left towards the end.

I also excluded the entire nfacct daemon (nfacctd) code from the 2 user space components - will include this when it is fully completed and we are confident that it does its job and if there is interest in it, of course.


MZ
