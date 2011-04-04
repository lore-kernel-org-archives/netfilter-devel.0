From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 02/17] mark newly opened fds as FD_CLOEXEC (close on
 exec)
Date: Mon, 4 Apr 2011 15:00:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104041459531.26118@obet.zrqbmnf.qr>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-2-git-send-email-zenczykowski@gmail.com> <alpine.LNX.2.01.1104011130430.10168@obet.zrqbmnf.qr> <BANLkTinwDu8MkeoNyHh9e6p1S69DqFEZGQ@mail.gmail.com>
 <4D99C074.5040803@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44382 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab1DDNAb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:00:31 -0400
In-Reply-To: <4D99C074.5040803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-04-04 14:58, Patrick McHardy wrote:

>On 01.04.2011 23:34, Maciej =C5=BBenczykowski wrote:
>>> Redhat still has not given a reason as to why this is needed.
>>=20
>> I believe:
>>   a) the fact CLOEXEC isn't the default on new fd's is a (UNIX/POSIX=
)
>> API bug (which of course can't be fixed...)
>>   b) not setting CLOEXEC on every fd is an application bug (with the
>> exception of the specific few fd's you actually want inherited)
>>   c) iptables does occasionally fork/exec (to load modules), for
>> example "/sbin/modprobe ip6_tables -q", but also for match/target
>> revision compatibility checking, and when it does this it can call
>> modprobe with additional opened descriptors (for example sockfd insi=
de
>> of compatible_revision isn't closed before fork/exec modprobe) - thi=
s
>> is unclean, and could potentially cause security warnings (or even
>> issues?) since iptables and modprobe have different contexts.
>>=20
>> [fc14]# ls -alZ `which iptables`
>> lrwxrwxrwx. root root system_u:object_r:bin_t:s0       /sbin/iptable=
s
>> -> iptables-multi
>> [fc14]# ls -alZ /sbin/iptables-multi
>> -rwxr-xr-x. root root system_u:object_r:iptables_exec_t:s0 /sbin/ipt=
ables-multi
>> [fc14]#  ls -alZ `which modprobe`
>> -rwxr-xr-x. root root system_u:object_r:insmod_exec_t:s0 /sbin/modpr=
obe
>>=20
>> I'm not going to claim I fully understand the security implications =
of
>> leaving the file descriptor open across exec, but there is clearly n=
o
>> reason to do so, hence the patch.
>
>This seems reasonable to me. Jan, any further objections?
>
No objections, they may be merged all.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
