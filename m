From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 14:49:17 +0100
Message-ID: <479F2EDD.2000000@trash.net>
References: <20080128231323.GA24226@localhost> <479F2C54.8030109@trash.net> <479F3183.6030905@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55472 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763285AbYA2OFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:05:19 -0500
In-Reply-To: <479F3183.6030905@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Eric Leblond wrote:
>>> The following feature was submitted some months ago. It forces the dump
>>> of mark during the connection destruction event. The induced load is
>>> quiet small and the patch is usefull to provide an easy way to filter
>>> event on user side without having to keep an hash in userspace.
>>>
>>> This new version is against 2.6.24 git tree.
>> It clashed with some changes I had queued locally, but I fixed it
>> up and applied it. Thanks Eric.
> 
> Please, hold it on. I don't see the point of consuming 8 extra byte in
> every extra destroy message. You have tons of resources in userspace to
> implement whatever performance structure to store the conntrackd but we
> do have limited bandwidth in netlink. Instead we may dump the id but I
> don't support this option either.

I agree with Eric, its a useful option for avoiding overhead in
userspace, and what counts in the end is the accumulated overhead
of both kernel and userspace. If userspace can avoid dealing with
tuples and complicated bookkeeping it can read messages faster,
thus avoiding recv-queue overflows.
