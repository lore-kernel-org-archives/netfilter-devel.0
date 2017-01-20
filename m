From: Victor Julien <lists@inliniac.net>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: make more information
 available in DESTROY events
Date: Fri, 20 Jan 2017 08:51:41 +0100
Message-ID: <68f82f44-046f-ea8d-efbd-3d566fe3f90b@inliniac.net>
References: <1484751272-5489-1-git-send-email-fw@strlen.de>
 <20170118150118.GA23289@salvia> <20170118150745.GG12001@breakpoint.cc>
 <20170118160335.GB29902@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Jarno Rajahalme <jarno@ovn.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:54802 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdATHvs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 02:51:48 -0500
In-Reply-To: <20170118160335.GB29902@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18-01-17 17:03, Pablo Neira Ayuso wrote:
> On Wed, Jan 18, 2017 at 04:07:45PM +0100, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> On Wed, Jan 18, 2017 at 03:54:32PM +0100, Florian Westphal wrote:
>>>> destroy events currently don't contain the tcp state info and no
>>>> secmark and conntrack labels.
>>>>
>>>> Quoting Victor:
>>>>  "I was hoping to get the last TCP state in a conntrack destroy event,
>>>>   however it seems to be unavailable."
>>>>
>>>> Quoting Jarno:
>>>>  "I have a use case where we want to log terminating connections, but
>>>>  only if a specific label bit is set."
>>>>
>>>> While at it, also include SECMARK in destroy events if one is available.
>>>
>>> I'm fine with this.
>>>
>>> But to remember the original problem is that netlink bandwidth is
>>> limited, so the more we load the netlink message, the more chances we
>>> have to hit ENOBUFS.
>>>
>>> connlabel is optional, so you only get it if needed.
>>
>> Yes, and only if there was a label change or at least one label bit is
>> set.
>>
>>> But the protoinfo thing, I would prefer we just dump the state given
>>> this the usecase we have now.
>>>
>>> Probably extend ->to_nlattr() to have a bool that indicates if this is
>>> a dump?
>>
>> Could do that by it only avoids 4 attributes (so we only save 32bytes
>> per message).
> 
> IIRC, the destroy message is rather small. Moreover, think of
> thousands of messages in that queue, that makes a difference. And I
> cannot think of anything useful people can do with window scale and
> flags at that stage, right?

If with flags you mean tracking the tcp flags seen (SYN, RST, etc), then
I think that could be useful. Netflow logging often logs that. I was
planning to use that when/if it's available.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

