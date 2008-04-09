From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue and libnetfilter_conntrack API questions
Date: Wed, 09 Apr 2008 17:02:24 +0200
Message-ID: <47FCDA80.10005@netfilter.org>
References: <47FCCD6C.6050409@gmail.com> <47FCD6AA.8030205@netfilter.org> <47FCD84A.7030400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Thomas Mader <thezema@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39712 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753953AbYDIPCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:02:41 -0400
In-Reply-To: <47FCD84A.7030400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> The events do not include the ID, this is how it goes as for now.
>> Actually I'm not a big fun of the ID.
>>
>> @Patrick: I don't remember exactly the reason why we decided to keep the
>> ID there, and if we have decided to do so, it seems inconsistent to me
>> not to include it in the events.
> 
> 
> I agree. I guess the reason why its not sent on events is that it
> was originally only introduced (IIRC, I might be confusing it with
> the ordered list on second thought) for dumps.
> 
> The reason why we kept it at all is that people are already using
> it as unique identifier, we only changed the uniqueness to mean
> "unique at any given point in time", but not over time. I guess
> the logical thing to do would be to also include it in events.
> I know some people are using patches to do this already.

Well, I'm not big fun of reducing the limited bandwidth of netlink but
let's inserted it. I have a couple of patches here for ctnetlink. I can
include one for this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
