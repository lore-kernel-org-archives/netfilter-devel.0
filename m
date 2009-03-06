From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build error when compiling nfsim against 2.6.23.17
Date: Fri, 6 Mar 2009 19:42:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903061939480.21430@fbirervta.pbzchgretzou.qr>
References: <ad28918e0903041223t7edb61d3hb479b3ca3c91ed26@mail.gmail.com>  <49AFC4BB.8090102@netfilter.org>  <ad28918e0903060902o21e72ae1r65fb7f1680b8e618@mail.gmail.com>  <alpine.LSU.2.00.0903061931280.21430@fbirervta.pbzchgretzou.qr>
 <ad28918e0903061037g9b58ab3sc11b9cc9f438c6db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Fred Moyer <fred@redhotpenguin.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51151 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZCFSmn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:42:43 -0500
In-Reply-To: <ad28918e0903061037g9b58ab3sc11b9cc9f438c6db@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-03-06 19:37, Fred Moyer wrote:
>>>
>>>What is the recommended alternative for testing connection helper modules?
>>
>> Testing them in a real world - perhaps virtual machines though - setup :-)
>
>I've had great success developing and testing with VMWare Fusion on a
>mac laptop.  The reboot time on an oops is maybe two minutes, about
>the same as my metal testing server, except lacking the fan noise and
>ability to live on my laptop.

At least VMware Workstation has the Snapshot feature which cuts the
"reboot" time down to whatever it takes to reread the disk image from disk.

>I looked through the nfsim unit tests - very nice design, reminds me
>of a lot of the perl code testing I do with Test::More.  It seems like
>a testing approach that would lead to faster development than pushing
>packets.  Normally to test I 'tail -f /var/log/kernel', and have
>tcpdump running, but if I oops then I lose all that state.

Avoiding oopses is the best strategy, at which point you can reedit-
compile-reload the module as often as you need without reverting to
a snapshot.
>

