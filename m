From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: socket lookup function refactoring,
 cgroup match fixes
Date: Wed, 17 Jun 2015 11:06:02 +0200
Message-ID: <5581387A.2060709@zonque.org>
References: <1434499692-9832-1-git-send-email-daniel@zonque.org> <20150617010332.GA5083@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:43661 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbbFQJGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 05:06:05 -0400
In-Reply-To: <20150617010332.GA5083@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thanks a lot for the feedback!

On 06/17/2015 03:03 AM, Pablo Neira Ayuso wrote:
> On Wed, Jun 17, 2015 at 02:08:09AM +0200, Daniel Mack wrote:
>> This series is based on work done by Daniel Borkmann a little while ago:
>>
>>   http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/56877
>>
>> I addressed the feedback from that thread and factored out the socket
>> lookup code into own modules, one for ipv4, one for ipv6. These modules
>> are now selected in kbuild by code that uses it.
>>
>> Also, a patch was added to fix nft_meta cgroup match rules in a similar
>> fashion as it's now done for xt_cgroup.
> 
> Then, you probably missed these:
> 
> http://permalink.gmane.org/gmane.comp.security.firewalls.netfilter.devel/56879
> 
> That means that we will not take any rework of the existing socket
> infrastructure in netfilter/iptables. The socket match was designed
> for TPROXY, not for firewalling as it will only work under very
> specific assumptions.

Yeah, right. The thing is that cgroup matching is an incredible useful
feature. It's a pity it isn't currently usable for ingress packets.

> The possible ideas that we (Patrick and me) have discussed boil down to:
> 
> 1) Placing the INPUT hook at later stage, from the layer 4 protocols.

That would be great, but the consequences for other matching functions
are beyond my current knowledge of the netfilter code.

> or
> 
> 2) Add a new socket hook in the path from layer 4 protocols.
> 
> In both cases, the idea is that we're always 100% sure that we have a
> valid sk in place, including UDP multicast.

That sounds reasonable too. That option would at least work for nft
then, right? Is anyone working on that yet?


Thanks,
Daniel


