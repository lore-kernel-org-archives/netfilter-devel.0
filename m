From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.98 release
Date: Sun, 14 Dec 2008 22:52:25 +0100
Message-ID: <49458019.201@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030209060903060402030803"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38376 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbYLNVwl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2008 16:52:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030209060903060402030803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.99.

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes a couple of minor fixes. See ChangeLog for more
details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers



--------------030209060903060402030803
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Pablo Neira Ayuso (6):
      automake: add missing stack.h to include/internal/Makefile.am
      version: bump to 0.0.99
      api: fix minor issues in the kerneldoc style documentation
      utils: fix wrong use of errno in example files
      headers: add CTA_NAT_SEQ_UNSPEC to linux_nfnetlink_conntrack.h
      build: do not inconditionally include TCP state into netlink message


--------------030209060903060402030803--
