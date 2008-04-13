From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/8] [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Sun, 13 Apr 2008 07:24:18 +0200
Message-ID: <48019902.8020301@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>  <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de>  <47FCBFBF.5020805@trash.net> <1207858306.2899.8.camel@localhost.localdomain> <alpine.LNX.1.10.0804102229380.21182@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYDMFYX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:24:23 -0400
In-Reply-To: <alpine.LNX.1.10.0804102229380.21182@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-04-10 22:11, Bart De Schuymer wrote:
>> Op wo, 09-04-2008 te 15:08 +0200, schreef Patrick McHardy:
>>> Jan Engelhardt wrote:
>>>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>>
>>> I like these patches (modulo the small NFPROTO_ARP nitpicks),
>>> I'd like to get an ACK from Bart before applying them though.
>>>
>>> I assume this doesn't affect userspace compatibility?
>> I'm wondering why the checks for the size of the match info is removed
>> in every module,
>> If it isn't wrong, I presume there is an obvious way for someone to find
>> out this is required?
> 
> Because this is now done inside x_tables.c in the xt_check_match()
> function by means of checking the .matchsize/.targetsize parameters
> in struct xt_match/xt_target. Except for ebt_among which seems
> to go against all other 85 modules do... and uses a
> dynamic size for its data.
> 
>> I didn't check the xtables specific stuff too much but I presume Jan
>> tested this with a released ebtables version...
> 
> Not quite. ebt_among's dynamic size is unbelivably creepy.
> I might just even state the corollary that it causes the kernel
> to oops if the condition is right, and there is no chance to fix
> it without completely rewriting the private structure it uses.
> 
> That being said, the patch currently causes a warning to be
> issued whenever an among rule is inserted, which I probably
> should address.

Yes, that shouldn't happen.

