From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Fri, 27 Mar 2015 13:02:42 +0100
Message-ID: <551546E2.4020304@iogearbox.net>
References: <cover.1427394874.git.daniel@iogearbox.net> <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net> <20150327001408.GD3545@salvia> <20150327021014.GA3142@salvia> <55152783.4000607@iogearbox.net> <20150327104711.GA3313@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41828 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbC0MCy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 08:02:54 -0400
In-Reply-To: <20150327104711.GA3313@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/27/2015 11:47 AM, Pablo Neira Ayuso wrote:
> On Fri, Mar 27, 2015 at 10:48:51AM +0100, Daniel Borkmann wrote:
>> On 03/27/2015 03:10 AM, Pablo Neira Ayuso wrote:
>>>
>>> What started a simple cgroup match extension is turning into a more
>>> complicated thing. And you want to do firewalling with this, which
>>> doesn't work for other socket families than TCP and UDP.
>>
>> Right, so for me it started out as a simple outgoing match extension
>> for skb->sk and this should be protocol agnostic, for example, SCTP
>> sets the skb owner in its output path, so the cgroup id would work
>> there, too. (That should be the case for every protocol that's doing
>> proper socket accounting.)
>>
>> People have since then seen a use case for accounting, so support
>> was added for local-in (which we try to fix), where it's being used
>> in Tizen OS apparently, but the idea for realizing a per-application,
>> per-container, ... firewall for both filtering and accounting sounds
>> appealing to me.
>
> Yes, but the more I look into this the more I'm convinced that the nf
> socket infrastructure was not designed for generic socket-based
> firewalling.
>
> This is basically there for TPROXY and very simple socket filtering
> scenarios. This really needs more thinking.

Okay, I understand, if we can come up with a better, more generic solution
to this use-case, I'm all for it.

>> So, I'd like to get this right for iptables and am also eager to help
>> out fixing this in nft.
>
> I'm just going to send two-liner patch for nft to get this working at
> least in the limited supported scenarios that we already have.

Okay.

Thanks again,
Daniel
