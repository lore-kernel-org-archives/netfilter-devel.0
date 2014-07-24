From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash with same name
Date: Thu, 24 Jul 2014 11:53:15 +0100
Message-ID: <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com> <20140724084927.GB18404@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Florian Westphal <fw@strlen.de>, Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45004 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbaGXKxX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:53:23 -0400
In-Reply-To: <20140724084927.GB18404@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24. Juli 2014 09:49:27 GMT+01:00, Florian Westphal <fw@strlen.de> wrote:
>Josh Hunt <johunt@akamai.com> wrote: 
>>     Currently when we do do this the new parameters are not enforced.
>
>Note that:
>
>-A INPUT -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10
>--hashlimit-name test
>-A INPUT -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 10
>--hashlimit-name test
>
>doesn't work as expected either (rule #2 uses config options of #1).
>
>I think is behaviour is so unexpected that I would consider this a
>bug...

True, but it's a bug that has existed forever and I've seen scripts that actually rely on this.

I'm not sure if we can silently change this behaviour.



