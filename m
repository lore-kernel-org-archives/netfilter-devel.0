From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Make/compile error for iptables-1.4.0rc1
Date: Fri, 16 Nov 2007 22:34:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
References: <1195245146.15945.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	yasuyuki@netfilter.org
To: Jesper Dangaard Brouer <jdb@comx.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbXKPVeU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:34:20 -0500
In-Reply-To: <1195245146.15945.50.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 21:32, Jesper Dangaard Brouer wrote:
>
>I get a compile/make error when compiling iptables-1.4.0rc1 and latest
>SVN revision (r7090).
>
>cc -O2 -Wall -Wunused -I"/lib/modules/2.6.18-5-686/build"/include -I"/lib/modules/2.6.18-5-686/source"/include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0rc1\"  -DIPT_LIB_DIR=\"/usr/lib/iptables\" -c -o iptables.o iptables.c
>iptables.c:207: error: 'XT_SO_GET_REVISION_MATCH' undeclared here (not in a function)
>iptables.c:208: error: 'XT_SO_GET_REVISION_TARGET' undeclared here (not in a function)
>make: *** [iptables.o] Error 1

In 7090, these lines have IPT_SO_GET_REVISION_xxx.

