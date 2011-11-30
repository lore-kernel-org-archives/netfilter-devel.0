From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet
 due to helper rejection conditional on LOG_INVALID
Date: Wed, 30 Nov 2011 19:55:42 +0100
Message-ID: <4ED67C2E.3050309@trash.net>
References: <CANtneH+UUgXdk1UmHKR8JfN=jqsFZ+LFYGQZ_tHF_aZ_zCn3Dw@mail.gmail.com>	<CANtneHKob5AL=APFnLz0G3JwD97igVOr9eGpQ-mLd8p6XX5MdA@mail.gmail.com> <CANtneHJMLjvP_ZwzO8JmS7zn_xuWCoXOQs6jQzY_4V0+=Z+uYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pete Holland <pholland27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56207 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1K3Szn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:55:43 -0500
In-Reply-To: <CANtneHJMLjvP_ZwzO8JmS7zn_xuWCoXOQs6jQzY_4V0+=Z+uYg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/30/2011 07:35 PM, Pete Holland wrote:
> sorry that should be
> ct->tuplehash[IP_CT_ORIGINAL].tuple.src.l3num

I'd prefer that to the IPPROTO_RAW usage.

> On Wed, Nov 30, 2011 at 10:33 AM, Pete Holland<pholland27@gmail.com>  wrote:
>> it occurred to me that I should be able to extract the protocol number
>> from the the tuplehash in struct nf_conn.  the original
>> direction tuple should always be there, and I could get it from there.
>>
>> so instead of using IPPROTO_RAW, I could use
>> ct->tuplehash[IP_CT_ORIGINAL].src.l3num
>>
>> i'm still pretty new in the netfilter code, so any thoughts are
>> greatly appreciated
>>
>> On Tue, Nov 29, 2011 at 12:08 PM, Pete Holland<pholland27@gmail.com>  wrote:
>>> From: Peter Holland<pholland27@gmail.com>
>>>
>>> Make the logging of dropped packets due to ct helper rejection
>>> conditional on LOG_INVALID.
>>> This is consistent with the other uses of nf_log_packet.
>>> Use the IPPROTO_RAW filter since it is unclear based on the caller
>>> what protocol it actually is.
>>> Without this check, there is a possible DoS based on traffic induced
>>> log generation.
>>> (specifically this was noted in the wild by an attacker against the SIP helper)
>>>
>>> Signed-off-by: Peter Holland<pholland27@gmail.com>

