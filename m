From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix "manpages: do not include v4-only modules in ip6tables
 manpage"
Date: Mon, 01 Jun 2009 10:58:30 +0200
Message-ID: <4A239836.3020400@netfilter.org>
References: <1243788616-375-1-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0905312220210.815@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56648 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZFAI6i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:58:38 -0400
In-Reply-To: <alpine.LSU.2.00.0905312220210.815@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2009-05-31 18:50, Florian Westphal wrote:
> 
>> previous commit tries to skip v4-only module manpages
>> by searching for NFPROTO_IPV(4|6) -- in the man page itself.
>>
>> Searching the .c file instead is not sufficient:
>> - there is at least one page (libxt_policy) without a libxt_*c
>> - there are targets/modules which use family AF_UNSPEC.
> 
> No, this one misses manpages too... Bah, time to eradicate the ip/ip6/
> name mess.

Florian is trying to help fixing this broken feature that you
introduced. Why don't you tell him what pages are missing?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
