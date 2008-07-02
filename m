From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Speed up verdict to chain_head mapping by using binary
 search
Date: Wed, 02 Jul 2008 18:00:12 +0200
Message-ID: <486BA60C.6060708@trash.net>
References: <> <1214997482-19063-1-git-send-email-jacob@internet24.de>	 <486B9E84.4070403@trash.net> <1215014004.26474.45.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41543 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYGBQAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:00:14 -0400
In-Reply-To: <1215014004.26474.45.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> On Wed, 2008-07-02 at 17:28 +0200, Patrick McHardy wrote:
>> I can't spot any bugs, so I'm going to apply it so we can get
>> some testing. Some minor coding style issues before I'll apply
>> it though:
>>
>> Thomas Jacob wrote:
>>> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
>>> index d0f51b4..e0c44c3 100644
>>> --- a/libiptc/libiptc.c
>>> +++ b/libiptc/libiptc.c
>>> @@ -126,6 +126,26 @@ struct chain_head
>>>  	unsigned int foot_offset;	/* offset in rule blob */
>>>  };
>>>  
>>> +/* Max. number of chain_head per offsets chunk */
>>> +#define OFFSETS_CHUNK_SIZE (1024)
>>> +
>>> +struct offsets_create_chunk
>> What does "create" stand for?
> 
> Well, originally I wanted to copy those chunks into an array, 
> thus the create tag, so I'll just rename it to offsets_chunk,
> shall I?

Yes, that sounds better.

> 
>>> +{
>>> +	struct list_head list;
>>> +
>>> +	unsigned int head_offset; /* of first entry */
>>> +	unsigned int foot_offset; /* of last entry */
>> first_offset/last_offset perhaps?
> 
> Those are the names used inside chain_head.... admittedly for the length
> of a whole change, but I could change that, no problem

That was just a suggestion triggered by the comments.

>>> +#define binary_array_range_search(value, array, left, right, size, low, high, mid, result) \
>>> +	low = 0; \
>>> +	high = size; \
>>> +	result = -1; \
>>> +	while(low<=high) \
>>> +	{ \
>>> +		mid = (low + high) / 2; \
>>> +		if ((array)[mid]->left > value) \
>>> +			high = mid - 1; \
>>> +		else if ((array)[mid]->right < value) \
>>> +			low = mid + 1; \
>>> +		else { \
>>> +			if ((array)[mid]->left <= value && value <= (array)[mid]->right) \
>>> +				result = mid; \
>>> +			break; \
>>> +		} \
>>> +	}
>> Any chance to make this a bit prettier? Does it need to be a macro?
> 
> No, I just didn't want to write the same code twice.... that's all,
> what do you suggest, doing that (writing the same code twice)?

No, a macro is better than duplicating it. I was just wondering
whether a function would also do.
