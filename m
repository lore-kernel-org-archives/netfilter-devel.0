From: Alexander Holler <holler@ahsoftware.de>
Subject: nft parser and problems with icmp type names (redirect and param-problem)
Date: Wed, 01 Apr 2015 09:58:09 +0200
Message-ID: <551BA511.6010901@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:45609 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbbDAH6P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Apr 2015 03:58:15 -0400
Received: from wandq.ahsoftware (p4FC37DD0.dip0.t-ipconnect.de [79.195.125.208])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 6EB812C9C1C4
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2015 09:58:12 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

are the problems with some named icmp types known?

I'm talking about

host ~ # nft add rule ip6 filter input icmpv6 type { param-problem } accept
<cmdline>:1:41-53: Error: syntax error, unexpected param-problem
add rule ip6 filter input icmpv6 type { param-problem } accept
                                         ^^^^^^^^^^^^^
host ~ # nft add rule filter input icmp type { redirect } accept
<cmdline>:1:35-42: Error: syntax error, unexpected redirect
add rule filter input icmp type { redirect } accept

Having had a quick look the source, the first one seems to come from the 
fact that "param-problem" is a token as well as an icmpv6-type name.

I haven't looked at the second problem, but I assume it's similiar, 
because "redirect" is now a token too.

Both problems can be cirumvented by using their code instead of name (4 
or 5), but then another problem will arise when trying to save/restore a 
nft ruleset.

E.g. if you call

nft add rule filter input icmp type { 5 } accept

nft list table filter

will show it with the type name, so restoring will fail.


As I'm not familiar with parser, I thought it might be a good idea to 
ask here before I start to think about trying to solve the problem myself.


Regards,

Alexander Holler
