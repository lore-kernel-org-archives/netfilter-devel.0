From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_queue: Use hash to speed up finding entries
 in 	nfqueue
Date: Fri, 20 Nov 2009 14:56:32 +0100
Message-ID: <4B06A010.4040506@trash.net>
References: <4B06217F.6060901@gmail.com> <4B0695DB.3010401@trash.net> <412e6f7f0911200546n5d44082dt69fec1514b51c12b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35552 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZKTN4a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:56:30 -0500
In-Reply-To: <412e6f7f0911200546n5d44082dt69fec1514b51c12b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Fri, Nov 20, 2009 at 9:12 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Changli Gao wrote:
>>> Use hash to speed up finding entries in nfqueue.
>>>
>>> If user implements QoS in userland, packet verdict won't be received in order. At this moment, a hash table is faster than a double linked list when finding the corresponding entries in nfqueue.
>>>
>>> This patch also fixes a potential bug, which will allows more than one entries with the same id are in the same nfqueue in the extreme.
>> Instead of a double ID in a purely hypothetical case, we'd now
>> get an endless loop. This part doesn't make much sense to me,
>> please remove it from the patch.
>>
> 
> It isn't a endless loop, as we limite the queue size.

It is if queue_maxlen is set to the maximum. In any case this change
adds a new lookup for ID assignment and complicates the code for a
case which I still consider purely hypothetical. Additionally it is
not related to the hashing change and shouldn't be in the same patch.
