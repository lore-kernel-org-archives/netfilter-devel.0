From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH v2 0/2] ipset: forceadd support
Date: Fri, 28 Feb 2014 08:26:41 -0600
Message-ID: <53109CA1.8070006@akamai.com>
References: <1393542286-20955-1-git-send-email-johunt@akamai.com> <20140228034123.GA12861@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:9846 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbaB1OfB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:35:01 -0500
In-Reply-To: <20140228034123.GA12861@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/27/2014 09:41 PM, Phil Oester wrote:
> On Thu, Feb 27, 2014 at 06:04:44PM -0500, Josh Hunt wrote:
>> Forceadd is a property for hash set types and is passed in duration creation.
>> When sets with this property enabled are full each subsequent 'add' operation
>> will attempt to evict a random entry from the set.
>
> Wouldn't it be better to evict the oldest entry instead of a random one?
>
> Phil

I was trying to introduce no extra overhead with this feature, in 
general and when we are doing adds to the set. I thought about doing 
what you're suggesting, but I would need to add something to track the 
oldest entry which may not be as trivial as it sounds given things like 
timeouts. In addition to that I'd still need to traverse the bucket to 
find this entry to evict. Given those two things I did not go down that 
path.

Thanks for reviewing!
Josh

