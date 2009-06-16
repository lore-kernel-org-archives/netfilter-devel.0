From: Jan Engelhardt <jengelh@medozas.de>
Subject: [ANNOUNCE] Xtables-addons 1.17 released
Date: Tue, 16 Jun 2009 17:11:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906161700210.29921@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Following the iptables 1.4.4 release, which fixes the ipset match/target 
after changes were made to ipset 3.0,
here is the next iteration of Xtables-addons.

I appreciate everybody telling me that the (now-)previous version did 
not fully compile with Linux kernel 2.6.30. But let it be known that 
such should be posted to the mailing list, in the hope that doing so 
reduces the number of copies I'm told compilation does not work with 
kernels that came out of Linus' Manufacturing Inc. just seconds ago :)

Boilerplate:
http://downloads.sf.net/xtables-addons/xtables-addons-1.17.tar.bz2 {,.asc}
GIT:
git://xtables-addons.git.sf.net/gitroot/xtables-addons
Shortlog:

Marek Michalkiewicz (1):
      IPMARK: print missing --shift parameter

kd6lvw (2):
      build: use readlink -f in extensions/ipset/
      build: support for Linux 2.6.30

