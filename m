From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Fri, 19 Jun 2009 10:10:21 +0530
Message-ID: <17923cc80906182140l5ccd37a9s7e09ab0c180e88b5@mail.gmail.com>
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
Received: from yw-out-2324.google.com ([74.125.46.31]:21000 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZFSEkT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 00:40:19 -0400
Received: by yw-out-2324.google.com with SMTP id 5so865025ywb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2009 21:40:21 -0700 (PDT)
In-Reply-To: <4A3A6C57.6080403@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have checked it with older and new kernel. The patch to userspace
(ebtables) works fine for me on ARM32. If anyone wants me to do some
more specific testing for the patch let me know.

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
