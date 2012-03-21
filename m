From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec) [part 2]
Date: Wed, 21 Mar 2012 13:40:16 -0700
Message-ID: <CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
	<1332361663.9433.8.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43695 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303Ab2CUUkR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:40:17 -0400
Received: by vbbff1 with SMTP id ff1so671342vbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Mar 2012 13:40:16 -0700 (PDT)
In-Reply-To: <1332361663.9433.8.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

But that's a kernel feature, and I don't think we can rely on it being
present in iptables userspace (it has to be backwards compatible to
IMHO at least back to 2.6.9 if at all possible),
and adding the "try with flag, if fails, retry without flag and
manually set it" logic seems overkill.

I think such details only matter for multithreaded programs with exec r=
aces.
Which I don't believe to be the case here.

On Wed, Mar 21, 2012 at 1:27 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> On Wed, 2012-03-21 at 03:52 -0700, Maciej =C5=BBenczykowski wrote:
>> From: Maciej =C5=BBenczykowski <maze@google.com>
>>
>> This is iptables-1.4.11-cloexec.patch from Fedora 18 iptables source
>> rpm, in particular:
>> =C2=A0 http://kojipkgs.fedoraproject.org/packages/iptables/1.4.12.2/=
4.fc18/src/iptables-1.4.12.2-4.fc18.src.rpm
>>
>> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
>> ---
>> =C2=A0extensions/libxt_set.h | =C2=A0 =C2=A07 +++++++
>> =C2=A0libiptc/libiptc.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A08 +++++++=
+
>> =C2=A02 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
>> index 4ac84fa9c022..47c3f5b6f5d4 100644
>> --- a/extensions/libxt_set.h
>> +++ b/extensions/libxt_set.h
>> @@ -2,6 +2,7 @@
>> =C2=A0#define _LIBXT_SET_H
>>
>> =C2=A0#include <unistd.h>
>> +#include <fcntl.h>
>> =C2=A0#include <sys/types.h>
>> =C2=A0#include <sys/socket.h>
>> =C2=A0#include <errno.h>
>> @@ -23,6 +24,12 @@ get_version(unsigned *version)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 xtables_error(OTHER=
_PROBLEM,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Can't open socket to ipset.\n");
>>
>> + =C2=A0 =C2=A0 if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 xtables_error(OTHER_PROB=
LEM,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 "Could not set close on exec: %s\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 strerror(errno));
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 req_version.op =3D IP_SET_OP_VERSION;
>> =C2=A0 =C2=A0 =C2=A0 res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, &=
req_version, &size);
>> =C2=A0 =C2=A0 =C2=A0 if (res !=3D 0)
>> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
>> index 13e41d525f28..63965e738596 100644
>> --- a/libiptc/libiptc.c
>> +++ b/libiptc/libiptc.c
>> @@ -29,6 +29,8 @@
>> =C2=A0 * =C2=A0 - performance work: speedup initial ruleset parsing.
>> =C2=A0 * =C2=A0 - sponsored by ComX Networks A/S (http://www.comx.dk=
/)
>> =C2=A0 */
>> +#include <unistd.h>
>> +#include <fcntl.h>
>> =C2=A0#include <sys/types.h>
>> =C2=A0#include <sys/socket.h>
>> =C2=A0#include <stdbool.h>
>> @@ -1316,6 +1318,12 @@ TC_INIT(const char *tablename)
>> =C2=A0 =C2=A0 =C2=A0 if (sockfd < 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
>>
>> + =C2=A0 =C2=A0 if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "Could n=
ot set close on exec: %s\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 strerror(errno));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 abort();
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0retry:
>> =C2=A0 =C2=A0 =C2=A0 s =3D sizeof(info);
>>
>
> Looks fine, but since commit a677a039b (flag parameters: socket and
> socketpair) from Ulrich Drepper, we can pass SOCK_CLOEXEC directly in
> the socket() call, thus avoiding extra fcntl() call.
>
> Not relevant to iptables (opening this socket in iptables is not
> performance critical), but worth to mention for reference.
>
>
>



--=20
Maciej A. =C5=BBenczykowski
Kernel Networking Developer @ Google
1600 Amphitheatre Parkway, Mountain View, CA 94043
tel: +1 (650) 253-0062
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
