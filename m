From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 14:35:54 +0100
Message-ID: <52FF6D3A.6020202@redhat.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com> <61379b1e-8f7e-4596-badb-fd41e1657f83@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaBONg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:36:29 -0500
In-Reply-To: <61379b1e-8f7e-4596-badb-fd41e1657f83@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/15/2014 02:30 PM, Patrick McHardy wrote:
> On 15. Februar 2014 13:17:22 GMT+00:00, Nikolay Aleksandrov <nikolay@redhat.com> wrote:
>> The new "write" expression can be used to manipulate packet data.
>> The parameters that it has are source register (source for the bytes
>> which are to be written), offset in the packet and length to write.
>> It uses a select_ops method to choose between fast ops in the cases
>> length is 1,2 or 4 bytes and slow ops (i.e. using memcpy) in other
>> cases.
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
>> ---
>> I needed a way (other than passing the packets to user-space) to alter
>> the ToS field via nftables, so I decided to make it a bit more general.
>> I
>> use it with the immediate expression to load the new ToS and then write
>> it.
>> If you find this useful I can post the libnftnl patch as well.
>> Right now as you can see it continues even if the "write" wasn't
>> successful
>> which should be probably changed to NFT_BREAK for that case.
> 
> Yes.
> 
>> This patch applies to Dave's net-next tree.
> 
> I think this is a useful addition. However I prefer to put thus into the payload expression and select the proper ops based on the presence of sreg/dreg.
> 
Okay, makes sense. I'll re-write it in such form taking into consideration
the other comments and will re-post after some testing.

Thank you for the feedback,
 Nik

