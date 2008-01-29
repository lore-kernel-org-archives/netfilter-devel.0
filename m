From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 15:33:39 +0100
Message-ID: <479F3943.2050900@netfilter.org>
References: <20080128231323.GA24226@localhost> <479F2C54.8030109@trash.net> <479F3183.6030905@netfilter.org> <479F2EDD.2000000@trash.net> <479F3526.10306@netfilter.org> <479F36DD.6030000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36612 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754839AbYA2Odt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:33:49 -0500
In-Reply-To: <479F36DD.6030000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>
>>> I agree with Eric, its a useful option for avoiding overhead in
>>> userspace, and what counts in the end is the accumulated overhead
>>> of both kernel and userspace. If userspace can avoid dealing with
>>> tuples and complicated bookkeeping it can read messages faster,
>>> thus avoiding recv-queue overflows.
>>
>> Then, dump the id but not the mark if he wants to identify a conntrack.
> 
> That probably won't help since the ID is chosen arbitarily, while the
> mark allows you to encode information. I don't see the big problem here,
> it only increases the message size if marks are actually used.

Make sense.

> I'm also sure you could decrease overhead far more by choosing a proper
> allocation size without affecting functionality thats apparently useful
> for some people.

Please, elaborate this a bit.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
