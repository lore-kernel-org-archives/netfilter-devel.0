From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH RFC 0/7] users counter to manage ipv4 defragmentation
 on bridge
Date: Wed, 07 May 2014 17:27:33 +0400
Message-ID: <536A34C5.2000909@parallels.com>
References: <20140503233908.GA6297@localhost> <53678A3E.3060903@parallels.com> <20140505205757.GB32448@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:10665 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbaEGN3m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 09:29:42 -0400
In-Reply-To: <20140505205757.GB32448@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/06/2014 12:57 AM, Florian Westphal wrote:
> Vasily Averin <vvs@parallels.com> wrote:
>> For nf_conntrack_ipv4 I increment counter once only,
>> For TPROXY target and socket match I increment counter on checkentry and
>> decrement on destroy hook. So if these modules are just loaded but are not
>> used in net namespace, they will not affect ipv4 defragmentation.
>> Please let me know if you have some better ideas.
> 
> bridges defrag packets (if the nf_defrag_ipv4 is loaded) because
> brnf_call_iptables sysctl is set to 1 by default.
> 
> What about making this sysctl per-netns?

I think it is great idea,
I'm agree it's much better than my patch set.

However, could anybody explain,
if nobody likes bridge-netfilters, why according sysctls are enabled in kernel by default?
I've found in RHEL6 tries to disable them via /etc/sysctl.conf
however it doesn't work when bridge module is loaded after applying settings saved in sysctl.conf

Thank you,
	Vasily Averin
