From: Paul Moore <paul@paul-moore.com>
Subject: Re: iptables audit target causes kernel panic with
 iptables-persistent (kernel 3.2.78)
Date: Tue, 26 Apr 2016 14:54:26 -0400
Message-ID: <CAHC9VhQ7577V3M_t9_GCJuGWsrCtUFJb-GjOnCmmEP+rHr-BcQ@mail.gmail.com>
References: <nfnajo$4cj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org
To: Lev Stipakov <lstipakov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33237 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcDZSy1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 14:54:27 -0400
Received: by mail-oi0-f52.google.com with SMTP id r78so25252548oie.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 11:54:27 -0700 (PDT)
In-Reply-To: <nfnajo$4cj$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 26, 2016 at 4:58 AM, Lev Stipakov <lstipakov@gmail.com> wrote:
> Hello,
>
> I see kernel panic with iptables-persistent package installed and one
> iptables rule with AUDIT target.
>
>   root@debian7:~# uname -a
>   Linux debian7 3.2.0-4-amd64 #1 SMP Debian 3.2.78-1 x86_64 GNU/Linux
>
>   root@debian7:~# dpkg -l | grep iptables
>   ii  iptables                  1.4.14-3.1
>   ii  iptables-persistent       0.5.7+deb7u1
>
> Steps to reproduce:
>
> 1) Install Debian 7 and iptables-persistent (see versions above)
> 2) Add iptables rule (must be OUTPUT chain):
>
>   root@debian7:~# iptables -I OUTPUT -j AUDIT --type ACCEPT
>
> 3) Save rule:
>
>   root@debian7:~# iptables-save > /etc/iptables/rules.v4
>
> 4) Reboot
>
> 5) Kernel panic (screenshot):
> https://www.dropbox.com/s/db40e5kc10e4ddg/kernel_panic2.png?dl=0
>
>
> I cannot reproduce it on (one of) previous kernel version:
>
>   lev@debi7:~$ uname -a
>   Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64 GNU/Linux
>
>   lev@debi7:~$ dpkg -l | grep iptables
>   ii  iptables                           1.4.14-3.1
>   ii  iptables-persistent                0.5.7+deb7u1

Unfortunately I don't have a Debian system available to test, but have
you tried reproducing this on a more modern kernel?

-- 
paul moore
www.paul-moore.com
