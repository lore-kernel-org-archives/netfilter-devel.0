From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH RFC 0/7] users counter to manage ipv4 defragmentation
 on bridge
Date: Wed, 07 May 2014 20:49:56 +0200
Message-ID: <536A8054.90201@pandora.be>
References: <20140503233908.GA6297@localhost> <53678A3E.3060903@parallels.com> <20140505205757.GB32448@breakpoint.cc> <536A34C5.2000909@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Vasily Averin <vvs@parallels.com>, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60857 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaEGSuA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 14:50:00 -0400
In-Reply-To: <536A34C5.2000909@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 7/05/2014 15:27:
> On 05/06/2014 12:57 AM, Florian Westphal wrote:
>> Vasily Averin <vvs@parallels.com> wrote:
>>> For nf_conntrack_ipv4 I increment counter once only,
>>> For TPROXY target and socket match I increment counter on checkentry and
>>> decrement on destroy hook. So if these modules are just loaded but are not
>>> used in net namespace, they will not affect ipv4 defragmentation.
>>> Please let me know if you have some better ideas.
>>
>> bridges defrag packets (if the nf_defrag_ipv4 is loaded) because
>> brnf_call_iptables sysctl is set to 1 by default.
>>
>> What about making this sysctl per-netns?
>
> I think it is great idea,
> I'm agree it's much better than my patch set.

No objections from me.

> However, could anybody explain,
> if nobody likes bridge-netfilters, why according sysctls are enabled in kernel by default?

If nobody likes it, it's quite simple: don't enable bridge-nf when 
configuring the kernel.
Here are the reasons why the defaults are set to 1:
- Backwards compatibility (the sysctl options were added later)
- Default behaviour should be independent of sysctl being enabled or not
- If someone compiles bridge-nf into the kernel, one might expect that 
it's intended to be used.

