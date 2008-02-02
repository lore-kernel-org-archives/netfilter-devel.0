From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch 1/1] Add subsystem accessors
Date: Sat, 02 Feb 2008 22:16:21 +0100
Message-ID: <47A4DDA5.40609@netfilter.org>
References: <20080130182128.826992459@kruemel.intranet.astaro.de> <20080130182454.607358723@kruemel.intranet.astaro.de> <47A34FD8.2080806@netfilter.org> <47A3534A.90006@astaro.com> <47A4DB73.7070404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43191 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756022AbYBBVQj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:16:39 -0500
In-Reply-To: <47A4DB73.7070404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Holger Eitzenberger wrote:
>> Pablo Neira Ayuso wrote:
>>
>>>> Need by newer ulogd v2.
>>> Why do you need this? If I apply this, I'll have to provide support for
>>> people mixing calls to libnfnetlink and libnetfilter_conntrack which can
>>> be a problematic. The subsys handles are encapsulated for that reason.
>>>
>>> If you really need them, I suggest you to use libnfnetlink together with
>>> the low level functions libnetfilter_conntrack functions:
>>> nfct_[build|parse]_conntrack and nfct_build_query.
>> Which would nullify the use of libnetfilter-conntrack with ulogd.
> 
> No way. You're abusing the library APIs. The proper way for what you
> want to do is the following:
> 
> 1) open a nfnl handle
> 2) open a nfnl_subsys_handle
> 3) register the callback
> 4) use nfct_parse_conntrack inside the callback to get the conntrack
> object while you can still access netlink details (such as the sequence
> number).
> 5) use nfct_build_query plus nfnl_query if you want to send request to
> ctnetlink.

I have found an example of this for you in old conntrack-tools release
such as 0.9.3. See netlink.c file. I needed something similar at that
time. Recent releases and current SVN only use libnetfilter_conntrack.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
