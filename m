From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.2
Date: Mon, 13 Oct 2008 14:56:29 +0200
Message-ID: <48F3457D.1070909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010909070205080500070106"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	netfilter-announce@lists.netfilter.org,
	netfilter-cor
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYJMM4d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:56:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010909070205080500070106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam presents:

     iptables version 1.4.2

This release supports all new features present in the 2.6.27 kernel.

The most significant change since version 1.4.1 are the scalability
improvements from Jesper Dangaard Brouer. Besides that, we have multiple
manpage updates from Jan Engelhardt, the usual iptables-save formatting
fixes, ip6tables --goto support, string match case insensitive matching
support and assorted cleanups and minor changes. See the changelog for
more details.

Version 1.4.2 can be obtained from (please note that as
usual, the website rebuild is still in progress):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy firewalling!

--------------010909070205080500070106
Content-Type: text/plain;
 name="changes-iptables-1.4.1-1.4.2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-1.4.2.txt"

Henrik Nordstrom (1):
      iptables: fix printing of line numbers with --line-numbers arg

Jan Engelhard (1):
      build: fix iptables-static build

Jan Engelhardt (35):
      ip6tables: fix printing of ipv6 network masks
      build: fix `make install` when --disable-shared is used
      iprange: kernel flags were not set
      build: change equailty test for old bash
      build: ip6.h is not required
      libxt_TOS: make sure --set-tos value/mask is recognized
      build: quote variables in release.sh
      build: various changes to release.sh
      manpages: various updates
      build: do not install ip{,6}tables.h
      Merge branch 'master' of vishnu.netfilter.org:/data/git/iptables
      manpages: name and markup fixes
      src: remove dependency on libiptc headers
      src: drop libiptc from installation
      iptables-restore: fix segmentation fault with -tanything
      libxt_recent: do not allow both --set and --rttl
      Put xtables.c into its own library, libxtables.so
      manpages: correct erroneous markup
      physdev: remove extra space in output
      Warn about use of DROP in nat table
      Synchronize invert flag order with manpages
      build: fix dependency tracking for xtables.h.in
      build: fix initext.c dependency
      manpages: add missing --rsource,--rdest options to libxt_recent.man
      manpages: add missing rateest documentation
      manpages: add missing rateest match documentation
      libxt_mac: flatten casts in libxt_mac
      libxt_iprange: fix option names
      src: use regular includes
      src: Update comments
      build: prepare make tarball for git 1.6.0
      libxt_recent: do allow --rttl for --update
      src: update comments part II
      build: run ldconfig on `make install`
      doc: remove mentions of NAT in ip6tables manpage

Jesper Dangaard Brouer (3):
      libiptc: minor bugfix
      libiptc: fix scalability performance issue during initial ruleset parsing
      libiptc: remove old fixme

Joonwoo Park (1):
      xt_string: string extension case insensitive matching

Pablo Sebastian Greco (1):
      mark: fix invalid iptables-save output

Patrick McHardy (6):
      v1.4.1.1
      Add simple release script
      release.sh: fix changelog filename
      v1.4.2-rc1
      manpages: fix another typo in tcp manpage
      v1.4.2

Phil Oester (3):
      iptables-save: fix hashlimit output
      libxt_dscp: fix save of negated dscp match rules
      src: Missing limits.h includes

Thomas Jacob (1):
      ip6tables: add --goto support

WANG Cong (1):
      manpages: Fix a typo in tcp man page


--------------010909070205080500070106--
