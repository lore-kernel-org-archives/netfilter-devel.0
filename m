From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_log 0.0.15 release
Date: Fri, 15 Aug 2008 22:24:43 +0200
Message-ID: <48A5E60B.2000306@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040801090901060601070509"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51968 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754121AbYHOVna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:43:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040801090901060601070509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

  * libnetfilter_log-0.0.15

libnetfilter_log is a userspace library providing interface to packets
that have been logged by the kernel packet filter. It is is part of a
system that deprecates the old syslog/dmesg based packet logging. See
ChangeLog for more details.

You can download them from:

http://www.netfilter.org
ftp://ftp.netfilter.org

Enjoy,
Pablo - on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040801090901060601070509
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Eric Leblond (1):
      Add parsing function for raw hardware header

Pablo Neira Ayuso (2):
      conditional compilation of testsuite utils
      bump version to 0.0.15


--------------040801090901060601070509--
