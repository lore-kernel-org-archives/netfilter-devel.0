From: Loic <hackurx@opensec.fr>
Subject: Re: [netfilter-core] Heap overflow in xt_geoip.c
Date: Sun, 23 Jul 2017 14:48:03 +0200
Message-ID: <a72148eac6a538e975281ad675758dfb@opensec.fr>
References: <CAFwXZv_CZanNT=MTcA7G_5YtgJ07+2Xf-poXy2dNfv+V=j4iLw@mail.gmail.com>
 <59482edb.6385df0a.e863a.a6ca.GMRIR@mx.google.com>
 <6358d530697ad564236584c07d2f3cb2@opensec.fr> <20170621161642.GB6117@salvia>
 <nycvar.YFH.7.76.1706252143110.6159@n3.vanv.qr>
 <f2aa016334df64f2e88dc7b0cb802762@opensec.fr>
 <77bf7ff91165dafb9955bbcb63544898@opensec.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.opensec.fr ([82.236.169.210]:44970 "EHLO mail.opensec.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751346AbdGWMsD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jul 2017 08:48:03 -0400
In-Reply-To: <77bf7ff91165dafb9955bbcb63544898@opensec.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>> On Tue, Jun 20, 2017 at 08:31:26PM +0200, Loic wrote:
>>>>> Hi,
>>>>> 
>>>>> I think there is a problem in the geoip code because I detect this:
>>>>> 
>>>>> grep -ar "cicus.162_313 max" 
>>>>> /usr/src/xtables-addons-2.12/extensions/
>>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:cicus.162_313 
>>>>> max,
>>>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; 
>>>>> num:
>>>>> 0; context: attr;
>>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:cicus.162_313 
>>>>> max,
>>>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; 
>>>>> num:
>>>>> 0; context: attr;

I did not find what I was looking for but a static code analysis 
revealed a errors.
Help: The documentation for all analyzer warnings is available here: 
http://www.viva64.com/en/w/.

/xtables-addons-2.13/extensions/ACCOUNT/libxt_ACCOUNT_cl.c	166	err	V575 
The null pointer is passed into 'setsockopt' function. Inspect the 
fourth argument.
/xtables-addons-2.13/extensions/ACCOUNT/libxt_ACCOUNT_cl.c	166	err	V575 
The 'setsockopt' function processes '0' elements. Inspect the fifth 
argument.
/xtables-addons-2.13/extensions/pknock/pknlusr.c	45	warn	V641 The size 
of the '& src_addr' buffer is not a multiple of the element size of the 
type 'struct sockaddr'.
/xtables-addons-2.13/extensions/pknock/pknlusr.c	72	warn	V641 The size 
of the '& dest_addr' buffer is not a multiple of the element size of the 
type 'struct sockaddr'.
/xtables-addons-2.13/extensions/xt_DNETMAP.c	401	err	V512 A call of the 
'memcmp' function will lead to the '& e->prefix' buffer becoming out of 
range.
/xtables-addons-2.13/extensions/xt_DELUDE.c	82	warn	V560 A part of 
conditional expression is always true: !oth->rst.
/xtables-addons-2.13/extensions/xt_geoip.c	148	err	V568 It's odd that 
'sizeof()' operator evaluates the size of a pointer to a class, but not 
the size of the '(& geoip_head[proto])->next' class object.
/xtables-addons-2.13/extensions/xt_geoip.c	148	err	V568 It's odd that 
'sizeof()' operator evaluates the size of a pointer to a class, but not 
the size of the 'p->list.next' class object.
/xtables-addons-2.13/extensions/xt_ipp2p.c	514	warn	V666 Consider 
inspecting fourth argument of the function 'HX_memmem'. It is possible 
that the value does not correspond with the length of a string which was 
passed with the third argument.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	622	err	V595 The 
'peer' pointer was utilized before it was verified against nullptr. 
Check lines: 622, 623.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1047	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1053	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1055	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1058	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1061	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1064	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1069	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1072	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1075	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1077	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1079	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1086	warn	V612 An 
unconditional 'return' within a loop.
/xtables-addons-2.13/extensions/pknock/xt_pknock.c	1090	warn	V612 An 
unconditional 'return' within a loop.

Thanks !

-- 
Best regards,

Loic
