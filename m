From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Sun, 14 Jun 2009 19:42:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906141921430.31733@fbirervta.pbzchgretzou.qr>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>  <4A1EB783.4090801@pandora.be>  <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>  <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
 <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Lennart Buytenhek <buytenh@wantstofly.org>,
	Bart de Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	Peter Volkov <pva@gentoo.org>
To: Sachin Sanap <sachin.sanap.1gb@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51669 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZFNRmC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:42:02 -0400
In-Reply-To: <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2009-05-29 13:14, sachin sanap wrote:

>Sorry dint inform you earlier that iam on 32bit ARM machine.
>The real problem is the kernel is computing the alignment on
>__alignof__(struct _xt_align) and the userspace ebtables is computing
>it on __alignof__(struct ebt_entry_target) , which are two different
>structs.
>
>I have the following patch for ebtables-v2.0.8-2 that fixes this.
>@@ -37,7 +38,7 @@
> #define EXEC_STYLE_DAEMON      1
>
> #ifndef EBT_MIN_ALIGN
>-#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))
>+#define EBT_MIN_ALIGN (__alignof__(struct _xt_align))
> #endif
> #define EBT_ALIGN(s) (((s) + (EBT_MIN_ALIGN-1)) & ~(EBT_MIN_ALIGN-1))
> #define ERRORMSG_MAXLEN 128

Can you run this, just to give me a better understanding of ARM32?


#include <stdio.h>
#include <stdint.h>
#define p(t) \
	printf(#t ": %zu\n", __alignof__(t));

int main(void)
{
	p(uint8_t);
	p(uint16_t);
	p(uint32_t);
	p(uint64_t);
	p(float);
	p(double);
	p(void *);
	p(void (*)(void));
}
