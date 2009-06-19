From: Sachin Sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Fri, 19 Jun 2009 11:46:54 +0530
Message-ID: <17923cc80906182316s6b3d794g3d61394877a28264@mail.gmail.com>
References: <alpine.LSU.2.00.0906160838410.25132@fbirervta.pbzchgretzou.qr>
	 <4A3A6C57.6080403@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Peter Volkov <pva@gentoo.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39683 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZFSGQw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:16:52 -0400
Received: by gxk10 with SMTP id 10so2561296gxk.13
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2009 23:16:54 -0700 (PDT)
In-Reply-To: <4A3A6C57.6080403@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ebtables code looks to be inspired by the iptables code. In case
of iptables the IPT_MIN_ALIGN is defined as

#define IPT_MIN_ALIGN (__alignof__(struct ipt_entry))

and in case of ebtables the EBT_MIN_ALIGN is defined as

#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))

So if ebtables fail, iptables should also fail for the same case. But
the differece here clear from the comment in the iptables code

/* ipt_entry has pointers and u_int64_t's in it, so if you align to
   it, you'll also align to any crazy matches and targets someone
   might write */

That might not be the case with ebtables, struct ebt_entry_target.


cheers,
-Sachin Sanap

On Thu, Jun 18, 2009 at 10:03 PM, Bart De Schuymer<bdschuym@pandora.be>=
 wrote:
> Jan Engelhardt schreef:
>>
>> Patrick McHardy wrote on  2009-06-02 12:20:45:
>>
>>>
>>> Jan Engelhardt wrote:
>>>
>>>>
>>>> Since the kernel uses xt_align already, it's best for userspace to=
 do
>>>> the same.
>>>>
>>>
>>> But that doesn't work for older kernels. Please don't dismiss
>>> compatibility issues that easily. Sometimes things unfortunately
>>> do slip through, but I expect people to do their best to fix the
>>> problem properly when this happens.
>>>
>>
>> I compiled myself an ARM crosscompiler, just to see what's going on.=
 Not
>> that I could run the binaries, but I could at least look at the objd=
ump
>> output. The first impression was: "the state before the supposed reg=
ression
>> was introduced could not have worked on ARM in the first place had I=
 run
>> this".
>>
>> It turns out that ebtables is completely unusable on at least three =
arches
>> with given ABI configurations even if things were still calculated a=
gainst
>> ebt_replace instead of _xt_align. One case has been verified by me s=
ince
>> it's consumer hardware, and it surprises me the Debian project has n=
ot found
>> this earlier, because they actually produced one affected binary
>> distribution in the past (x86 with k64_u32).
>>
>> Affected arches are all with k64_u32. (Perhaps almost all =97 I did =
not
>> recall seeing it on sparc64, and, as I am just checking up on ebtabl=
es's
>> Makefile, it has a hack for sparc.) The other configuration I see pr=
oblems
>> in is a (rather normal) k32_u32 ARM setup with a kernel compiled wit=
h
>> CONFIG_EABI=3Dno.
>>
>> The userspace patch proposed by Sachin Nasap is, IMHO, one to fix th=
e
>> alignment problems (both old and recent) in one clap.
>>
>
> Thanks, I'll have a look at it this weekend.
>
> cheers,
> Bart
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
