From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] fix "manpages: do not include v4-only modules in ip6tables
 manpage"
Date: Mon, 1 Jun 2009 11:49:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906011127280.7784@fbirervta.pbzchgretzou.qr>
References: <1243788616-375-1-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0905312220210.815@fbirervta.pbzchgretzou.qr> <4A239836.3020400@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZFAJtA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:49:00 -0400
In-Reply-To: <4A239836.3020400@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-06-01 10:58, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Sunday 2009-05-31 18:50, Florian Westphal wrote:
>> 
>>> previous commit tries to skip v4-only module manpages
>>> by searching for NFPROTO_IPV(4|6) -- in the man page itself.
>>>
>>> Searching the .c file instead is not sufficient:
>>> - there is at least one page (libxt_policy) without a libxt_*c
>>> - there are targets/modules which use family AF_UNSPEC.
>> 
>> No, this one misses manpages too... Bah, time to eradicate the ip/ip6/
>> name mess.
>
>Florian is trying to help fixing this broken feature that you
>introduced. Why don't you tell him what pages are missing?

Fair enough. The problem is that we have a libxt_poilcy.man file, but
no libxt_policy.c file. After further looking into this, it becomes
apparent that libip6t_policy.c is quite redundant (since struct
ip6t_policy_info is actually xt_policy_info) and should be
incorporated into libipt_policy.c, to be renamed to libxt_policy.c.
Will be sending a pull soon.
