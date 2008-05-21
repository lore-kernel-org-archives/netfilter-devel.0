From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 14:00:09 +0200
Message-ID: <48340EC9.3020507@trash.net>
References: <483350D3.50103@netfilter.org> <48340438.5020106@trash.net> <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38837 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761121AbYEUMAK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 08:00:10 -0400
In-Reply-To: <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James Morris wrote:
> On Wed, 21 May 2008, Patrick McHardy wrote:
> 
>> Pablo Neira Ayuso wrote:
>>> As for now we only support dumping. This patch adds support to change
>>> the secmark from ctnetlink.
>>>
>> I'm wondering whether this isn't subverting the intent of
>> secmark since AFAIK SELinux doesn't have finegrained
>> controls for netlink messages. OTOH, it also doesn't have
>> finegrained control over iptables rulesets.
>>
>> James, does this patch look OK to you?
> 
> There is some fine-grained netlink coverage, but it is incomplete (the 
> various generic netlink layers likely need to be consolidated first).
> 
> Currently, the SECMARK and CONNSECMARK targets call out to 
> selinux_secmark_relabel_packet_permission() when SELinux is active to 
> obtain a permission check.  So, detection of the current security model 
> would need to be similarly performed.

Thanks for the explanation.

> The bigger issue perhaps is whether there's really a need to set secmark 
> via ctnetlink.

I think Pablo wants to use it for synchronization with conntrackd,
but I'm not sure.
