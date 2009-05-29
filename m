From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Fri, 29 May 2009 16:44:24 +0530
Message-ID: <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>
	 <4A1EB783.4090801@pandora.be>
	 <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
	 <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48685 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbZE2LOW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2009 07:14:22 -0400
Received: by gxk10 with SMTP id 10so10254243gxk.13
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2009 04:14:24 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry dint inform you earlier that iam on 32bit ARM machine.
The real problem is the kernel is computing the alignment on
__alignof__(struct _xt_align) and the userspace ebtables is computing
it on __alignof__(struct ebt_entry_target) , which are two different
structs.

I have the following patch for ebtables-v2.0.8-2 that fixes this.



--- ebtables-v2.0.8-2.orig/include/ebtables_u.h 2009-05-29
21:41:32.000000000 +0530
+++ ebtables-v2.0.8-2/include/ebtables_u.h      2009-05-29
21:43:32.000000000 +0530
@@ -25,6 +25,7 @@
 #define EBTABLES_U_H
 #include <netinet/in.h>
 #include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter/x_tables.h>

 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP           132
@@ -37,7 +38,7 @@
 #define EXEC_STYLE_DAEMON      1

 #ifndef EBT_MIN_ALIGN
-#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))
+#define EBT_MIN_ALIGN (__alignof__(struct _xt_align))
 #endif
 #define EBT_ALIGN(s) (((s) + (EBT_MIN_ALIGN-1)) & ~(EBT_MIN_ALIGN-1))
 #define ERRORMSG_MAXLEN 128


-Sachin




On Fri, May 29, 2009 at 3:32 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Friday 2009-05-29 07:51, sachin sanap wrote:
>
>>Iam facing problem with ebtables binay on 2.6.28 kernel (same binary
>>works well with 2.6.27). Its mostly a structure alignment issue with
>>standard targets like DROP,ACCEPT etc. Message seen by user is
>>"eb_tables: standard target: invalid size 8 !=3D 4"
>>Iam trying to fix it, this mail is just to check if its already fixed
>>by someone else?
>
> Indeed this seems to happen, but only when using a mixed-bitness
> combination:
>
> /tmp/usr/sbin # LD_LIBRARY_PATH=3D../lib ./ebtables -A INPUT -j ACCEP=
T
> The kernel doesn't support the ebtables 'filter' table.
>
> /tmp/usr/sbin # uname -a
> Linux sovereign 2.6.29.3-jen80-default #1 SMP 2009-04-06 18:10:58 +02=
00
> x86_64 x86_64 x86_64 GNU/Linux
>
> /tmp/usr/sbin # file ebtables
> ebtables: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), f=
or
> GNU/Linux 2.6.4, dynamically linked (uses shared libs), stripped
>
> ebtables does work when it is 64-bit too, so the immediate workaround=
 =97
> assuming you are on x86 =97 is to not use a 32-bit userspace with a
> 64-bit kernel.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
