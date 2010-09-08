From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.9.0 release
Date: Wed, 08 Sep 2010 11:40:58 +0200
Message-ID: <4C875A2A.6030206@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020806040805080003060403"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab0IHJlH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:41:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020806040805080003060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents libnetfilter_conntrack-0.9.0

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes two fixes and the infrastructure to generate API
documentation in doxygen format. ChangeLog is also attached for more
details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Core Team.

--------------020806040805080003060403
Content-Type: text/plain;
 name="changes-libnetfilter_conntrack-0.9.0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-libnetfilter_conntrack-0.9.0.txt"

Pablo Neira Ayuso (5):
      ct: fix regression with helpers for Linux kernel >= 2.6.34
      build: add libtool m4 support
      src: convert documentation from kerneldoc to doxygen format
      ct: fix EINVAL if not TCP attributes are set for Linux kernel <= 2.6.25
      build: bump version to 0.9.0


--------------020806040805080003060403--
