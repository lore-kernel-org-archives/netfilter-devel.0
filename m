From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 15:23:25 +0100
Message-ID: <479F36DD.6030000@trash.net>
References: <20080128231323.GA24226@localhost> <479F2C54.8030109@trash.net> <479F3183.6030905@netfilter.org> <479F2EDD.2000000@trash.net> <479F3526.10306@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55921 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761117AbYA2OX2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:23:28 -0500
In-Reply-To: <479F3526.10306@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>
>> I agree with Eric, its a useful option for avoiding overhead in
>> userspace, and what counts in the end is the accumulated overhead
>> of both kernel and userspace. If userspace can avoid dealing with
>> tuples and complicated bookkeeping it can read messages faster,
>> thus avoiding recv-queue overflows.
> 
> Then, dump the id but not the mark if he wants to identify a conntrack.


That probably won't help since the ID is chosen arbitarily, while the
mark allows you to encode information. I don't see the big problem here,
it only increases the message size if marks are actually used.

I'm also sure you could decrease overhead far more by choosing a proper
allocation size without affecting functionality thats apparently useful
for some people.
