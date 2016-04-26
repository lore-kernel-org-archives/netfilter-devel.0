From: Lev Stipakov <lstipakov@gmail.com>
Subject: iptables audit target causes kernel panic with iptables-persistent
 (kernel 3.2.78)
Date: Tue, 26 Apr 2016 12:25:02 +0300
Message-ID: <CAGyAFMVTf6nRtKtdQAJ0EqP3tpz7k=UBY+6daXmt+h3h3GKqfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33181 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbcDZJZE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 05:25:04 -0400
Received: by mail-lf0-f65.google.com with SMTP id p64so1481640lfg.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 02:25:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I see kernel panic with iptables-persistent package installed and one
iptables rule with AUDIT target.

  root@debian7:~# uname -a
  Linux debian7 3.2.0-4-amd64 #1 SMP Debian 3.2.78-1 x86_64 GNU/Linux

  root@debian7:~# dpkg -l | grep iptables
  ii  iptables            1.4.14-3.1
  ii  iptables-persistent    0.5.7+deb7u1

Steps to reproduce:

1) Install Debian 7 and iptables-persistent (see versions above)
2) Add iptables rule (must be OUTPUT chain):

  root@debian7:~# iptables -I OUTPUT -j AUDIT --type ACCEPT

3) Save rule:

  root@debian7:~# iptables-save > /etc/iptables/rules.v4

4) Reboot

5) Kernel panic (screenshot):
https://www.dropbox.com/s/db40e5kc10e4ddg/kernel_panic2.png?dl=0

I cannot reproduce it on (one of) previous kernel version:

  lev@debi7:~$ uname -a
  Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64 GNU/Linux

  lev@debi7:~$ dpkg -l | grep iptables
  ii  iptables                           1.4.14-3.1
  ii  iptables-persistent                0.5.7+deb7u1

-Lev
