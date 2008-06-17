From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.1.1
Date: Tue, 17 Jun 2008 17:22:10 +0200
Message-ID: <4857D6A2.104@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040308050806070008040603"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>,
	netfilt
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34608 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbYFQPWN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:22:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040308050806070008040603
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam presents:

     iptables version 1.4.1.1

This release is a pure bugfix release for regressions reported
against 1.4.1, fixing some mainly cosmetic problems in the
ruleset listing, installation problems with --disable-shared
and non-working --src-range/--dst-range parameters in the
iprange match.

Version 1.4.1.1 can be obtained from (please note that as
usual, the webpage hasn't been rebuilt yet, but will hopefully
be shortly):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy firewalling!


--------------040308050806070008040603
Content-Type: text/plain;
 name="changes-iptables-1.4.1-1.4.1.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-1.4.1.1"

Henrik Nordstrom (1):
      iptables: fix printing of line numbers with --line-numbers arg

Jan Engelhardt (3):
      ip6tables: fix printing of ipv6 network masks
      build: fix `make install` when --disable-shared is used
      iprange: kernel flags were not set

Patrick McHardy (1):
      v1.4.1.1


--------------040308050806070008040603--
