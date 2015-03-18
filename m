From: Pavel Odintsov <pavel.odintsov@gmail.com>
Subject: Re: Can't link C++ program to libipset
Date: Wed, 18 Mar 2015 16:15:30 +0300
Message-ID: <CALgsdbd0AuBxH9wSC_ZbwXdcDVDvVjK0ycUXBxS6kZdkCqgfQw@mail.gmail.com>
References: <CALgsdbeBy=wDnyEpZTrGb0=HKPB9kcS03m=jPzCLfzotyA7P8Q@mail.gmail.com>
	<alpine.LSU.2.11.1503181258200.8959@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32881 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbbCRNPc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 09:15:32 -0400
Received: by wixw10 with SMTP id w10so63730584wix.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2015 06:15:31 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.11.1503181258200.8959@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you, Jan! Could anybody commit this fix to ipset repo?

On Wed, Mar 18, 2015 at 3:01 PM, Jan Engelhardt <jengelh@inai.de> wrote=
:
>
> On Wednesday 2015-03-18 12:20, Pavel Odintsov wrote:
>>
>>I trying to integrate ipset to my flood monitoring toolkit
>>https://github.com/FastVPSEestiOu/fastnetmon but can't link it
>>correctly.
>>
>>Here you can find [the snippet of] my code:
>>https://gist.github.com/pavel-odintsov/b2277822e5c88e136550
>>
>>And tried link my tool with libipset but haven't any success:
>>g++ ipset.c  -I/opt/ipset/include/ -L/opt/ipset/lib -lipset
>>ipset.c: In function =E2=80=98int main()=E2=80=99:
>>ipset.c:15:37: warning: deprecated conversion from string constant to
>>=E2=80=98char*=E2=80=99 [-Wwrite-strings]
>
> This is a bug in your code, not ipset. In C++, string literals
> have type const char *. In C, they have type char * but are still
> immutable, so you better treat them as const char * in both cases.
>
>>/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
>>undefined reference to 'ipset_session_init(int (*)(char const*, ...))=
'
>
> It's an ipset bug. The ipset header files are missing
>
> #ifdef __cplusplus
> extern "C" {
> #endif
> ...
> wraps.



--=20
Sincerely yours, Pavel Odintsov
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
