From: marty <martinbarrowcliff@gmail.com>
Subject: Re: Ulogd - mysql addresses are in network-byte order
Date: Mon, 02 Jan 2012 15:02:21 -0500
Message-ID: <4F020D4D.5060102@gmail.com>
References: <4F013AB2.8030004@gmail.com> <20120102180811.GA26533@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:46151 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2ABUCZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jan 2012 15:02:25 -0500
Received: by qadb15 with SMTP id b15so10517694qad.19
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jan 2012 12:02:24 -0800 (PST)
In-Reply-To: <20120102180811.GA26533@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/02/2012 01:08 PM, Pablo Neira Ayuso wrote:
> On Mon, Jan 02, 2012 at 12:03:46AM -0500, marty wrote:
>>
>> Here, for your review is a patch to
>> address the issue that I reported.
>>
>> --- orig.ulogd_raw2packet_BASE.c	2011-12-08 11:55:09.000000000 -0500
>> +++ ulogd_raw2packet_BASE.c	2012-01-01 23:40:14.000000000 -0500
>> @@ -717,8 +717,8 @@
>>   		return ULOGD_IRET_OK;
>>   	len -= iph->ihl * 4;
>>
>> -	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
>> -	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
>> +	okey_set_u32(&ret[KEY_IP_SADDR], ntohl(iph->saddr));
>> +	okey_set_u32(&ret[KEY_IP_DADDR], ntohl(iph->daddr));
>>   	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
>>   	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
>>   	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);
>
> Many other plugins rely on the address in network byte order.
>
> Can you fix this in the mysql plugin by adding some configurable
> option?

Seems like I already offered config options previously, no...
And as I recall I gave fair warning, which you ignored.
Simply put the host arch should determine IP format. That is a given.
That is easily changed to network format where/when required.

Personally I would write the BASE code as I have,
and let the option for network byte order be available
as a config option, as I suggested from the start.

The mysql-plugin does not have the keys available directly.
It pretty much passes data blindly.
I am hesitant to change this because it works nice.

> more suggestions for your next patches, please:
>
> * include short description before the patch.
> * they have to apply with patch -p1<  file.patch

Agreed, I should submit patches with more info.

> you can generate this with git diff HEAD (there are more advanced ways
> to do this in git though)

Yes, I can do lots of things; even stand on my head.
But I fixed the issue as requested and if that is not sufficient I am 
terribly sorry, but I am a 60+ yr old man with a big schedule.
The code works fine for my purposes and you are not inspiring me.

Marty B.
