From: d tbsky <tbskyd@gmail.com>
Subject: strange result of iptables command under race condition
Date: Fri, 15 Mar 2013 22:47:02 +0800
Message-ID: <CAC6SzH+8D0i1ggXKe3UYB5Jad8Wp+GsAP_JbonCFERnWzU2T3w@mail.gmail.com>
References: <CAC6SzH+GZ+oKM9fxdw8Hax-rd=XxmdcrttDvSUVTkD=sJChz+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:58218 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3COOrE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:47:04 -0400
Received: by mail-bk0-f53.google.com with SMTP id j10so1532178bkw.40
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2013 07:47:02 -0700 (PDT)
In-Reply-To: <CAC6SzH+GZ+oKM9fxdw8Hax-rd=XxmdcrttDvSUVTkD=sJChz+g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi:
   I want to make my firewall script better, so it won't be bothered
if there are other iptables command running in the same time.(like
administrator invoke iptables command from shell.)

  I don't want to change the linux system default file, so I don't
want to make a wrapper for iptables command. I want my script to
detect the conflict, so I try to write two testing script like below:

a.sh:
#!/bin/bash
while /bin/true ;do
    while /bin/true; do
        iptables -A INPUT -s 10.1.1.1 -j ACCEPT && break
    done
    while /bin/true;do
        iptables -D INPUT -s 10.1.1.1 -j ACCEPT && break
    done
done

b.sh:
#!/bin/bash
while /bin/true ;do
    while /bin/true; do
        iptables -A INPUT -s 10.2.2.2 -j ACCEPT && break
    done
    while /bin/true;do
        iptables -D INPUT -s 10.2.2.2 -j ACCEPT && break
    done
done

then I run two scripts simultaneously:
./a.sh &
./b.sh

I saw lot of error messages. but I am surprised there are three kind
of error messages.
1. iptables: Resource temporarily unavailable.
    => this is expected. and error code is 4. I can detect it.
2. iptables: Invalid argument. Run `dmesg' for more information.
     => I don't know why this error comes out.
3. iptables: Bad rule (does a matching rule exist in that chain?).
     => this is even more strange. this means the "iptables -D" has no
entry to delete. so it means the last "iptables -A" report success but
it is actually failed to insert the rule.

it seems run two iptables command simultaneously is dangerous and
would cause a mess. I wonder why the iptables command can not
detect/prevent the conflict itself?
so I think for system reliability the only way is to write a locking
wrapper for iptables command(like flock /sbin/iptables -c
/sbin/iptables)

thanks a lot for suggestion!

Regards,
tbskyd
