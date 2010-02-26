From: Hari Hendaryanto <hari.h@csmcom.com>
Subject: xtables-addons searching libipt_*.so instead of libxt_*.so
Date: Fri, 26 Feb 2010 07:48:28 +0700
Message-ID: <4B871A5C.5010409@csmcom.com>
Reply-To: hari.h@csmcom.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from outgoing.corp.3g-net.net ([202.127.97.239]:41402 "EHLO
	outgoing.corp.3g-net.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934786Ab0BZAyb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:54:31 -0500
Received: from smtp.corp.3g-net.net (smtp.corp.3g-net.net [202.127.97.230])
	by dev.corp.3g-net.net (Postfix) with ESMTP id 3003C23097
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Feb 2010 07:48:27 +0700 (WIT)
Received: from [192.168.200.113] (ns1.ipv6.kutukupret.com [202.127.98.148])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.corp.3g-net.net (Postfix) with ESMTPSA id 2420724FC6
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Feb 2010 07:48:40 +0700 (WIT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was recently build xtables-addons-1.23

my  platform:
fedora 12 x86_64
kernel 2.6.31.12-174.2.22.fc12.x86_64
iptables 1.4.6-2.fc12.x86_64

I configure xtables with

./configure --with-kbuild=/lib/modules/`uname -r`/build 
--with-xtlibdir=/lib64/xtables
make
make install

it was compiled cleanly
no error produce until final step.

when i try to load match, i.e geoip match i found this error

iptables v1.4.6: Couldn't load match 
`geoip':/lib64/xtables/libipt_geoip.so: cannot open shared object file: 
No such file or directory

Try `iptables -h' or 'iptables --help' for more information.

i've check /lib64/xtables and i see libxt_geoip.so is there

why iptables search /lib64/xtables/libipt_geoip.so not 
/lib64/xtables/libxt_geoip.so ?

thanks in advance
