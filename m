From: Tim Verhoeven <tim.verhoeven.be@gmail.com>
Subject: Compiling ebtables statically or dynamically results in different
	behaviour
Date: Tue, 7 Apr 2009 15:53:15 +0200
Message-ID: <2a7fce340904070653h14f05a32y5bcb7f2b9713403a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43919 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZDGNxR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:53:17 -0400
Received: by bwz17 with SMTP id 17so2321325bwz.37
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2009 06:53:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a very strange problem with ebtables. I'm using it on CentOS 5
(2.6.18 kernel) and when using the dynamically compiled version
(version 2.0.8-2) I can't create a new chain. When using the same
version but compiled statically it works. The difference is clearly to
see when using a strace :

Good behavior (statically compiled) :

setsockopt(3, SOL_IP, 0x80 /* IP_??? */,
"filter\0\0\0\352tv;\0\0\0\0\0\0\0\0\0\0\0008\2\0\0\0\0\0\0"..., 312)
= 0
exit_group(0)                           = ?


Bad behavior (dynamically compiled) :

setsockopt(3, SOL_IP, 0x80 /* IP_??? */,
"filter\0\0\0\352tv;\0\0\0\0\0\0\0\0\0\0\0e\3\0\0\0\0\0\0"..., 312) =
-1 EINVAL (Invalid argument)
write(2, "The kernel doesn't support a cer"..., 113The kernel doesn't
support a certain ebtables extension, consider recompiling your kernel
or insmod the extension) = 113
write(2, ".\n", 2.
)                      = 2
exit_group(-1)                          = ?

For some reason the one version sets different options then the other.
I've tried different things (compiling against the standard kernel
include files (kernel-devel), compiling against the included include
files, using some gcc options, ...). But none of those worked. Any
hints are appreciated.

Regards,
Tim

-- 
Tim Verhoeven - tim.verhoeven.be@gmail.com - 0479 / 88 11 83

Hoping the problem  magically goes away  by ignoring it is the
"microsoft approach to programming" and should never be allowed.
(Linus Torvalds)
