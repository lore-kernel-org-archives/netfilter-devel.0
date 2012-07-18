From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: Ulogd crashes - NFCT polling mode + NACCT
Date: Wed, 18 Jul 2012 11:56:41 -0700
Message-ID: <CAAJpzgYGxVgazp74qck_Diacp7SJCjMOZFhw7cX0_k6B-4Qw9Q@mail.gmail.com>
References: <CAAJpzgZdfV3_r4ymFLvWroRjJkaQVtUdwb4P-vf57fyGJL7bzw@mail.gmail.com>
 <1342637536.5282.8.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53022 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2GRS5C convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:57:02 -0400
Received: by yhmm54 with SMTP id m54so1927246yhm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jul 2012 11:57:01 -0700 (PDT)
In-Reply-To: <1342637536.5282.8.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I used the following stacks in my configuration file

stack=3Dct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
stack=3Dct1:NFCT,ip2str1:IP2STR,nacct1:NACCT


[ct1]
netlink_socket_buffer_size=3D217088
netlink_socket_buffer_maxsize=3D1085440
#netlink_resync_timeout=3D60 # seconds to wait to perform resynchroniza=
tion
pollinterval=3D30 # use poll-based logging instead of event-driven
hash_enable=3D1

This morning, I tried out commenting
stack=3Dct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU, and
launched ulogd(polling mode + NACCT) only. It successfully works.

It seems I cannot use the same input plugin in polling mode for two
different stacks.

Thanks & Regards,




On Wed, Jul 18, 2012 at 11:52 AM, Eric Leblond <eric@regit.org> wrote:
> Hello,
>
> Le mercredi 18 juillet 2012 =E0 08:21 -0700, Gomathivinayagam
> Muthuvinayagam a =E9crit :
>> Hi,
>>
>> I try to use ulogd with NFCT polling mode and NACCT output. Ulogd
>
> Can you send us information about your configuration like the stack u=
sed
> for logging.
>
> Other questions: do conntrack -L work ?
>
>> crashes with this options, and stacktrace is given as below
>> Could someone help me the reason for this failure?
>>
>> =3D=3D Stacktrace =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> #0  0x00007fe46c334445 in raise () from /lib/x86_64-linux-gnu/libc.s=
o.6
>> No symbol table info available.
>> #1  0x00007fe46c337bab in abort () from /lib/x86_64-linux-gnu/libc.s=
o.6
>> No symbol table info available.
>> #2  0x00007fe46c32d10e in ?? () from /lib/x86_64-linux-gnu/libc.so.6
>> No symbol table info available.
>> #3  0x00007fe46c32d1b2 in __assert_fail () from /lib/x86_64-linux-gn=
u/libc.so.6
>> No symbol table info available.
>> #4  0x00007fe46b8d6274 in nfct_query (h=3D0x0, qt=3D<optimized out>,
>
> If we have a NULL handle that explain the crash. Question is how we
> manage to get this.
>
> BR,
> --
> Eric Leblond
> Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
