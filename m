From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 12:46:21 +0200
Message-ID: <20130620104621.GC31140@macbook.localnet>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
 <51C17E26.2020608@linux.intel.com>
 <20130620094243.GA5703@localhost>
 <51C2D0D8.1020309@linux.intel.com>
 <20130620101012.GA19679@localhost>
 <51C2DB10.1060607@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58770 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3FTKqZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:46:25 -0400
Content-Disposition: inline
In-Reply-To: <51C2DB10.1060607@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 01:36:00PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>Hum, how?
> >>The handle it will get from the notification is the handle of the
> >>newly created rule, not the one used to identify the rule for
> >>insertion.
> >That's right. I don't come with any other way to make it rather than
> >adding a new attribute.
> 
> Yes, though it breaks the design logic of the current API, somehow.
> 
> I mean, attributes are currently reflecting the rule as it is, and
> are used symmetrically in queries/replies.
> 
> Here what we need is a temporary extra attribute, or some sort, only
> used for the notification.
> 
> Either via:
> 
> we don't add an element to enum nft_rule_attributes {}, instead we
> create another enum for attributes only used on notification.
> like enum nft_rule_extras_notifications_attributes {}
> 
> 
> Or via (maybe better for nla policy way of working?):
> 
> Adding a nft_rule_attributes as NFTA_RULE_EXTRAS_NOTIFICATIONS as a
> nested attribute
> and then enum nft_rule_extras_notifications_attributes {} again, etc etc...
> 
> 
> It's just a quick proposal, but my point here is to keep the API
> semantically sane.
> So it won't require extra guesses to understand how it's supposed to work
> (as it is right now: it's a sane API, besides the lonely
> NFT_RULE_F_COMMIT in its anonymous enum)
> 
> Maybe there is a better way, probably. But you get my point.

We could instead of using NLA_RULE_HANDLE for the position add a new
attribute NLA_RULE_POSITION and use that both for creating rules and
for notifications. It would always be set and contain the handle of
the rule preceeding the new rule (for NLM_F_APPEND) or the one
following it (for !NLM_F_APPEND).
