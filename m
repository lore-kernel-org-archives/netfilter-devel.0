From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: nft parser and problems with icmp type names (redirect and param-problem)
Date: Wed, 01 Apr 2015 15:15:43 +0200
Message-ID: <551BEF7F.3050908@ahsoftware.de>
References: <551BA511.6010901@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:35242 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbDANPy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Apr 2015 09:15:54 -0400
Received: from wandq.ahsoftware (p4FC37DD0.dip0.t-ipconnect.de [79.195.125.208])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id ABAB22C9C1C5
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2015 15:15:48 +0200 (CEST)
In-Reply-To: <551BA511.6010901@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.04.2015 um 09:58 schrieb Alexander Holler:
> Hello,
>
> are the problems with some named icmp types known?
>
> I'm talking about
>
> host ~ # nft add rule ip6 filter input icmpv6 type { param-problem } accept
> <cmdline>:1:41-53: Error: syntax error, unexpected param-problem
> add rule ip6 filter input icmpv6 type { param-problem } accept
>                                          ^^^^^^^^^^^^^
> host ~ # nft add rule filter input icmp type { redirect } accept
> <cmdline>:1:35-42: Error: syntax error, unexpected redirect
> add rule filter input icmp type { redirect } accept

This message is basically to get Eric Leblond on board, who seems to 
have written the stuff which made it possible to use icmp type names.


But to add something useful to this message too:

Having digged a bit further I see two solutions.

- Change all the icmp type names to not get in conflict with tokens 
(keywords), e.g. by prefixing them with "icmp_" or "icmpv6_" like 
"icmp_redirect". That would be a clean and straight forward solution. 
Unfortunately it would mean old (icmp type) rules won't work and 
personally I think the longer names would be a bit unhandy to use.

- Add context dependency to the parser. The relevant part in the bison 
manual would be the chapter "Handling Context Dependencies": 
http://www.chemie.fu-berlin.de/chemnet/use/info/bison/bison_10.html

Personally I would prefer the second solution, also it means the code 
would become a bit more complicated.

Any comments which solution would be prefered by other people?

Regards,

Alexander Holler

BTW: I think this currently a bit a show stopper. One definitely wants 
to filter icmp and one definitely wants to save/restore rulesets. It is 
no problem for people which are writing their rulesets by hand, but 
those which are dynamically changing rules, likely are relying on the 
possibility to save and restore the whole ruleset (and being able to 
filter icmp).

