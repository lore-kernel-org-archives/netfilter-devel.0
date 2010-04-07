From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
 	lookup by id
Date: Wed, 07 Apr 2010 16:41:36 +0200
Message-ID: <4BBC99A0.1010408@trash.net>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net> 	<y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com> 	<4BBC8B44.30208@trash.net> <m2k412e6f7f1004070707sd456c5d1v567f9dca021397a2@mail.gmail.com> 	<4BBC93CA.4000207@trash.net> <y2u412e6f7f1004070733i3635487bh81cfac3e6a64474f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48758 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab0DGOmC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:42:02 -0400
In-Reply-To: <y2u412e6f7f1004070733i3635487bh81cfac3e6a64474f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Wed, Apr 7, 2010 at 10:16 PM, Patrick McHardy <kaber@trash.net> wrote:
>> You only know that during runtime, so this will get more complicated
>> than necessary. Why not simply use a hash table with a size specified
>> by userspace in the queue creation command?  The default behaviour
>> would be a size of 1, which is equivalent to the currently used single
>> list.
>>
> 
> We'd better not expose too many internal implementation details to
> userspace. If we do so, we can't change its implementation easily
> later. And letting user choose the size of hash table is much like the
> orginal epoll(2) design, there will be security consern, such as too
> much memory usage.

Userspace queueing is limited to root, so there's no concern about
memory usage. Regarding implementation details: alternatively add
a flag to specify out of order handling and size the hash table
based on the maximum number of queue entries.
