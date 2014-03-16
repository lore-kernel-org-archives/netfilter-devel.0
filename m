From: "M.G." <mg887@yahoo.com>
Subject: xt_CHAOS - PDE_DATA compilation error
Date: Sun, 16 Mar 2014 08:53:34 -0700 (PDT)
Message-ID: <1394985214.54868.YahooMailNeo@web121203.mail.ne1.yahoo.com>
Reply-To: "M.G." <mg887@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm47.bullet.mail.ne1.yahoo.com ([98.138.120.54]:42093 "EHLO
	nm47.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431AbaCPP4Z convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2014 11:56:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=A0
Today at 1:49 PM=20
Hello Everyone,


in Centos 6 x64 with kernel 2.6.32-431.3.1.el6.centos.plus.x86_64  I ha=
ve compilation error with  conflicting types for PDE_DATA.
How to fix it ?
Is it possible to exclude this xt_CHAOS module from compilation ?




make all-recursive
make[1]: Entering directory `/root/xtables-addons-2.4'
Making all in extensions
make[2]: Entering directory `/root/xtables-addons-2.4/extensions'
Xtables-addons 2.4 - Linux 2.6.32-431.5.1.el6.centos.plus.x86_64
if [ -n "/lib/modules/2.6.32-431.3.1.el6.centos.plus.x86_64/build" ]; t=
hen make -C /lib/modules/2.6.32-431.3.1.el6.centos.plus.x86_64/build M=3D=
/root/xtables-addons-2.4/extensions modules; fi;
make[3]: Entering directory `/usr/src/kernels/2.6.32-431.5.1.el6.centos=
=2Eplus.x86_64'
CC [M] /root/xtables-addons-2.4/extensions/xt_CHAOS.o
In file included from /root/xtables-addons-2.4/extensions/compat_xtable=
s.h:7,
from /root/xtables-addons-2.4/extensions/xt_CHAOS.c:24:
/root/xtables-addons-2.4/extensions/compat_xtnu.h:16: warning: =E2struc=
t xt_action_param=E2 declared inside parameter list
/root/xtables-addons-2.4/extensions/compat_xtnu.h:16: warning: its scop=
e is only this definition or declaration, which is probably not what yo=
u want
/root/xtables-addons-2.4/extensions/compat_xtnu.h:31: warning: =E2struc=
t xt_action_param=E2 declared inside parameter list
In file included from /root/xtables-addons-2.4/extensions/xt_CHAOS.c:24=
:
/root/xtables-addons-2.4/extensions/compat_xtables.h:12:3: warning: #wa=
rning Kernels below 3.7 not supported.
In file included from /root/xtables-addons-2.4/extensions/xt_CHAOS.c:24=
:
/root/xtables-addons-2.4/extensions/compat_xtables.h:54: error: expecte=
d declaration specifiers or =E2...=E2 before =E2kuid_t=E2
/root/xtables-addons-2.4/extensions/compat_xtables.h:54: error: expecte=
d declaration specifiers or =E2...=E2 before =E2kgid_t=E2
/root/xtables-addons-2.4/extensions/compat_xtables.h: In function =E2pr=
oc_set_user=E2:
/root/xtables-addons-2.4/extensions/compat_xtables.h:56: error: =E2uid=E2=
 undeclared (first use in this function)
/root/xtables-addons-2.4/extensions/compat_xtables.h:56: error: (Each u=
ndeclared identifier is reported only once
/root/xtables-addons-2.4/extensions/compat_xtables.h:56: error: for eac=
h function it appears in.)
/root/xtables-addons-2.4/extensions/compat_xtables.h:57: error: =E2gid=E2=
 undeclared (first use in this function)
/root/xtables-addons-2.4/extensions/compat_xtables.h: At top level:
/root/xtables-addons-2.4/extensions/compat_xtables.h:60: error: conflic=
ting types for =E2PDE_DATA=E2
include/linux/proc_fs.h:328: note: previous definition of =E2PDE_DATA=E2=
 was here
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:49: warning: =E2struct x=
t_action_param=E2 declared inside parameter list
/root/xtables-addons-2.4/extensions/xt_CHAOS.c: In function =E2xt_chaos=
_total=E2:
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:51: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:60: error: storage size =
of =E2local_par=E2 isn=E2t known
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:61: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:62: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:62: warning: left-hand o=
perand of comma expression has no effect
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:63: warning: left-hand o=
perand of comma expression has no effect
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:60: warning: unused vari=
able =E2local_par=E2
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:76: error: storage size =
of =E2local_par=E2 isn=E2t known
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:77: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:78: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:79: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:81: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:82: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:76: warning: unused vari=
able =E2local_par=E2
/root/xtables-addons-2.4/extensions/xt_CHAOS.c: At top level:
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:88: warning: =E2struct x=
t_action_param=E2 declared inside parameter list
/root/xtables-addons-2.4/extensions/xt_CHAOS.c: In function =E2chaos_tg=
=E2:
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:98: error: dereferencing=
 pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:102: error: storage size=
 of =E2local_par=E2 isn=E2t known
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:103: error: dereferencin=
g pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:104: error: dereferencin=
g pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:105: error: dereferencin=
g pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:102: warning: unused var=
iable =E2local_par=E2
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:114: error: dereferencin=
g pointer to incomplete type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:115: warning: passing ar=
gument 2 of =E2xt_chaos_total=E2 from incompatible pointer type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:49: note: expected =E2co=
nst struct xt_action_param *=E2 but argument is of type =E2const struct=
 xt_action_param *=E2
/root/xtables-addons-2.4/extensions/xt_CHAOS.c: At top level:
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:145: warning: initializa=
tion from incompatible pointer type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:146: warning: initializa=
tion from incompatible pointer type
/root/xtables-addons-2.4/extensions/xt_CHAOS.c: In function =E2chaos_tg=
_init=E2:
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:155: error: implicit dec=
laration of function =E2xt_request_find_match=E2
/root/xtables-addons-2.4/extensions/xt_CHAOS.c:155: warning: assignment=
 makes pointer from integer without a cast
make[4]: *** [/root/xtables-addons-2.4/extensions/xt_CHAOS.o] Error 1
make[3]: *** [_module_/root/xtables-addons-2.4/extensions] Error 2
make[3]: Leaving directory `/usr/src/kernels/2.6.32-431.5.1.el6.centos.=
plus.x86_64'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/root/xtables-addons-2.4/extensions'

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
