From: Dennis Jacobfeuerborn <dennisml@conversis.de>
Subject: Re: Nftables HOWTO documentation updates
Date: Wed, 19 Feb 2014 16:13:37 +0100
Message-ID: <5304CA21.9040309@conversis.de>
References: <20140218112543.GA4799@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail3.conversis.de ([213.203.208.210]:59476 "EHLO
	mail3.conversis.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaBSPcd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:32:33 -0500
In-Reply-To: <20140218112543.GA4799@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.02.2014 12:25, Pablo Neira Ayuso wrote:
> Hi,
>
> I have registered a subdomain for nftables that hosts the nftables
> user HOWTO, you can reach it via:
>
>          http://wiki.nftables.org

I checked out the HOWTO and it gives a really nice concise introduction 
to how nftables work. Good work!

After browsing through the pages I have two questions:

Is it possible to comment rules like in iptables? Comments in iptables 
made it really easy to manage rules on a logical level i.e. I could 
define rule "types" by adding a special comment like "TYPE:X" and then 
use that to grep for these rules to batch-remove them or retrieve the 
counter values. It would be nice to be able to tag rules like this.

How do I insert multiple rules? The insertion example show the addition 
of a single rule after a known handle but what if I want to add a second 
rule after that? As far as I can tell from the example the add rule 
command does not return the handle of the inserted rule so I have no 
idea where to insert the second rule. Even if the command returned the 
handle it would still require scripting to add multiple consecutive 
rules so there should be a way to specify to add a list of rules 
(atomically?) after a given handle.

Not sure if these features are not available or just not documented yet 
but I'm approaching this by thinking about the use-cases I encounter and 
looking at how I would implement these using nftables instead of iptables.

Regards,
   Dennis
