From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: extend payload to support writing
 data
Date: Sun, 23 Feb 2014 19:34:11 +0100
Message-ID: <530A3F23.5000201@redhat.com>
References: <1393176742-28171-1-git-send-email-nikolay@redhat.com> <20140223180908.GA10380@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaBWSeU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Feb 2014 13:34:20 -0500
In-Reply-To: <20140223180908.GA10380@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/23/2014 07:09 PM, Patrick McHardy wrote:
> On Sun, Feb 23, 2014 at 06:32:22PM +0100, Nikolay Aleksandrov wrote:
>> This patch extends the payload expression to support packet writing.
>> The new payload attribute - SREG specifies the source register to use
>> when changing packet data, the rest of the attributes are the same:
>> base - where to start from
>> offset - offset in the packet
>> len - length to write
>>
>> The DREG attribute should not be set if writing is intended, if both
>> attributes are set an error will be returned.
>>
>> The checksum update is done automatically for the following cases:
>> IPv4 checksum - changing the IPv4 header
>> TCP checksum - changing addresses in the network header (pseudo) or
>>                changing TCP header/packet data
>> UDP checksum - same as TCP
>> The pseudo header works for both IPv4 and IPv6.
>>
>> The following restrictions apply:
>> - Cross-header writing (NH -> TH) won't get their checksum updated
>>   properly.
>> - The "checksum" fields of the respective headers should not be altered.
>> - If altering an address in the network header, the write should not
>>   alter any other field. (This is okay for IPv4 as the previous field
>>   is the checksum, but changing the IPv6 "hop limit" and the first bytes
>>   of the source address should not be done for example)
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
>> ---
>> This is _strictly_ RFC, I have some cleanups to do and a ton of tests
>> to run :-)
> 
> Thanks for your efforts so far. However regarding checksumming, encoding
> all this protocol knowledge into the kernel is against the concepts we
> have so far and also kind of unncessary, userspace has this knowledge
> anyways. So I'd propose to change the checksumming in the following way:
> 
> - userspace specifies a checksum offset (header base and offset)
> - userspace specifies a checksum type (CSUM_TYPE_INET or something like this)
> - userspace specifies whether the change affects a pseudo header
> - userspace specifies the pseudo offset if required
> 
> The checksum update can then simply be done one or two calls to
> inet_proto_csum_replaceX(). Userspace is responsible for doing updates
> in steps that result in valid checksums (IOW, don't mix updates that
> affect the pseudo header with other updates).
> 
Heh, I've misunderstood you the last time apparently and tried to do it all
automagically or to cover as much as possible cases.
Anyway, given that userspace specifies all of the above as you said it
should be nearly trivial to update the checksum properly.
I'll get to it next week.

Again thanks for the feedback,
 Nik

