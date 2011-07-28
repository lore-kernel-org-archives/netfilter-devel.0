From: Peter Volkov <pva@gentoo.org>
Subject: xtables-addons: TEE extension fails to build
Date: Thu, 28 Jul 2011 14:46:38 +0400
Message-ID: <1311849998.19605.2.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60568 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1G1Kr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:47:29 -0400
Received: from [192.168.1.3] (ppp85-141-156-254.pppoe.mtu-net.ru [85.141.156.254])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: pva)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 3EBB01B4017
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2011 10:47:28 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. TEE extension fails to build in xtables-addons. It fails with the f=
ollowing error:

  CC [M]  /vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work=
/xtables-addons-1.37/extensions/xt_TEE.o
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c: In function =E2=80=98tee_tg_route4=E2=80=
=99:
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:46:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:47:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:48:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:50:2: warning: passing argument 2 of =E2=
=80=98ip_route_output_key=E2=80=99 from incompatible pointer type
include/net/route.h:131:61: note: expected =E2=80=98struct flowi4 *=E2=80=
=99 but argument is of type =E2=80=98struct rtable **=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:50:2: error: too many arguments to funct=
ion =E2=80=98ip_route_output_key=E2=80=99
include/net/route.h:131:61: note: declared here
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c: In function =E2=80=98tee_tg_route6=E2=80=
=99:
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:188:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:189:4: error: =E2=80=98struct flowi=E2=80=
=99 has no member named =E2=80=98nl_u=E2=80=99
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/work/xtables-a=
ddons-1.37/extensions/xt_TEE.c:195:2: warning: passing argument 3 of =E2=
=80=98ip6_route_output=E2=80=99 from incompatible pointer type
include/net/ip6_route.h:72:27: note: expected =E2=80=98struct flowi6 *=E2=
=80=99 but argument is of type =E2=80=98struct flowi *=E2=80=99
At top level:
cc1: warning: unrecognized command line option "-Wno-unused-but-set-var=
iable"
make[2]: *** [/vt/portage/tmp/portage/net-firewall/xtables-addons-1.37/=
work/xtables-addons-1.37/extensions/xt_TEE.o] Error 1
make[1]: *** [_module_/vt/portage/tmp/portage/net-firewall/xtables-addo=
ns-1.37/work/xtables-addons-1.37/extensions] Error 2
make[1]: Leaving directory `/vt/src/linux-2.6.39-gentoo-r3'
make: *** [modules] Error 2

--
Peter.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
