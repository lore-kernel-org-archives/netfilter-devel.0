From: David Miller <davem@davemloft.net>
Subject: Re: Formal submission of Xtables2
Date: Mon, 17 Dec 2012 17:27:17 -0800 (PST)
Message-ID: <20121217.172717.2202727200383149321.davem@davemloft.net>
References: <20121217143018.GB1106@1984>
	<alpine.LNX.2.01.1212171936410.18910@nerf07.vanv.qr>
	<alpine.DEB.2.00.1212172356530.16469@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@inai.de, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	zenczykowski@gmail.com
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54252 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2LRB1U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:27:20 -0500
In-Reply-To: <alpine.DEB.2.00.1212172356530.16469@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Tue, 18 Dec 2012 00:49:26 +0100 (CET)

> On Mon, 17 Dec 2012, Jan Engelhardt wrote:
> 
>> On Monday 2012-12-17 15:30, Pablo Neira Ayuso wrote:
>> 
>> >On Mon, Dec 17, 2012 at 02:01:07PM +0100, Jan Engelhardt wrote:
>> >[...]
>> >> >So far, I haven't see any *strong reason* to drop nftables code
>> >> 
>> >> In all fairness, I have never said anything about dropping nft.
>> >> I am focused on xt2, its inclusion and subsequent maintenance, because 
>> >> it resolves the ipt shortcomings in a way that I think appeals most to 
>> >> the userspace crowd.
>> >
>> >I'm still not convinced but I want find a short-term compromise
>> >solution for this which does not involve tons of email. We'll announce
>> >the netfilter workshop soon, likely to happen at Q1 2013 depending on
>> >availability of the organizer, but maybe Q2 2013 (but not later), I
>> >think it's the place to debate your proposal and nftables, of course.
>> >
>> >I will not get anything into mainline until then.
>> 
>> Delaying this for more months is not a good idea, I think.
>> 
>> The amount of patches will grow as more features are implemented. If
>> there is an objection to a patch, then this can have implications for
>> all those that follow (not rebase conflicts, but actual
>> invalidating), which gets more painful the larger the patchset is.
> 
> A few months won't really hurt - TPROXY had been discussed for a couple of 
> years at every workshop (and it was much simpler, smaller code). Both 
> nftables and xtables2 have got nice features, so it's not a simple 
> question.

Agreed.
