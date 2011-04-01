From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 02/17] mark newly opened fds as FD_CLOEXEC (close on exec)
Date: Fri, 1 Apr 2011 14:34:39 -0700
Message-ID: <BANLkTinwDu8MkeoNyHh9e6p1S69DqFEZGQ@mail.gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
	<1301632053-3694-2-git-send-email-zenczykowski@gmail.com>
	<alpine.LNX.2.01.1104011130430.10168@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:12611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DAVes (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:34:48 -0400
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p31LYfCl023777
	for <netfilter-devel@vger.kernel.org>; Fri, 1 Apr 2011 14:34:45 -0700
Received: from pwi4 (pwi4.prod.google.com [10.241.219.4])
	by hpaq5.eem.corp.google.com with ESMTP id p31LY6FZ021974
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 1 Apr 2011 14:34:39 -0700
Received: by pwi4 with SMTP id 4so1367093pwi.11
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Apr 2011 14:34:39 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104011130430.10168@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Redhat still has not given a reason as to why this is needed.

I believe:
  a) the fact CLOEXEC isn't the default on new fd's is a (UNIX/POSIX)
API bug (which of course can't be fixed...)
  b) not setting CLOEXEC on every fd is an application bug (with the
exception of the specific few fd's you actually want inherited)
  c) iptables does occasionally fork/exec (to load modules), for
example "/sbin/modprobe ip6_tables -q", but also for match/target
revision compatibility checking, and when it does this it can call
modprobe with additional opened descriptors (for example sockfd inside
of compatible_revision isn't closed before fork/exec modprobe) - this
is unclean, and could potentially cause security warnings (or even
issues?) since iptables and modprobe have different contexts.

[fc14]# ls -alZ `which iptables`
lrwxrwxrwx. root root system_u:object_r:bin_t:s0       /sbin/iptables
-> iptables-multi
[fc14]# ls -alZ /sbin/iptables-multi
-rwxr-xr-x. root root system_u:object_r:iptables_exec_t:s0 /sbin/iptables-multi
[fc14]#  ls -alZ `which modprobe`
-rwxr-xr-x. root root system_u:object_r:insmod_exec_t:s0 /sbin/modprobe

I'm not going to claim I fully understand the security implications of
leaving the file descriptor open across exec, but there is clearly no
reason to do so, hence the patch.
