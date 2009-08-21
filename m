From: fender <frozenspot@gmail.com>
Subject: Re: Couldn't load match `pknock':(null)
Date: Fri, 21 Aug 2009 18:31:56 -0300
Message-ID: <7e36c7130908211431n538a0b3kf83051b77b0d5b56@mail.gmail.com>
References: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>
	 <alpine.LSU.2.00.0908190407200.24013@fbirervta.pbzchgretzou.qr>
	 <7e36c7130908190915j5faa812fy34fc70626de69761@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Luis Floreani <lucholaf@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:64762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbZHUVb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:57 -0400
Received: by fg-out-1718.google.com with SMTP id e21so256396fga.17
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2009 14:31:58 -0700 (PDT)
In-Reply-To: <7e36c7130908190915j5faa812fy34fc70626de69761@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

I've tried with the version 1.4.4 and I've got the same result:

iptables v1.4.4: Couldn't load match `pknock':(null)

An excerpt of strace shows this:

open("/usr/local/libexec/xtables/libipt_pknock.so", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0000\5\0\0004\0\0\0\220"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=8298, ...}) = 0
mmap2(NULL, 10208, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb80a0000
mmap2(0xb80a2000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb80a2000
close(3)                                = 0
write(2, "iptables v1.4.4: "..., 17iptables v1.4.4: )    = 17
write(2, "Couldn't load match `pknock':(nul"..., 36Couldn't load match
`pknock':(null)

So, iptables finds the libipt_pknock module, but it isn't able to load
the ipt_pknock.ko. Do you have any hint to solve this?

Thanks in advance.
Cheers,


On Wed, Aug 19, 2009 at 1:15 PM, fender<frozenspot@gmail.com> wrote:
> On Tue, Aug 18, 2009 at 11:07 PM, Jan Engelhardt<jengelh@medozas.de> wrote:
>>
>> On Wednesday 2009-08-19 00:31, fender wrote:
>>
>>>Hi people,
>>>
>>>I've just applied some patches to the pknock match module to work with
>>>kernel > 2.6.28 and iptables 1.4.x.
>>>
>>>What I get when I try to execute this module is:
>>>
>>># iptables -m pknock --help
>>>iptables v1.4.3: Couldn't load match `pknock':(null)
>>>
>>>
>>>Does anyone have any clue about this issue?
>>
>> My guess that this had been addressed with commit v1.4.3.1-3-gc4edfa6.
>
> Ok, thanks Jan, I'll try with the 1.4.4.
>
> Cheers,
>

-- 
Federico

/*
 *  J. Federico Hernandez (fender) {frozenspot; at; gmail; dot; com;}
 *  GPG PubKey: wwwkeys.eu.pgp.net key 6AE78BF2
 *  FP: 26AB 7A1B C2C4 70F8 0E7D  C3F4 9736 5CE2 6AE7 8BF2
 */
