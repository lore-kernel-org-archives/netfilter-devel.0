From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ctnetlink: deliver events for conntracks changed from
 userspace
Date: Mon, 06 Apr 2009 16:50:10 +0200
Message-ID: <49DA16A2.9040800@trash.net>
References: <49D9F64E.4050304@trash.net> <49DA1438.6010508@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47811 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDFOuP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:50:15 -0400
In-Reply-To: <49DA1438.6010508@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>>>         nf_ct_expect_insert(expect);
>>> +       atomic_inc(&expect->use);
>> This I don't understand - the caller is holding a reference, why
>> do we need another one?
> 
> I thought that the expectation timer may expire while delivering the
> event, but that cannot happen since we still hold the reference until
> the expectation setup is finished (nf_ct_expect_alloc() gets the
> refcount, later nf_ct_expect_put() puts it).

Yep, that was my understanding as well.

>> The next question would be - why do we need those two functions at
>> all? Aside from the apparently unnecessary reference counting, the
>> only difference is reporting, and that actually uses the exact
>> same code path.
> 
> Is the patch attached on the right track?

It looks fine, thanks. I'll test whether it fixes the problem for
me once I can get the damned -rc to boot. I'll let you know how
it goes.
