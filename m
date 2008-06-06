From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.1-rc3
Date: Fri, 06 Jun 2008 13:37:13 +0200
Message-ID: <48492169.6060300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080807070005090605060807"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	netfilter-announce@lists.netfilter.org,
	netfilter-cor
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41901 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYFFLhS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:37:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080807070005090605060807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam proudly presents:

     iptables version 1.4.1-rc3

The hopefully final release candidate for 1.4.1. Actually I already
wanted to have released 1.4.1 by now, but my notebook broke last
week during travel, which caused some delays.

This release candidate includes some minor fixes, manpage updates
and a full resync of the kernel header files to fix the build on
old systems that don't have all headers or miss the endian annotated
types. The header resync is the main reason for having this release
candidate since it has some risk of introducing new compilation
breakage. So even if you can't do real functional testing, please
verify whether it compiles cleanly for you.

Version 1.4.1-rc3 can be obtained from (please note that the
webpage hasn't been rebuilt yet, but will be shortly):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy testing!

--------------080807070005090605060807
Content-Type: text/plain;
 name="changes-iptables-1.4.1-rc3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-rc3.txt"

Jan Engelhardt (2):
      Update .gitignore
      build: check for missing feature files

Patrick McHardy (2):
      manpages: consistent syntax
      Resync header files with kernel

Thomas Jarosch (1):
      Add xtables version defines.

Yasuyuki Kozakai (1):
      Use s6_addr32 to access bits in int6_addr instead of incompatible name


--------------080807070005090605060807--
