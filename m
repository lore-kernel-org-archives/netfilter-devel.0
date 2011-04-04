From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/17] mark newly opened fds as FD_CLOEXEC (close on exec)
Date: Mon, 04 Apr 2011 14:58:28 +0200
Message-ID: <4D99C074.5040803@trash.net>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>	<1301632053-3694-2-git-send-email-zenczykowski@gmail.com>	<alpine.LNX.2.01.1104011130430.10168@obet.zrqbmnf.qr> <BANLkTinwDu8MkeoNyHh9e6p1S69DqFEZGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51738 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1DDM6h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:58:37 -0400
In-Reply-To: <BANLkTinwDu8MkeoNyHh9e6p1S69DqFEZGQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.04.2011 23:34, Maciej =C5=BBenczykowski wrote:
>> Redhat still has not given a reason as to why this is needed.
>=20
> I believe:
>   a) the fact CLOEXEC isn't the default on new fd's is a (UNIX/POSIX)
> API bug (which of course can't be fixed...)
>   b) not setting CLOEXEC on every fd is an application bug (with the
> exception of the specific few fd's you actually want inherited)
>   c) iptables does occasionally fork/exec (to load modules), for
> example "/sbin/modprobe ip6_tables -q", but also for match/target
> revision compatibility checking, and when it does this it can call
> modprobe with additional opened descriptors (for example sockfd insid=
e
> of compatible_revision isn't closed before fork/exec modprobe) - this
> is unclean, and could potentially cause security warnings (or even
> issues?) since iptables and modprobe have different contexts.
>=20
> [fc14]# ls -alZ `which iptables`
> lrwxrwxrwx. root root system_u:object_r:bin_t:s0       /sbin/iptables
> -> iptables-multi
> [fc14]# ls -alZ /sbin/iptables-multi
> -rwxr-xr-x. root root system_u:object_r:iptables_exec_t:s0 /sbin/ipta=
bles-multi
> [fc14]#  ls -alZ `which modprobe`
> -rwxr-xr-x. root root system_u:object_r:insmod_exec_t:s0 /sbin/modpro=
be
>=20
> I'm not going to claim I fully understand the security implications o=
f
> leaving the file descriptor open across exec, but there is clearly no
> reason to do so, hence the patch.

This seems reasonable to me. Jan, any further objections?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
