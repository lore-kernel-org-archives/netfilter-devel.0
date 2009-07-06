From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: conntrack segfault
Date: Mon, 6 Jul 2009 12:29:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0907061214330.30142@bizon.gios.gov.pl>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de> <4A4159BE.7040807@birkenwald.de> <20090624105915.GA8675@schleppi.birkenwald.de> <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl>
 <alpine.LSU.2.00.0906241353160.16864@fbirervta.pbzchgretzou.qr> <4A42226A.4040502@birkenwald.de> <4A426932.1030607@netfilter.org> <20090624221845.GA16585@pest>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1902975088-1246876194=:30142"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:59738 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZGFKaT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:30:19 -0400
In-Reply-To: <20090624221845.GA16585@pest>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1902975088-1246876194=:30142
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 25 Jun 2009, Bernhard Schmidt wrote:

> Hi,
Hi,

> not sure whether this helps, but after what felt like 500 attempts of
> running conntrack -L in valgrind I just captured one crash.
>
> secomat2:~ # valgrind -v conntrack -L > /dev/null
> ==24699== Memcheck, a memory error detector.
> ==24699== Copyright (C) 2002-2007, and GNU GPL'd, by Julian Seward et
> al.
> ==24699== Using LibVEX rev 1854, a library for dynamic binary
> translation.
> ==24699== Copyright (C) 2004-2007, and GNU GPL'd, by OpenWorks LLP.
> ==24699== Using valgrind-3.3.1, a dynamic binary instrumentation
> framework.
> ==24699== Copyright (C) 2000-2007, and GNU GPL'd, by Julian Seward et
> al.
> ==24699==
> --24699-- Command line
> --24699--    conntrack
> --24699--    -L
> --24699-- Startup, with flags:
> --24699--    -v
> --24699-- Contents of /proc/version:
> --24699--   Linux version 2.6.27.23-0.1-default (geeko@buildhost) (gcc
> version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP
> 2009-05-26 17:02:05 -0400
> --24699-- Arch and hwcaps: AMD64, amd64-sse2
> --24699-- Page sizes: currently 4096, max supported 4096
> --24699-- Valgrind library directory: /usr/lib64/valgrind
> --24699-- Reading syms from /usr/local/sbin/conntrack (0x400000)
> --24699-- Reading syms from /lib64/ld-2.9.so (0x4000000)
> --24699--    object doesn't have a symbol table
> --24699-- Reading syms from /usr/lib64/valgrind/amd64-linux/memcheck
> (0x38000000)
> --24699--    object doesn't have a symbol table
> --24699--    object doesn't have a dynamic symbol table
> --24699-- Reading suppressions file: /usr/lib64/valgrind/default.supp
> --24699-- Reading syms from
> /usr/lib64/valgrind/amd64-linux/vgpreload_core.so (0x4A1F000)
> --24699--    object doesn't have a symbol table
> --24699-- Reading syms from
> /usr/lib64/valgrind/amd64-linux/vgpreload_memcheck.so (0x4C21000)
> --24699--    object doesn't have a symbol table
> --24699-- Reading syms from
> /usr/local/lib/libnetfilter_conntrack.so.1.2.0 (0x4E2A000)
> --24699-- Reading syms from /usr/local/lib/libnfnetlink.so.0.2.0
> (0x5043000)
> --24699-- Reading syms from /lib64/libc-2.9.so (0x524B000)
> --24699--    object doesn't have a symbol table
> --24699-- Reading syms from /lib64/libdl-2.9.so (0x55A4000)
> --24699--    object doesn't have a symbol table
> --24699-- REDIR: 0x52c7c30 (rindex) redirected to 0x4c25a00 (rindex)
> --24699-- REDIR: 0x52c93f0 (memset) redirected to 0x4c26ca0 (memset)
> --24699-- REDIR: 0x52c67b0 (strcmp) redirected to 0x4c26100 (strcmp)
> --24699-- REDIR: 0x52c7540 (strlen) redirected to 0x4c25e20 (strlen)
> --24699-- REDIR: 0x52c6600 (index) redirected to 0x4c25b20 (index)
> --24699-- REDIR: 0x52c37f0 (malloc) redirected to 0x4c255e0 (malloc)
> --24699-- REDIR: 0xffffffffff600400 (???) redirected to 0x3802d13d (???)
> --24699-- REDIR: 0x52c3430 (calloc) redirected to 0x4c233b0 (calloc)
> --24699-- REDIR: 0x52cad30 (memcpy) redirected to 0x4c26270 (memcpy)
> --24699-- REDIR: 0x52cd840 (strchrnul) redirected to 0x4c26d70
> (strchrnul)
> --24699-- REDIR: 0x52c9f20 (mempcpy) redirected to 0x4c26dd0 (mempcpy)
> --24699-- REDIR: 0x52c0c00 (free) redirected to 0x4c242e0 (free)
> --24699-- REDIR: 0x52c7b60 (strncpy) redirected to 0x4c25f50 (strncpy)
> vex amd64->IR: unhandled instruction bytes: 0x6 0xDF 0xA1 0xBF 0x8 0x0
> ==24699== Invalid read of size 1
> ==24699==    at 0x7FEFFD3E4: ???
> ==24699==    by 0x7FEFFD3EB: ???
> ==24699==    by 0x7FEFFD3F3: ???
> ==24699==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
> ==24699==
> ==24699== Process terminating with default action of signal 11 (SIGSEGV)
> ==24699==  Access not within mapped region at address 0x0
> ==24699==    at 0x7FEFFD3E4: ???
> ==24699==    by 0x7FEFFD3EB: ???
> ==24699==    by 0x7FEFFD3F3: ???
> ==24699==
> ==24699== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 2 from 1)
> ==24699==
> ==24699== 1 errors in context 1 of 1:
> ==24699== Invalid read of size 1
> ==24699==    at 0x7FEFFD3E4: ???
> ==24699==    by 0x7FEFFD3EB: ???
> ==24699==    by 0x7FEFFD3F3: ???
> ==24699==  Address 0x0 is not stack'd, malloc'd or (recently) free'd


OK. It looks like we hit a NULL poiter assigment here, however something 
is wrong. Valgrind should pointed a file and a line numer so we 
should be able to track and fix it. Instead we have the "unhandled 
instruction bytes" message.

Could you try a more recent version? AFAIR 3.4.1 has much better support 
for your arch (amd64). Please make sure both your libraries and the 
conntrack binary are not stripped.

Best regards,

 			Krzysztof Olêdzki
---1144830174-1902975088-1246876194=:30142--
