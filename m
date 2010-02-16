From: Peter Volkov <pva@gentoo.org>
Subject: xtables-addons fails to build xt_ECHO
Date: Tue, 16 Feb 2010 23:03:13 +0300
Message-ID: <1266350593.11044.23.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53894 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0BPUDs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:03:48 -0500
Received: from [192.168.1.35] (unknown [77.246.104.171])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.gentoo.org (Postfix) with ESMTP id 888FD1B4023
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2010 20:03:47 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Attempt to build mod_ECHO in xtables_addons causes the following
failure:

if [ -n "/usr/src/linux" ]; then make -C /usr/src/linux M=/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions modules; fi;
make[1]: Entering directory `/usr/src/linux-2.6.32-gentoo-r5'
  CC [M]  /vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.o
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c: In function 'echo_tg4':
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:35: error: 'struct sk_buff' has no member named 'dst'
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:88: error: 'const struct sk_buff' has no member named 'dst'
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:89: error: 'struct sk_buff' has no member named 'dst'
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:89: error: 'const struct sk_buff' has no member named 'dst'
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:94: error: 'struct sk_buff' has no member named 'dst'
/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.c:98: error: 'struct sk_buff' has no member named 'dst'
make[2]: *** [/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions/xt_ECHO.o] Error 1
make[1]: *** [_module_/vt/portage/tmp/portage/net-firewall/xtables-addons-1.22/work/xtables-addons-1.22/extensions] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.32-gentoo-r5'
make: *** [modules] Error 2

Searching mailing list I've noticed patch that fixes this error:
http://www.spinics.net/lists/netfilter-devel/msg09981.html


Please apply,
-- 
Peter.

