From: Florian Westphal <fw@strlen.de>
Subject: [nft crap] ct original ip saddr ... handling
Date: Wed, 28 Jun 2017 12:06:42 +0200
Message-ID: <20170628100659.26976-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33338 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KGl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am running out of time so I have to send this unfinished/non-working
state.

It breaks because ct is riddled with conflicts,
in nft we've handled original/reply as STRING to avoid conflicts
with 'arp reply', so we cannot add

ct original ip saddr

because it is
ct STRING	IP	SADDR

and that conflicts with basic use where 'ip saddr' could be payload
expression, and STRING is one of the normal ct tokens and not a direction.

I am trying to fix this here by moving all ct keywords back to tokens.
There are no shift/reduce errors, things compile fine, and all
test cases work.  Its just that we break 'ct event set label':

Works:
ct event set new or reply
ct event set new,reply
ct event set new,label
fails:
ct event set label ('expects COMMA')

Other than that it should work, this also adds dependency removal
for meta and ct when de-linearizing rulesets and gets rid of
the uneeded meta dependency when using rt nexthop in inet table.

