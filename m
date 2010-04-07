From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
 	lookup by id
Date: Wed, 07 Apr 2010 15:40:20 +0200
Message-ID: <4BBC8B44.30208@trash.net>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net> <y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47706 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab0DGNkX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:40:23 -0400
In-Reply-To: <y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Wed, Apr 7, 2010 at 7:48 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Changli Gao wrote:
>>
>> I'm interested in how this affects performance for the vast majority
>> of users, which process messages in order. A simple hash table looks
>> like a better choice here since we know the maximum number of entries
>> in advance and also could have the user specify the desired hash size.
>>
> 
> If there aren't much packets queued, the packet ids will be around 0,
> and idr isn't much slower.

Processing packets in order doesn't necessarily mean that there aren't
many packets queued. Its just that the current scheme is pretty much
optimal for this case since the verdict will always refer to the first
entry in the list.

>> You probably shouldn't be making the entry visible before the message
>> is successfully built and sent.
> 
> I wanted to keep the changeset small. But it seems wrong.
> 

