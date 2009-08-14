From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables] optimization steps before rules get send to the kernel
Date: Fri, 14 Aug 2009 14:38:25 +0200
Message-ID: <4A855AC1.9040904@trash.net>
References: <4A8486B7.2070308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZHNMib (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:38:31 -0400
In-Reply-To: <4A8486B7.2070308@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> Hi,
> 
> from the nftables announcement:
> 
>> Redundant information might get lost before it is sent to the kernel,
>> but both the kernel and the reconstructed ruleset are semantically
>> equivalent.
> 
> As I'm currently not aware of a possibility to dump the actual rules
> currently used by the kernel, to investigate this myself, I would have
> another question:

nft list table filter
nft list chain filter output
nft list sets filter
nft list set filter xyz

> Does the optimization which removes redundant information also remove
> entire redundant rules or redundant checks within rules?
> 
> example:
> 
> ip saddr 1.1.1.1 tcp dport 22 accept
> tcp dport 22 accept
> 
> would become
> tcp dport 22 accept
> 
> 
> tcp sport 0-65535 tcp dport 80 accept
> would become
> tcp dport 80 accept
> 
> if not: is something like this planed for the future or will the
> stupidity of big rulesets never be removed by nftables? ;)

It does not currently. Its planned for the future to perform
optimizations across the entire ruleset. It requires a few
limitations though, f.i. in your example, it needs to make
sure you won't insert a rule between those two later on.

