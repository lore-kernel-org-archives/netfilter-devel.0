From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: [PATCH] iptables: optionally disable largefile support.
Date: Mon, 10 May 2010 10:14:27 +0200
Message-ID: <4BE7C063.5000302@hiramoto.org>
References: <1273476638-31417-1-git-send-email-karl@hiramoto.org> <alpine.LSU.2.01.1005100959270.23890@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:45009 "EHLO
	homiemail-a34.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755304Ab0EJIOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 04:14:34 -0400
In-Reply-To: <alpine.LSU.2.01.1005100959270.23890@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/10/2010 10:00 AM, Jan Engelhardt wrote:
> What is the actual problem you are experiencing? If the toolchain does
> not support largefiles, the -D macros should not do anything, so that
> conversely, their presence is not harmful.
>    
Uclibc include headers do checking see:

http://git.uclibc.org/uClibc/tree/include/features.h#n216


You get errors like:


usr/include/features.h:383:4: error: #error It appears you have defined 
_FILE_OFFSET_BITS=64. Unfortunately, uClibc was built without large file 
support enabled.
In file included from /build_armeb/staging_dir/usr/include/stdio.h:72,
                  from libiptc/libip4tc.c:18:
/build_armeb/staging_dir/usr/include/bits/uClibc_stdio.h:72:2: error: 
#error Sorry... uClibc was built without large file support!
In file included from libiptc/libip4tc.c:18:
/build_armeb/staging_dir/usr/include/stdio.h:83: error: expected '=', 
',', ';', 'asm' or '__attribute__' before 'fpos_t'
In file included from libiptc/libip4tc.c:18:
/build_armeb/staging_dir/usr/include/stdio.h:709: error: expected 
declaration specifiers or '...' before 'fpos_t'
/build_armeb/staging_dir/usr/include/stdio.h:711: error: expected ';', 
',' or ')' before '*' token


With this patch everything compiles and works fine.

--
Karl
