From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.2-rc1
Date: Wed, 23 Jul 2008 15:39:47 +0200
Message-ID: <488734A3.3090401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060108020405080504090006"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter <netfilter@vger.kernel.org>,
	netfilter-announce@lists.netfilter.org,
	Netfilter Core Team <coreteam@net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34836 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYGWNjw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:39:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060108020405080504090006
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam presents:

     iptables version 1.4.2-rc1

The first release candidate for iptables 1.4.2.

The major change in this release are some scalability improvements
from Jesper Dangaard Brouer that should greatly increase ruleset
parsing performance with many chains. Besides that we have some
minor bugfixes, manpage updates, case insensitive string match
support (requires current -git kernel) and --goto support for
ip6tables.

Version 1.4.2-rc1 can be obtained from (please note that the
webpage hasn't been rebuilt yet, but will be sometime soon):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

The plan is to have a final 1.4.2 release shortly before 2.6.27
is released.

On behalf of the Netfilter Core Team.
Happy testing!

--------------060108020405080504090006
Content-Type: text/plain;
 name="changes-iptables-1.4.1.1-1.4.2-rc1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1.1-1.4.2-rc1.txt"

Jan Engelhardt (6):
      build: change equailty test for old bash
      build: ip6.h is not required
      libxt_TOS: make sure --set-tos value/mask is recognized
      build: quote variables in release.sh
      build: various changes to release.sh
      manpages: various updates

Jesper Dangaard Brouer (2):
      libiptc: minor bugfix
      libiptc: fix scalability performance issue during initial ruleset parsing

Joonwoo Park (1):
      xt_string: string extension case insensitive matching

Patrick McHardy (3):
      Add simple release script
      release.sh: fix changelog filename
      v1.4.2-rc1

Thomas Jacob (1):
      ip6tables: add --goto support


--------------060108020405080504090006--
