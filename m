From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 15:36:21 +0100
Message-ID: <479F39E5.6090206@trash.net>
References: <20080128231323.GA24226@localhost> <479F2C54.8030109@trash.net> <479F3183.6030905@netfilter.org> <479F2EDD.2000000@trash.net> <479F3526.10306@netfilter.org> <479F36DD.6030000@trash.net> <479F3943.2050900@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56236 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830AbYA2OgY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:36:24 -0500
In-Reply-To: <479F3943.2050900@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>
>> I'm also sure you could decrease overhead far more by choosing a proper
>> allocation size without affecting functionality thats apparently useful
>> for some people.
> 
> Please, elaborate this a bit.


ctnetlink currently allocates skb of NLMSG_GOODSIZE size, which is
4k on most architectures, but the actual messages are far smaller.
When more than 50% of the skb are unused, af_netlink reallocates
the skb, copying the entire data.

