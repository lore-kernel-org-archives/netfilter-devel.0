From: Leonardo Rodrigues <leolistas@solutti.com.br>
Subject: problem with xtables-addons and CentOS 5.3
Date: Sun, 26 Apr 2009 14:26:28 -0300
Message-ID: <49F49944.3010800@solutti.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ML netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:39842 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZDZR0k convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:26:40 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1160092ywb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2009 10:26:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


    Hi,

    i'm having a hard time trying to compile xtables-addons 1.14 on a=20
CentOS 5.3 x86_64 box

    i'm using:

=2E/configure --prefix=3D/usr --with-xtables=3D/usr

    and make

    and the failure is:

make[2]: Entering directory `/tmp/xtables-addons-1.14/extensions'
  GEN      modules
make[3]: Entering directory=20
`/usr/src/kernels/2.6.18-128.1.6.el5.centos.plus-x86_64'
  CC [M]  /tmp/xtables-addons-1.14/extensions/compat_xtables.o
In file included from=20
/tmp/xtables-addons-1.14/extensions/compat_xtables.c:20:
/tmp/xtables-addons-1.14/extensions/compat_skbuff.h:29: error:=20
redefinition of 'skb_reset_network_header'
include/linux/skbuff.h:1016: error: previous definition of=20
'skb_reset_network_header' was here
/tmp/xtables-addons-1.14/extensions/compat_skbuff.h:33: error:=20
redefinition of 'tcp_hdr'
include/linux/tcp.h:169: error: previous definition of 'tcp_hdr' was he=
re
/tmp/xtables-addons-1.14/extensions/compat_skbuff.h:37: error:=20
redefinition of 'udp_hdr'
include/linux/udp.h:33: error: previous definition of 'udp_hdr' was her=
e
In file included from=20
/tmp/xtables-addons-1.14/extensions/compat_xtables.c:21:
/tmp/xtables-addons-1.14/extensions/compat_xtnu.h:9: error: redefinitio=
n=20
of typedef 'bool'
include/linux/types.h:36: error: previous declaration of 'bool' was her=
e
/tmp/xtables-addons-1.14/extensions/compat_xtnu.h:10: error:=20
redeclaration of enumerator 'false'
include/linux/stddef.h:16: error: previous definition of 'false' was he=
re
/tmp/xtables-addons-1.14/extensions/compat_xtnu.h:10: error:=20
redeclaration of enumerator 'true'
include/linux/stddef.h:18: error: previous definition of 'true' was her=
e
/tmp/xtables-addons-1.14/extensions/compat_xtables.c: In function=20
'xtnu_ip_route_me_harder':
/tmp/xtables-addons-1.14/extensions/compat_xtables.c:381: error: too=20
many arguments to function 'ip_route_me_harder'
make[4]: *** [/tmp/xtables-addons-1.14/extensions/compat_xtables.o] Err=
or 1
make[3]: *** [_module_/tmp/xtables-addons-1.14/extensions] Error 2
make[3]: Leaving directory=20
`/usr/src/kernels/2.6.18-128.1.6.el5.centos.plus-x86_64'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/tmp/xtables-addons-1.14/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/tmp/xtables-addons-1.14'
make: *** [all] Error 2
[root@centos53 xtables-addons-1.14]#



    any hint on compiling xtables-addons on CentOS 5.3 ???

    Thanks.

--=20


	Atenciosamente / Sincerily,
	Leonardo Rodrigues
	Solutti Tecnologia
	http://www.solutti.com.br

	Minha armadilha de SPAM, N=C3O mandem email
	gertrudes@solutti.com.br
	My SPAMTRAP, do not email it




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
