From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Wed, 21 Apr 2010 14:35:12 +0200
Message-ID: <4BCEF100.10006@trash.net>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com> 	<4BCDC0F4.5070904@trash.net> <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39828 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0DUMfP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:35:15 -0400
In-Reply-To: <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Tue, Apr 20, 2010 at 10:57 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Changli Gao wrote:
>>> use hash table to speed up entry lookup
>>>
>>> A hash table is used to speed up entry lookup when the verdicts aren't received
>>> in order. The size of hash table can be specified by NFQA_CFG_QUEUE_HTBLSIZ.
>>> Its default value is 1. Reciprocal division is used to lower the cost of
>>> division, and the entry IDs are generated carefully to get fair entry
>>> distribution in the buckets of the hash table.
>>> +static u32 __get_uniq_id(struct nfqnl_instance *queue)
>>> +{
>>> +     u32 i;
>>> +
>>> +     for (i = 0; i < INT_MAX; i++) {
>>> +             queue->id_sequence += queue->id_increment;
>>> +             if (queue->id_sequence >= queue->id_limit) {
>>> +                     if (++queue->id_offset >= queue->id_increment)
>>> +                             queue->id_offset = 0;
>>> +                     queue->id_sequence = queue->id_offset;
>>> +             }
>>> +             if (__find_entry(queue, queue->id_sequence) == NULL)
>>> +                     return queue->id_sequence;
>> No freaking way. So you want to lower the overhead for your case
>> any everyone else has to pay the price? This means that every
>> existing user will now have to walk the entire queue of queued
>> packets for every new packet.
> 
> Oh, it is really a bad news for the current users. But how to avoid
> duplicate IDs? Since we use list(hash table with 1 buckets), we must
> afford this cost, although it is rare there are duplicate IDs in one
> queue. How about enlarging the default size of the hash table, and
> change its size with the max size of queue?

All existing users I know of process packets in order, so there's
no need to worry about duplicate IDs.

Does it really matter in your case? I mean, how long do you intend
to keep packets in userspace? Even with 10 Mpps (which you're *very*
unlikely to reach with userspace queueing) it still won't wrap
around for ~430s.

>> How about you start with something simple and try to optimize
>> later in case there are actually performance problems? That
>> probably means use a simple modulo operation for cases where
>> the hash table size is > 1.
>>
> 
> I also think there are too much tricks in my code above, but Eric
> concerns the performance of modulo.

Alternatively we could round the hash size to the next power of
two to avoid this.
