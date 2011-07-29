From: Peter Volkov <pva@gentoo.org>
Subject: net/netfilter/nf_nat.h header instalation
Date: Fri, 29 Jul 2011 13:37:40 +0400
Message-ID: <1311932260.21981.11.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45423 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab1G2Jif (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:38:35 -0400
Received: from [192.168.1.2] (ap.ran.gpi.ru [195.209.218.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: pva)
	by smtp.gentoo.org (Postfix) with ESMTPSA id A37C91B401B
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2011 09:38:34 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. Could you suggest solution for following problem:

miniupnpd [1] uses net/netfilter/nf_nat.h header and fails to build as
normally this header is not installed by kernel during header. But is
this correct?

As I found, iptables itself copies this kernel headers and bundles
together with sources for reasons outlined in [3]. Now for miniupnpd
distributions started to install  net/netfilter/*.h [4] [5]. I'm not
opposed to install this headers in Gentoo too, bug if this is user space
header shouldn't kernel install it?

[1] http://miniupnp.free.fr/files
[2] http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=771&start=15
[3]
http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.devel/36623
[4] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=541979
[5] https://qa.mandriva.com/show_bug.cgi?id=58007

--
Peter.

