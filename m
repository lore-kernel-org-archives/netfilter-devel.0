From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Sun, 1 Nov 2015 23:09:04 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511012247140.7708@nerf40.vanv.qr>
References: <20151029190717.GE5154@vapier.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, neo.neutron@gmail.com
To: 20151006012711.GA5372@oxygen.gentoo.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:43037 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbbKAWJH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2015 17:09:07 -0500
In-Reply-To: <20151029190717.GE5154@vapier.lan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-10-29 20:07, Mike Frysinger wrote:
>Neutron Soutmun wrote:
>> * libmnl using an export map (-Wl,--version-script=3D),
>>  hence, no need to explicitly use the EXPORT_SYMBOL() tags.
>
>this isn't entirely accurate.  the use of hidden visibility allows for
>optimizations (e.g. bypassing the PLT).  export maps merely control th=
e
>final visibility of the symbols at link time ... gcc is forced to assu=
me
>every function call otherwise is still globally visible (exported).

Though your argument makes sense, I find that `gcc -c` does not
really care about the visibility. It always emits, on x86_64, a
0xE8=C2=A0__ __ __ __ opcode for a function call with C external linkag=
e,
whether that function has hidden or default visibility. The linker
fills in the four bytes because only it knows how far to jump, after
combining the .o files.

And it appears to be smart enough not to issue a
"callq <st_intern@plt>":

$ cat x.c
extern void st_exported(void);
extern void st_intern(void);
void st_exported(void) { st_intern(); }
$ cat y.c
extern void st_intern(void);
void st_intern(void) {}
$ cat xy.sym
XY { global: st_exported; local: *; };
$ gcc x.c y.c -fPIC -Wall -shared -o xy.so -Wl,--version-script=3Dxy.sy=
m
$ objdump -d xy.so
0000000000000655 <st_exported>:
 655:	55                   	push   %rbp
 656:	48 89 e5             	mov    %rsp,%rbp
 659:	e8 02 00 00 00       	callq  660 <st_intern>
 65e:	5d                   	pop    %rbp
 65f:	c3                   	retq  =20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
