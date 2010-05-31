From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: scheduled removal of CONFIG_NF_CT_ACCT
Date: Mon, 31 May 2010 17:56:03 +0200
Message-ID: <4C03DC13.9080307@trash.net>
References: <1275220311-12578-1-git-send-email-tobias.doerffel@gmail.com> <4C03D4BA.9070809@trash.net> <alpine.LSU.2.01.1005311751330.9888@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60525 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab0EaP4H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 May 2010 11:56:07 -0400
In-Reply-To: <alpine.LSU.2.01.1005311751330.9888@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-05-31 17:24, Patrick McHardy wrote:
>> Tobias Doerffel wrote:
>>> Removal of the CONFIG_NF_CT_ACCT was already scheduled for 2.6.29,
>>> therefore remove it now and set nf_conntrack.acct depending on
>>> CONFIG_NETFILTER_XT_MATCH_CONNBYTES.
>> This has already been discussed multiple times. The connbytes
>> match needs accounting, so it needs to enable it when the first
>> rule containing a connbytes match is added. This needs to be
>> done in the namespace where the rule is added.
> 
> If it is done as late as rule insertion, connbytes might match (or
> not - and thus be a problem) when there are still CTs around without
> a counter tuple. Hm.

Yeah, we also discussed that part, but we can't do any better.
The alternative for people is to manually enable it when loading
conntrack.
