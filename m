From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [PATCH] dynamic calculation of event message size for
 ctnetlink
Date: Tue, 17 Mar 2009 13:16:38 +0100
Message-ID: <49BF94A6.6080508@trash.net>
References: <20090317094909.6434.27331.stgit@Decadence> <49BF91A8.2070900@trash.net> <20090317121446.GB3526@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45411 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZCQMQm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:16:42 -0400
In-Reply-To: <20090317121446.GB3526@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> On Tue, Mar 17, 2009 at 01:03:52PM +0100, Patrick McHardy wrote:
> 
>> OK seriously, we need *some* numbers showing an improvement since I
>> have basically zero base to decide between your patches, besides the
>> fact that its to be expected that Holger's will be slightly faster.
> 
> I think we can give the hard numbers in the next 1-3 days.  Do you 
> have a special test in mind?  Pablo, how did you test then?

Nothing too complicated. I guess either a raw throughput benchmark,
some cycle counting for event delivery or event delivery throughput
would all be fine.


