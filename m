From: Lev Stipakov <lstipakov@gmail.com>
Subject: Re: iptables audit target causes kernel panic with
 iptables-persistent (kernel 3.2.78)
Date: Tue, 26 Apr 2016 22:58:35 +0300
Message-ID: <571FC86B.9000703@gmail.com>
References: <nfnajo$4cj$1@ger.gmane.org>
 <CAHC9VhQ7577V3M_t9_GCJuGWsrCtUFJb-GjOnCmmEP+rHr-BcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33513 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcDZT6k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 15:58:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id r12so7287489wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 12:58:39 -0700 (PDT)
In-Reply-To: <CAHC9VhQ7577V3M_t9_GCJuGWsrCtUFJb-GjOnCmmEP+rHr-BcQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yep, it works fine on Debian 8:

lev@debi:~$ uname -a
Linux debi 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3 
(2016-01-17) x86_64 GNU/Linux


On 26.04.2016 21:54, Paul Moore wrote:
>>
>> I cannot reproduce it on (one of) previous kernel version:
>>
>>    lev@debi7:~$ uname -a
>>    Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64 GNU/Linux
>>
>>    lev@debi7:~$ dpkg -l | grep iptables
>>    ii  iptables                           1.4.14-3.1
>>    ii  iptables-persistent                0.5.7+deb7u1
>
> Unfortunately I don't have a Debian system available to test, but have
> you tried reproducing this on a more modern kernel?
>

