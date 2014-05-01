From: Sharat Masetty <sharat04@gmail.com>
Subject: Re: ebtables issue in compat mode
Date: Thu, 1 May 2014 15:50:09 -0600
Message-ID: <CAJzFV35Sj=7X3ntYJ=oecd1Rt0UDaFCnULVZ4_4YyGP2eXt_Ow@mail.gmail.com>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
	<20140501100229.GS31953@breakpoint.cc>
	<CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, abhinov.k.s@live.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65049 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaEAVuK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 May 2014 17:50:10 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so1451190wib.10
        for <netfilter-devel@vger.kernel.org>; Thu, 01 May 2014 14:50:09 -0700 (PDT)
In-Reply-To: <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just a quick update, We are actually using kernel sanitized headers
for compilation, and we still see the same issue

Here is where it is failing exactly, in check_chainloops() function in
ebtables.c in the kernel

if (e->target_offset + sizeof(struct ebt_standard_target) >
e->next_offset) {
BUGPRINT("Standard target size too big\n");
return -1;
}

Thanks
Sharat

On Thu, May 1, 2014 at 10:09 AM, Sharat Masetty <sharat04@gmail.com> wr=
ote:
> We are using a 3.10.0 kernel version which has CONFIG_COMPAT enabled.
> The ebtables version is 2.0.10-4.  This is arm 63/32 not x86.
> I also have another question. Do we need to compile the userspace too=
l
> using the sanitized kernel headers?(uapi/linux) or should we be using
> headers provided in the ebtables user space package? The reason for
> asking this question is that I see some differences in the structure
> definitions between the ebtables packaged kernel header files and the
> header files exposed by the kernel.
>
> Please let me know what to watch out for
>
> Thanks
> Sharat
>
> On Thu, May 1, 2014 at 4:02 AM, Florian Westphal <fw@strlen.de> wrote=
:
>> Sharat Masetty <sharat04@gmail.com> wrote:
>>> I am seeing a problem when running ebtables in 32bit userspace and =
64
>>> bit kernel space mode.
>>>
>>> The command I am trying to run is
>>> ebtables -t broute -A BROUTING -p IPv4 -j DROP
>>>
>>> Here is the log message I am seeing in userspace
>>>
>> [..]
>>
>>> I noticed that setsockopt() is failing . The message is also printe=
d
>>> in kernel =E2=80=93 Standard target size too big . This occurs beca=
use there
>>> is a mismatch in the size of the structures ebt_standard_target whi=
ch
>>> is 48 bytes in kernel and 40 bytes in userspace.
>>>
>>> Can someone help us fix this issue?
>>
>> Please provide more information.
>>
>> Works fine for me on x86_64 with 32 bit binary:
>> # ~/bin32/ebtables -t broute -A BROUTING -p IPv4 -j DROP
>> # echo $?
>> 0
>> ebtables -L shows
>> Bridge chain: BROUTING, entries: 1, policy: ACCEPT
>> -p IPv4 -j DROP
>>
>> as expected.  Linux 3.13.11 x86_64.
>>
>> Are you using an old kernel without ebt compat support?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
