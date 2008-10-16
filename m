From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Thu, 16 Oct 2008 13:56:24 +0200
Message-ID: <48F72BE8.80602@netfilter.org>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45041 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755654AbYJPL4a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:56:30 -0400
In-Reply-To: <48F72B07.1040706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Wednesday 2008-10-15 21:54, Pablo Neira Ayuso wrote:
>>
>>>> Perhaps the following helps?
>>> Yes, your patch will also work, but it introduces an inconsistency in
>>> the naming used to register hooks in the family field.
>>
>> No, not really. Netfilter Hooks are supposed to register with
>>     .pf = NFPROTO_FOO
>> instead of
>>     .pf = PF_FOO
>> because the nf_hooks list itself is indexed by nfproto numbers,
>> not PF numbers:
>>
>> struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly;
>> (The fact that there's still PF_ in the source is merely historical,
>> and as you see, PF_foo == NFPROTO_foo for that exact reason.)
> 
> I agree with Jan on this one, there doesn't seem to be a reason for
> not using the NFPROTO constants consistently.

OK, then I think that it would make sense a minor cleanup for all the
NF_HOOK to use NFPROTO_*? We can do this later.

BTW, why are we using NFPROTO_ARP to 3? Just a convention I guess.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
