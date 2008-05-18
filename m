From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: iptables performance and alternatives
Date: Sun, 18 May 2008 23:15:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805182253160.10481@tyr.diku.dk>
References: <200805151421.23862.anton.vazir@gmail.com>
 <200805151535.31933.anton.vazir@gmail.com>
 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
 <200805151557.28368.anton.vazir@gmail.com>
 <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
 <1210857556.24732.10.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Anton VG <anton.vazir@gmail.com>
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:57266 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYERVPm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 May 2008 17:15:42 -0400
In-Reply-To: <1210857556.24732.10.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thu, 15 May 2008, Thomas Jacob wrote:

> On Thu, 2008-05-15 at 13:18 +0200, Jan Engelhardt wrote:
>> On Thursday 2008-05-15 12:57, Anton wrote:
>>
>>> Definitelly what my test shows - while rule-inserts - if you
>>> try to insert 10000 rules - after a several hundreds - it
>>> will be inserting like a 1 rule in 1 second and slowness
>>> will progress :)
>>
>> Your insertion slowness is probably due to incorrect use of iptables.
>
> What do you mean by that? Isn't it a fact, that the iptables command
> utility and to a  lesser extent also iptables-restore  is pretty slow in
> updating the ruleset when you have a large number of rules, simply
> because it copies the entire ruleset to userspace, modifies it there,
> and then copies the resulting rule set back to the kernel?

Yes, its true that iptables is slow with large rule sets (even when using 
iptables-restore).  It does copy the entire ruleset everytime, but the 
copy process (between userspace and kernel) is not the slow part, its the 
parsing the ruleset (libiptc).

I have fixed some of the ruleset parsing issues in libiptc. (50k chains 
ruleset listing reduced from 5 minuts to 0.5 sec).

(Already accepted in latest SVN/git:)
  http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commit;h=73ff92a2b0f338374a1f9830009d38b1f0ccaf42

There are still some libiptc scalability issues left... That I promised 
Patrick I would solve... Lets hope I'll fix them before the workshop ;-)

If doing a lot of rule changes, you should definitly use iptables-restore 
or CPAN perl module IPTables::libiptc.

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
