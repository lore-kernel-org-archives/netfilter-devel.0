From: Max Kellermann <max@duempel.org>
Subject: conntrackd won't start, "can't open multicast server!"
Date: Fri, 4 Jan 2008 09:10:07 +0100
Message-ID: <20080104081007.GA30807@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [78.31.71.42] ([78.31.71.42]:35228 "HELO duempel.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752910AbYADIQu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:16:50 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I am currently working on the official conntrack-tools 0.9.5 Debian
package; I have been maintaining the old "conntrack" program before.
The daemon will not start (with examples/stats/conntrackd.conf):

 host:~# /usr/sbin/conntrackd -C /etc/conntrackd.conf 
 Notice: StripNAT clause is obsolete. Please, remove it from conntrackd.conf
 ERROR: conntrackd cannot start, please check the logfile for more info
 host:~# tail /var/log/conntrackd.log 
 [Fri Jan  4 09:01:25 2008] (pid=9353) --- starting in console mode ---
 [Fri Jan  4 09:01:25 2008] (pid=9353) [FAIL] can't open multicast server!
 [Fri Jan  4 09:01:25 2008] (pid=9353) [FAIL] initialization failed

This machine has CONFIG_IP_MULTICAST=y, although I do not understand
why conntrackd needs a multicast socket in the stats mode.  strace
says:

 socket(PF_UNSPEC, SOCK_DGRAM, 0) = -1 EAFNOSUPPORT (Address family
 not supported by protocol)

Also, the example shipped in the 0.9.5 includes the obsolete
"StripNAT" option.

Max
