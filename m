From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Wed, 15 Dec 2010 14:54:26 +0100
Message-ID: <4D08C892.3080704@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0LONyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:54:35 -0500
In-Reply-To: <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14/12/10 03:01, Jan Engelhardt wrote:
> 
> On Thursday 2010-12-09 13:08, Pablo Neira Ayuso wrote:
>>
>> If we follow the one message per rule basis, you can put several
>> messages into one batch with different sequence numbers. Thus, you can
>> know what message in the batch has triggered the error and the reason.
> 
> /* The unwritten laws of netlink */
>
> Normally, the sequence number of a response message is simply
> the one from the request message. But in a dump where there
> can be multiple messages, do they all share the sequence number?

Yes, because they are the result of one request. Responses use the
sequence number of the original request. Thus, you can identify what
messages come as part of what requests.

> Must the response sequence numbers match at all, or is it like TCP
> where each side has its own set?

They have to match.

> BTW, can response messages - all those leading up to NLMSG_DONE -
> have different nlmsg_type, or not?

They all have the same type.

> Does the nlmsg_type need to match the request type?

No.
