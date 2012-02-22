From: Philip Prindeville <philipp@redfish-solutions.com>
Subject: Issues with 1.4.10 build of iptables/extensions
Date: Wed, 22 Feb 2012 15:05:59 -0700
Message-ID: <4F4566C7.2030401@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:56667 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387Ab2BVWGA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:06:00 -0500
Received: from macbook.redfish-solutions.com (macbook.redfish-solutions.com [192.168.1.17])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.5/8.14.5) with ESMTP id q1MM5xfB019878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2012 15:05:59 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Seeing the following:

make[5]: Entering directory `/home/philipp/openwrt-alix/build_dir/linux-x86_alix2/iptables-1.4.10/extensions'
if test -n "   "; then install -pm0755  "/home/philipp/openwrt-alix/build_dir/linux-x86_alix2/iptables-1.4.10/ipkg-install/usr/lib/iptables/"; fi;
install: missing destination file operand after `/home/philipp/openwrt-alix/build_dir/linux-x86_alix2/iptables-1.4.10/ipkg-install/usr/lib/iptables/'
Try `install --help' for more information.
make[5]: *** [install] Error 1

The problem is here:

targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
...
install: ${targets_install}
        @mkdir -p "${DESTDIR}${xtlibdir}";
        if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;

that should read:

install: ${targets_install}
        @mkdir -p "${DESTDIR}${xtlibdir}";
        if test -n "$(strip ${targets_install})"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;

