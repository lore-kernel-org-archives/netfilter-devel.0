From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: remove dependency on libiptc headers
Date: Wed, 06 Aug 2008 11:50:07 +0200
Message-ID: <489973CF.20101@trash.net>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr> <489444E1.8060303@netfilter.org> <48944A98.8050202@netfilter.org> <alpine.LNX.1.10.0808021220320.12119@fbirervta.pbzchgretzou.qr> <489713B7.10909@netfilter.org> <alpine.LNX.1.10.0808041943350.29809@fbirervta.pbzchgretzou.qr> <4897FA2C.30705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43972 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYHFJuL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:50:11 -0400
In-Reply-To: <4897FA2C.30705@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> On Monday 2008-08-04 10:35, Pablo Neira Ayuso wrote:
>>>> The API actually remains the same, due to the nature of char[]
>>>> decaying into char* (and .name is also only used in the registrator);
>>>> the ABI (indicated by XTABLES_VERSION) changes yes, and that is fine
>>>> because we moved from 1.4.1 to 1.4.2-rc1.
>>> Sure, but say that someone uses whatever iproute2 version <=
>>> iproute2-2.6.26 - which does not check for any ABI version numbering
>>> AFAICS - and then it compiles whatever >= 1.4.2-rc1 by hand, then
>>> jamal's ipt thing will not work as they use different ABIs.
>>>
>>> I'm not talking on how to solve future interdependecy problems - which
>>> you seems to have it done by exporting xtables as library - but the
>>> problems that the size change of .name will trigger for some time.
>> If the ABI changes, the libxtables.so ABI version number just get
>> bumped, that is what they are there for.
> 
> Great. You're breaking previous backward compatibility with old iproute2
> versions since they are not checking that number.

Jumping in late, but I already applied that patch. The iproute
compabibility is already broken regulary because the "interface"
is a huge hack and it duplicates all kinds of internal functions.
So this doesn't really make things worse. I don't think its
reasonable to not change internal functions/structs because
something external is dlopening and fiddling in iptables internals.
Once iproute makes use of libxtables I'm willing to be more
careful about this.
