From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink 1.0.0 release
Date: Mon, 22 Jun 2009 20:08:38 +0200
Message-ID: <4A3FC8A6.4050904@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070303000004020308060001"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZFVSIv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:08:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070303000004020308060001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents:

  * libnfnetlink-1.0.0

libnfnetlink is the low-level library for netfilter related
kernel/userspace communication. It provides a generic messaging
infrastructure for in-kernel netfilter subsystems (such as
nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their
respective users and/or management tools in userspace.

See ChangeLog (file attached) for more details on this release. You can
download it from:

http://www.netfilter.org/projects/libnfnetlink/downloads.html
ftp://ftp.netfilter.org/pub/libnfnetlink/

Happy firewalling,
Pablo (on behalf of the Netfilter Core Team)

--------------070303000004020308060001
Content-Type: text/plain;
 name="changes-libnfnetlink-1.0.0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-libnfnetlink-1.0.0.txt"

Pablo Neira Ayuso (5):
      rtnl: fix wrong netlink group bindings in the interface API
      nfnl: add nfnl_portid() to get the Netlink portID of a socket
      include: add recently added Netlink socket options
      nfnl: add nfnl_addattr8() function
      nfnl: release libnfnetlink 1.0 version


--------------070303000004020308060001--
