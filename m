From: Ed W <lists@wildgooses.com>
Subject: Re: ipset "contains" question
Date: Tue, 26 Jul 2011 11:24:21 +0100
Message-ID: <4E2E95D5.1040408@wildgooses.com>
References: <4E2DED59.1030902@wildgooses.com> <alpine.DEB.2.00.1107261151210.20945@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:33622 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1GZKYX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2011 06:24:23 -0400
In-Reply-To: <alpine.DEB.2.00.1107261151210.20945@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

>> Many thanks for ipset.  Quick question please: I'm implementing a
>> captive portal and I have an ipset (CP) containing bitmap:ip,mac.  How
>> should I best implement rules to:
>>
>> - Drop packets from same IP, different MAC
>>
>> I might be missing the obvious, but how do I query to match on IP, then
>> drop IP with a mismatching MAC (in the bitmap ipset)? Can this be done
>> without a second ipset tracking only IP?
> 
> At a first glance I'd allow packets from (IP, MAC) and drop everything 
> else, i.e. (same IP, different MAC) and (different IP, same MAC), etc.

Thanks - I think it's important to separate the traffic, not block it
for my situation. You need to login to the captive portal, so some
traffic needs to flow without being authenticated. I think you can very,
very nearly have a clean split between auth/non auth users, but for
flexibility my idea was to add some specific blocks/drops to classes of
users who were clearly trying to cheat

(And yes I do get that "auth" based on IP/Mac has some significant
limitations...)


> If you want to match the IP address only, too, then a single set is not 
> sufficient, unfortunately.

That's fine.  Do you think it's a sensible feature request that has a
use elsewhere? ie given a bitmap:ip,mac, does it make sense to want to
search it for just IP or Mac?

Additionally it would have been very useful to use an ipset to assign a
packet mark, ie the "result" of an ipset is also stored in the ipset.
Do you think this is a reasonable feature request..? (what other
"parameters" do people want to lookup, flow rates, marks, last seen,
time constraints..?)

Thanks for creating ipsets - very helpful!

Ed W
