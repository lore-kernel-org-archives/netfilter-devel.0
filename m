From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 13:59:35 +0300
Message-ID: <51C2E097.9090901@linux.intel.com>
References: <1371628997-13548-1-git-send-email-eric@regit.org> <51C17E26.2020608@linux.intel.com> <20130620094243.GA5703@localhost> <51C2D0D8.1020309@linux.intel.com> <20130620101012.GA19679@localhost> <51C2DB10.1060607@linux.intel.com> <20130620104621.GC31140@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab3FTK7j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:59:39 -0400
In-Reply-To: <20130620104621.GC31140@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,
>> >Maybe there is a better way, probably. But you get my point.
> We could instead of using NLA_RULE_HANDLE for the position add a new
> attribute NLA_RULE_POSITION and use that both for creating rules and
> for notifications. It would always be set and contain the handle of
> the rule preceeding the new rule (for NLM_F_APPEND) or the one
> following it (for !NLM_F_APPEND).

I like that, it follows the current API design logic and it's simpler to 
implement in both sides.
It's much simpler indeed!

Tomasz
