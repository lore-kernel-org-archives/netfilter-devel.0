From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: optionally disable largefile support.
Date: Mon, 10 May 2010 17:48:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005101748490.18789@obet.zrqbmnf.qr>
References: <1273476638-31417-1-git-send-email-karl@hiramoto.org> <alpine.LSU.2.01.1005100959270.23890@obet.zrqbmnf.qr> <4BE7C063.5000302@hiramoto.org> <4BE82552.1080705@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Karl Hiramoto <karl@hiramoto.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55771 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0EJPtA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 11:49:00 -0400
In-Reply-To: <4BE82552.1080705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-05-10 17:25, Patrick McHardy wrote:

>Karl Hiramoto wrote:
>> On 05/10/2010 10:00 AM, Jan Engelhardt wrote:
>>> What is the actual problem you are experiencing? If the toolchain does
>>> not support largefiles, the -D macros should not do anything, so that
>>> conversely, their presence is not harmful.
>>>    
>> Uclibc include headers do checking see:
>> 
>> http://git.uclibc.org/uClibc/tree/include/features.h#n216
>> 
>> 
>> You get errors like:
>> 
>> 
>> usr/include/features.h:383:4: error: #error It appears you have defined
>> _FILE_OFFSET_BITS=64. Unfortunately, uClibc was built without large file
>> support enabled.
>> In file included from /build_armeb/staging_dir/usr/include/stdio.h:72,
>>                  from libiptc/libip4tc.c:18:
>> /build_armeb/staging_dir/usr/include/bits/uClibc_stdio.h:72:2: error:
>> #error Sorry... uClibc was built without large file support!
>> In file included from libiptc/libip4tc.c:18:
>> /build_armeb/staging_dir/usr/include/stdio.h:83: error: expected '=',
>> ',', ';', 'asm' or '__attribute__' before 'fpos_t'
>> In file included from libiptc/libip4tc.c:18:
>> /build_armeb/staging_dir/usr/include/stdio.h:709: error: expected
>> declaration specifiers or '...' before 'fpos_t'
>> /build_armeb/staging_dir/usr/include/stdio.h:711: error: expected ';',
>> ',' or ')' before '*' token
>> 
>> 
>> With this patch everything compiles and works fine.
>
>Thanks for the explanation. Jan, can I assume you're OK with this patch?

Yeah. Time to bugger uclibc now :-)
