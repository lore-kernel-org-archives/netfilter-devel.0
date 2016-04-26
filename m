From: Paul Moore <paul@paul-moore.com>
Subject: Re: iptables audit target causes kernel panic with
 iptables-persistent (kernel 3.2.78)
Date: Tue, 26 Apr 2016 16:17:20 -0400
Message-ID: <CAHC9VhTRdW-bfCw6hBPkrkVdBS_fA3jEZwiBUj_m2VtLDFEuSw@mail.gmail.com>
References: <nfnajo$4cj$1@ger.gmane.org>
	<CAHC9VhQ7577V3M_t9_GCJuGWsrCtUFJb-GjOnCmmEP+rHr-BcQ@mail.gmail.com>
	<571FC86B.9000703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org
To: Lev Stipakov <lstipakov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34881 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbcDZURV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 16:17:21 -0400
Received: by mail-oi0-f41.google.com with SMTP id x19so27571083oix.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 13:17:21 -0700 (PDT)
In-Reply-To: <571FC86B.9000703@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 26, 2016 at 3:58 PM, Lev Stipakov <lstipakov@gmail.com> wrote:
> Yep, it works fine on Debian 8:
>
> lev@debi:~$ uname -a
> Linux debi 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3 (2016-01-17)
> x86_64 GNU/Linux

I would suggest bringing this up with the Debian kernel
packagers/maintainers, or doing a git-bisect of the Debian kernel if
you are comfortable with that sort of thing.

> On 26.04.2016 21:54, Paul Moore wrote:
>>>
>>>
>>> I cannot reproduce it on (one of) previous kernel version:
>>>
>>>    lev@debi7:~$ uname -a
>>>    Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64
>>> GNU/Linux
>>>
>>>    lev@debi7:~$ dpkg -l | grep iptables
>>>    ii  iptables                           1.4.14-3.1
>>>    ii  iptables-persistent                0.5.7+deb7u1
>>
>> Unfortunately I don't have a Debian system available to test, but have
>> you tried reproducing this on a more modern kernel?

-- 
paul moore
www.paul-moore.com
