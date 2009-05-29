From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Fri, 29 May 2009 19:16:10 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905291915490.12199@fbirervta.pbzchgretzou.qr>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>  <4A1EB783.4090801@pandora.be>  <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>  <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
 <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com> <4A200B60.6080804@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sachin sanap <sachin.sanap.1gb@gmail.com>,
	netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60286 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZE2RQK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2009 13:16:10 -0400
In-Reply-To: <4A200B60.6080804@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-05-29 18:20, Bart De Schuymer wrote:

> Hi,
>
> I think it's best to fix this in the kernel if it's possible, since we don't
> want to break compatibility.
> If the fix has to be in userspace, then it must be a fix that still works for
> older kernels.

Since the kernel uses xt_align already, it's best for userspace to do the same.

>>
>> #ifndef IPPROTO_SCTP
>> #define IPPROTO_SCTP           132
>> @@ -37,7 +38,7 @@
>> #define EXEC_STYLE_DAEMON      1
>>
>> #ifndef EBT_MIN_ALIGN
>> -#define EBT_MIN_ALIGN (__alignof__(struct ebt_entry_target))
>> +#define EBT_MIN_ALIGN (__alignof__(struct _xt_align))
>> #endif
>> #define EBT_ALIGN(s) (((s) + (EBT_MIN_ALIGN-1)) & ~(EBT_MIN_ALIGN-1))
>> #define ERRORMSG_MAXLEN 128
>>
