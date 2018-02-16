From: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Subject: Re: [PATCH] inet: don't call skb_orphan if tproxy happens in layer 2
Date: Fri, 16 Feb 2018 16:44:49 +0100
Message-ID: <5b07e84e-6c26-d3a8-05b8-fcb0428325ad@tessares.net>
References: <1518715545-2188-1-git-send-email-gregory.vanderschueren@tessares.net>
 <20180216110706.GM2810@breakpoint.cc>
 <20180216112845.vkqam67eq4cmeu3q@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: netfilter-devel@vger.kernel.org, gregory.detal@tessares.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36300 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756570AbeBPPow (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 10:44:52 -0500
Received: by mail-wm0-f44.google.com with SMTP id f3so3898820wmc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 07:44:51 -0800 (PST)
In-Reply-To: <20180216112845.vkqam67eq4cmeu3q@salvia>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian & Pablo,

Thank your very much for your quick feedback.

On 02/16/2018 12:28 PM, Pablo Neira Ayuso wrote:
> On Fri, Feb 16, 2018 at 12:07:06PM +0100, Florian Westphal wrote:
>> Gregory Vander Schueren <gregory.vanderschueren@tessares.net> wrote:
>>
>> [ cc netdev ]
>>
>>> If sysctl bridge-nf-call-iptables is enabled, iptables chains are already
>>> traversed from the bridging code. In such case, tproxy already happened when
>>> reaching ip_rcv. Thus no need to call skb_orphan as this would actually undo
>>> tproxy.
>>
>> I don't like this because it adds yet another test in fastpath, and for
>> a use case that has apparently never worked before.

Agreed. I also thought this was not ideal but I did find another way to 
easily fix this.

>>> We noticed issues when using tproxy with net.bridge.bridge-nf-call-iptables
>>> enabled. In such case, ip_rcv() basically undo tproxy's job. The following
>>> patch proposes a fix.
>>
>> I question wheter its a good idea to mix tproxy with bridges.
>>
>> Tproxy relies on policy routing, but a bridge doesn't route :-)
>>
>> I guess you use bridge snat mac mangling to force local delivery of
>> packets that are otherwise bridged?

Indeed, we use DNAT MAC mangling.

>> If yes, can you use ebtables brouting instead?
>> This would bypass the bridge (so no iptables invocation from bridge
>> prerouting anymore).

We were actually pondering over the usage of MAC DNAT vs brouting. I'll 
thus follow your suggestion and use brouting instead then.

>> We will try to get rid of nf-call-iptables eventually.

Good to know!

>> There might be (more complicated) ways to avoid this problem without
>> adding code in normal network path, but lets check other options first.
> 
> Agreed.
> 
> If there's a fix for this, that should be away from the fast path, not
> in ip_rcv().
> 

-- 

------------------------------
DISCLAIMER.
This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. 
If you have received this email in error please notify the system manager. 
This message contains confidential information and is intended only for the 
individual named. If you are not the named addressee you should not 
disseminate, distribute or copy this e-mail. Please notify the sender 
immediately by e-mail if you have received this e-mail by mistake and 
delete this e-mail from your system. If you are not the intended recipient 
you are notified that disclosing, copying, distributing or taking any 
action in reliance on the contents of this information is strictly 
prohibited.
