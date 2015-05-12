From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Probably bug in netfilter hashlimit extension
Date: Tue, 12 May 2015 09:42:32 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505120941260.6613@nerf40.vanv.qr>
References: <20150511125834.GA19053@ikki.ethgen.ch> <20150511135037.GA7877@breakpoint.cc> <20150511210900.GA11413@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Klaus Ethgen <Klaus+lkml@ethgen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:36109 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbbELHme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2015 03:42:34 -0400
In-Reply-To: <20150511210900.GA11413@ikki.ethgen.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-05-11 23:09, Klaus Ethgen wrote:
>> > Recently I tried to mitigate some slow attacks via netfilter rule
>> > utilizing hashlimit target. I used the following specification:
>> > 
>> >    -A DETECT_INVALID -m hashlimit --hashlimit-upto 10/hour --hashlimit-mode srcip --hashlimit-name attack_invalid -j RETURN
>> > 
>> > Now I seen some strange stuff. The counter in
>> > /proc/net/ipt_hashlimit/attack_invalid only counts from 60 back to 0 and
>> 
>> Can't reproduce this with 4.0 on x86_64, using iptables 1.4.21 (64bit):
>> 3598 127.0.0.1:0->0.0.0.0:0 8119296 57600000 11520000
>
>From your post I also tried and are not able to reproduce it on
>localhost.
>... And after flushing the table and reinstalling the filter, the
>problem is gone completly.
>
>I just think now, that it is not initializing the hashlimit correctly
>when overwriting a table with iptables-restore that already has such a
>hastable in use with the same name. I never removed entries, I always
>replaced them with iptables-restore.

Well of course, if you use restore, the hashlimit table survives,
because its reference count never goes to zero, itself a result of
the create-table-first-then-delete-old cycle.
