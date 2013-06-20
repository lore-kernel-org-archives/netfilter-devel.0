From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 13:36:00 +0300
Message-ID: <51C2DB10.1060607@linux.intel.com>
References: <1371628997-13548-1-git-send-email-eric@regit.org> <51C17E26.2020608@linux.intel.com> <20130620094243.GA5703@localhost> <51C2D0D8.1020309@linux.intel.com> <20130620101012.GA19679@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab3FTKgC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:36:02 -0400
In-Reply-To: <20130620101012.GA19679@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Hum, how?
>> The handle it will get from the notification is the handle of the
>> newly created rule, not the one used to identify the rule for
>> insertion.
> That's right. I don't come with any other way to make it rather than
> adding a new attribute.

Yes, though it breaks the design logic of the current API, somehow.

I mean, attributes are currently reflecting the rule as it is, and are 
used symmetrically in queries/replies.

Here what we need is a temporary extra attribute, or some sort, only 
used for the notification.

Either via:

we don't add an element to enum nft_rule_attributes {}, instead we 
create another enum for attributes only used on notification.
like enum nft_rule_extras_notifications_attributes {}


Or via (maybe better for nla policy way of working?):

Adding a nft_rule_attributes as NFTA_RULE_EXTRAS_NOTIFICATIONS as a 
nested attribute
and then enum nft_rule_extras_notifications_attributes {} again, etc etc...


It's just a quick proposal, but my point here is to keep the API 
semantically sane.
So it won't require extra guesses to understand how it's supposed to work
(as it is right now: it's a sane API, besides the lonely 
NFT_RULE_F_COMMIT in its anonymous enum)

Maybe there is a better way, probably. But you get my point.


Tomasz
