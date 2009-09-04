From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Fri, 4 Sep 2009 11:28:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909041124090.27609@obet.zrqbmnf.qr>
References: <cover.1251295408.git.bazsi@balabit.hu> <4AA0AE8C.30203@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54137 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbZIDJ16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:27:58 -0400
In-Reply-To: <4AA0AE8C.30203@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-09-04 08:07, Amos Jeffries wrote:
>>
>> Also, I have written a Python test script to test TProxy functionality
>> automatically both for IPv4 and IPv6, I can post that as well if anyone is
>> interested.
>
> I'm interested :)
>
> Now that you have done this I'm going to have to find a robust userland
> run-time test to see if the underlying TPROXY is v4-only or v6-enabled. If
> anyone has suggestions they would be welcome.

Would this perhaps suffice?

assert(socket(PF_INET6, ...) >= 0);
assert(setsockopt(fd, SOL_IP, IP_TRANSPARENT, ...) == 0);
assert(bind(fd, {::2}) == 0);

At least something like that I remember to have used to determine
tproxy-2.x ipv4 availability in the days. (I.e. seeing if setsockopt
failed.)
