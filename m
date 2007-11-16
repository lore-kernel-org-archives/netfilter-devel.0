From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: Make/compile error for iptables-1.4.0rc1
Date: Fri, 16 Nov 2007 21:32:26 +0100
Message-ID: <1195245146.15945.50.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: yasuyuki@netfilter.org
To: Netfilter Developers <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:36178 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbXKPU5m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:57:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Netfilter Developers

I get a compile/make error when compiling iptables-1.4.0rc1 and latest
SVN revision (r7090).

cc -O2 -Wall -Wunused -I"/lib/modules/2.6.18-5-686/build"/include -I"/lib/modules/2.6.18-5-686/source"/include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0rc1\"  -DIPT_LIB_DIR=\"/usr/lib/iptables\" -c -o iptables.o iptables.c
iptables.c:207: error: 'XT_SO_GET_REVISION_MATCH' undeclared here (not in a function)
iptables.c:208: error: 'XT_SO_GET_REVISION_TARGET' undeclared here (not in a function)
make: *** [iptables.o] Error 1

SVN blame on iptables.c line 207-208 says its changed by Yasuyuki
Kozakai with chainset 6920.
The strange thing about these lines is that they contain
IPT_SO_GET_REVISION_xxx and not XT_SO_GET_REVISION_xxx as the compiler
claims. Is some strange macro stuff going on here?

See you around!
-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
