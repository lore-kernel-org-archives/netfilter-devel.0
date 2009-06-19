From: Sachin Sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Fri, 19 Jun 2009 11:36:48 +0530
Message-ID: <17923cc80906182306t2ae2c7dav3611f61b5c27d0b9@mail.gmail.com>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>
	 <4A1EB783.4090801@pandora.be>
	 <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
	 <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
	 <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com>
	 <alpine.LSU.2.00.0906141921430.31733@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Lennart Buytenhek <buytenh@wantstofly.org>,
	Bart de Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	Peter Volkov <pva@gentoo.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:62969 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZFSGGp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:06:45 -0400
Received: by gxk10 with SMTP id 10so2556266gxk.13
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2009 23:06:48 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0906141921430.31733@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 14, 2009 at 11:12 PM, Jan Engelhardt<jengelh@medozas.de> wrote:
> On Friday 2009-05-29 13:14, sachin sanap wrote:
>
>>Sorry dint inform you earlier that iam on 32bit ARM machine.
>>The real problem is the kernel is computing the alignment on
>>__alignof__(struct _xt_align) and the userspace ebtables is computing
>>it on __alignof__(struct ebt_entry_target) , which are two different
>>structs.
>>
>>I have the following patch for ebtables-v2.0.8-2 that fixes this.
>>@@ -37,7 +38,7 @@
>> #define EXEC_STYLE_DAEMON      1
>>
>> #ifndef EBT_MIN_ALIGN
>>-#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))
>>+#define EBT_MIN_ALIGN (__alignof__(struct _xt_align))
>> #endif
>> #define EBT_ALIGN(s) (((s) + (EBT_MIN_ALIGN-1)) & ~(EBT_MIN_ALIGN-1))
>> #define ERRORMSG_MAXLEN 128
>
> Can you run this, just to give me a better understanding of ARM32?
>
>
> #include <stdio.h>
> #include <stdint.h>
> #define p(t) \
>        printf(#t ": %zu\n", __alignof__(t));
>
> int main(void)
> {
>        p(uint8_t);
>        p(uint16_t);
>        p(uint32_t);
>        p(uint64_t);
>        p(float);
>        p(double);
>        p(void *);
>        p(void (*)(void));
> }
>
Here is the output from ARM

uint8_t: 1
uint16_t: 2
uint32_t: 4
uint64_t: 8
float: 4
double: 8
void *: 4
void (*)(void): 4

I have CONFIG_AEABI=y

-Sachin Sanap
