From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH]: Fix ipt_REJECT problem with nf_bridge
Date: Tue, 10 Mar 2009 15:43:34 +1000
Message-ID: <49B5FE06.1010204@snapgear.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com> <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:50438 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777AbZCJFmm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:42:42 -0400
In-Reply-To: <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nir Tzachar wrote:
>> The problem arises from the following code
>> (net/ipv4/netfilter/ipt_REJECT.c line 221:)
>>
>>        if (hook != NF_INET_FORWARD
>> #ifdef CONFIG_BRIDGE_NETFILTER
>>            || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
>> #endif
>>           )
>>                addr_type = RTN_LOCAL;
>>
>> but, as nskb was newly allocated just a few line back, the
>> oldskb->nf_bridge was never copied, so nskb->nf_bridge is always NULL.

Is there a reason you need to copy it into nskb, rather
than just changing the test to check oldskb?

I don't think ipv4 netfilter should be setting this field
for new packets.  The bridging code will do that if needed
when it receives the packet.

