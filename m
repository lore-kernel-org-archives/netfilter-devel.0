From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 24/29] add packets and bytes mark capability
 to nfacct
Date: Thu, 11 Jul 2013 19:56:50 +0100
Message-ID: <51DEFFF2.5050709@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com> <20130710200157.GD27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42034 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3GKS46 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:56:58 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so6876487lbv.41
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 11:56:56 -0700 (PDT)
In-Reply-To: <20130710200157.GD27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Florian Westphal wrote:
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> * add two variables to each nfacct object - 'pmark' and 'bmark', allowing
>> short-term traffic accounting to be implemented by placing a "mark" against
>> that object.
>>
>> This enables counting of traffic (both bytes and packets) since that mark has
>> been enabled/set, in addition to the main packet and byte counters.
> 
> And again.
> Why not simply add a 2nd accounting object, and then send traffic to
> it based on ruleset? (-m time, -m condition, -m set, etc.)?
We thought of that initially, but rejected that idea.

The marking feature is, at least in our case, primarily used to measure short-term traffic. What that means is for us to be able to gather information for traffic based on certain events or characteristics in short term (peak time or certain event during which we expect our traffic to rise/slow down dramatically for example) and produce the relevant statistics without affecting the main traffic counters.

Adding separate nfacct objects to the iptables rules (which is what I think you are suggesting above) isn't very efficient or practical, simply because: a) certain traffic is going to be spread over different iptables rules in different places (i.e. chains) and in order to add a "secondary" nfacct objects one needs to do that everywhere - in every rule - a certain "primary" nfacct object is used; b) a packet will have to pass through 2 nfacct objects in order to produce the desired effect (with marking, a packet passes and is counted simply once and that is the end of the story), not to mention that it would require nearly twice-as-much memory per accounting object, compared to if we use marking, so this is inefficient; and c) in order to add/remove nfacct objects for short-term traffic me
 asurements like this and deploy what you are suggesting above, one needs to have full knowledge of the entire iptables structure and the whole netfilter system used, which is not always the 
case - at least not here, so what you suggest above isn't practical.
