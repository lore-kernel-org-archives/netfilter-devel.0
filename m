From: Thomas Jacob <jacob@internet24.de>
Subject: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 21:00:43 +0200
Message-ID: <1211482843.28066.40.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:54152 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYEVTAp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 15:00:45 -0400
Received: from mailin01.ims-firmen.de ([192.168.1.110])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1JzG1r-0001NL-Lw
	for netfilter-devel@vger.kernel.org; Thu, 22 May 2008 21:00:43 +0200
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin01.ims-firmen.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1JzG1r-00034n-KK
	for netfilter-devel@vger.kernel.org; Thu, 22 May 2008 21:00:43 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list,

In a reply to a post last week about netfilter/iptables's performance
(see below for link), Patrick McHardy wrote about him working 
on a successor to iptables that would be able to manipulate
single rules in a set without any need to replace the whole
ruleset, and that would also include native support
for match sets and the like:

http://marc.info/?l=netfilter-devel&m=121085934512644

Are the plans for that online somewhere? Is there
a envisioned time line?

I'm asking because I'm thinking about whether or not
it's feasible and/or sensibly to write some kind
of target module that I'm choosing to call "jumpset" for now, that
would act as a fast (>O(log(n)) "jump diststribution point".

The idea is to have a mapping between a a potentially large set of IP
addresses and the chain/target space, so one could have a different
"next chain" for each  different source/target IP or possibly
source/target network. The internal implementation of the necessary
data structures would be something along the lines of the ipset
extension. 

The application would be being able to provide customized
rule sets for lots of different machines at just a few central netfilter
boxen. Or perhaps to block traffic from different attack sources in
completely different ways in an IDS/IPS system.

In some cases one could of course achieve a similar functionality by
constructing rule trees with the existing standard distribution but that
could create a huge number of rules that simply link to the next chain
and in general looks rather messy.

But if iptables will be fundamentally different next year or if
it will already contain something similar, it would probably not be very
productive to work on such a module.

Also if this whole idea is stupid, a waste of time, has already been
done or whatever, I'd really like to know.

Any thoughts on this would be very welcome.

    Regards,
        Thomas


