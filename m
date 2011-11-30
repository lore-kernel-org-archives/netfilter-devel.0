From: Pete Holland <pholland27@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due
 to helper rejection conditional on LOG_INVALID
Date: Wed, 30 Nov 2011 12:59:05 -0800
Message-ID: <CANtneHK+1s-RdqguBJrqQ5mXzi8GFpHLAp1Dn9m5tNK-2kO8-g@mail.gmail.com>
References: <CANtneH+UUgXdk1UmHKR8JfN=jqsFZ+LFYGQZ_tHF_aZ_zCn3Dw@mail.gmail.com>
	<CANtneHKob5AL=APFnLz0G3JwD97igVOr9eGpQ-mLd8p6XX5MdA@mail.gmail.com>
	<CANtneHJMLjvP_ZwzO8JmS7zn_xuWCoXOQs6jQzY_4V0+=Z+uYg@mail.gmail.com>
	<4ED67C2E.3050309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46068 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1K3U7G convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:59:06 -0500
Received: by bkas6 with SMTP id s6so1392266bka.19
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2011 12:59:05 -0800 (PST)
In-Reply-To: <4ED67C2E.3050309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src.l3num is the protocol number in the ethernet header (ipv4 or ipv6)
so what I actually want is:
ct->tuplehash[IP_CT_ORIGINAL].tuple.dst.protonum
which is the the L4 protocol number

i've built and tested this (by forcing a ret of -NF_ACCEPT) and it
logs (or not) appropriately with the sysctl settings

i'll resubmit the patch with this change

cheers,
Pete

On Wed, Nov 30, 2011 at 10:55 AM, Patrick McHardy <kaber@trash.net> wro=
te:
> On 11/30/2011 07:35 PM, Pete Holland wrote:
>>
>> sorry that should be
>> ct->tuplehash[IP_CT_ORIGINAL].tuple.src.l3num
>
> I'd prefer that to the IPPROTO_RAW usage.
>
>> On Wed, Nov 30, 2011 at 10:33 AM, Pete Holland<pholland27@gmail.com>
>> =A0wrote:
>>>
>>> it occurred to me that I should be able to extract the protocol num=
ber
>>> from the the tuplehash in struct nf_conn. =A0the original
>>> direction tuple should always be there, and I could get it from the=
re.
>>>
>>> so instead of using IPPROTO_RAW, I could use
>>> ct->tuplehash[IP_CT_ORIGINAL].src.l3num
>>>
>>> i'm still pretty new in the netfilter code, so any thoughts are
>>> greatly appreciated
>>>
>>> On Tue, Nov 29, 2011 at 12:08 PM, Pete Holland<pholland27@gmail.com=
>
>>> =A0wrote:
>>>>
>>>> From: Peter Holland<pholland27@gmail.com>
>>>>
>>>> Make the logging of dropped packets due to ct helper rejection
>>>> conditional on LOG_INVALID.
>>>> This is consistent with the other uses of nf_log_packet.
>>>> Use the IPPROTO_RAW filter since it is unclear based on the caller
>>>> what protocol it actually is.
>>>> Without this check, there is a possible DoS based on traffic induc=
ed
>>>> log generation.
>>>> (specifically this was noted in the wild by an attacker against th=
e SIP
>>>> helper)
>>>>
>>>> Signed-off-by: Peter Holland<pholland27@gmail.com>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
