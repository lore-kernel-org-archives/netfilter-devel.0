From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 00:32:38 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012180019381.29421@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37645 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab0LQXcj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:32:39 -0500
In-Reply-To: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-12-17 23:26, Jozsef Kadlecsik wrote:

>Hi,
>
>I'm happy to announce the new branch of ipset and release it's first=20
>element, ipset-5.0.

That is great to hear. There is a compile error with gcc 4.5
and the latest ipset git snapshot:

  CC     ipset.o
cc1: warnings being treated as errors
ipset.c: In function =E2=80=98check_allowed=E2=80=99:
ipset.c:344:26: error: comparison between =E2=80=98enum ipset_cmd=E2=80=
=99 and =E2=80=98enum ipset_adt=E2=80=99


The kernel/ directory is not compilable at all:

make -C /lib/modules/`uname -r`/build M=3D`pwd` all
make[1]: Entering directory `/usr/src/linux-2.6.36-rc8-34-obj/x86_64/de=
fault'
make -C /usr/src/linux-2.6.36-rc8-34 O=3D/usr/src/linux-2.6.36-rc8-34-o=
bj/x86_64/default/.=20
  CC [M]  /home/jengelh/code/ipset/kernel/ip_set.o
kernel/ip_set.c:31:50: error: expected expression before =E2=80=98;=E2=80=
=99 token

^ CONFIG_IP_SET_MAX not defined


kernel/ip_set.c: In function =E2=80=98start_msg=E2=80=99:
kernel/ip_set.c:735:40: error: =E2=80=98NFNL_SUBSYS_IPSET=E2=80=99 unde=
clared (first use in this function)

^ Neither is this, but this was to be expected. We should really
make this constant available in the Linux kernel so that people
are able to compile the out-of-tree ipset until it gets in.

(I hear this issue would not have happened would we have used genetlink=
!
*nudges pablo* ;-)


kernel/ip_set.c: At top level:
kernel/ip_set.c:1633:3: warning: initialization from incompatible point=
er type

^ This is due to NFNL_CB_CONST not being set.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
