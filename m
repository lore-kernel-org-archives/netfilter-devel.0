From: Fred Moyer <fred@redhotpenguin.com>
Subject: Re: build error when compiling nfsim against 2.6.23.17
Date: Fri, 6 Mar 2009 10:37:54 -0800
Message-ID: <ad28918e0903061037g9b58ab3sc11b9cc9f438c6db@mail.gmail.com>
References: <ad28918e0903041223t7edb61d3hb479b3ca3c91ed26@mail.gmail.com>
	 <49AFC4BB.8090102@netfilter.org>
	 <ad28918e0903060902o21e72ae1r65fb7f1680b8e618@mail.gmail.com>
	 <alpine.LSU.2.00.0903061931280.21430@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:18989 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbZCFSh4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:37:56 -0500
Received: by rv-out-0506.google.com with SMTP id g37so615950rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Mar 2009 10:37:54 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0903061931280.21430@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 6, 2009 at 10:31 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Friday 2009-03-06 18:02, Fred Moyer wrote:
>>On Thu, Mar 5, 2009 at 4:25 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> Fred Moyer wrote:
>>>> I'm developing a connection tracking module for the 2.6.23.17 kernel
>>>> using the nf_conntrack helper examples (actually porting a nat module
>>>> I had for 2.4.30) and am trying to use the nfsim test framework
>>>> instead of my previous crude method of sending packets through the
>>>> machine.
>>>
>>> Sorry, nfsim currently lacks of maintainer.
>>
>>Ok, I'll make an effort to fix that issue and submit a patch.
>>
>>What is the recommended alternative for testing connection helper modules?
>
> Testing them in a real world - perhaps virtual machines though - setup :-)

I've had great success developing and testing with VMWare Fusion on a
mac laptop.  The reboot time on an oops is maybe two minutes, about
the same as my metal testing server, except lacking the fan noise and
ability to live on my laptop.

I looked through the nfsim unit tests - very nice design, reminds me
of a lot of the perl code testing I do with Test::More.  It seems like
a testing approach that would lead to faster development than pushing
packets.  Normally to test I 'tail -f /var/log/kernel', and have
tcpdump running, but if I oops then I lose all that state.
