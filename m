From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_cthelper 1.0.0 release
Date: Mon, 8 Oct 2012 17:15:39 +0200
Message-ID: <20121008151539.GA1647@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2JHPPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:15:46 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_cthelper 1.0.0

This library provides the infrastructure for the user-space helper
infrastructure available since the Linux kernel 3.6.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_cthelper/downloads.html
ftp://ftp.netfilter.org/pub/libnetfilter_cthelper/

Have fun!

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_cthelper-1.0.0.txt"

Jan Engelhardt (1):
      build: remove unnecessary pkgconfig->config.status dependency

Pablo Neira Ayuso (8):
      initial import
      cthelper: add NFCTH_ATTR_PRIV_DATA_LEN
      include: update NFNL_SUBSYS_CTHELPER
      fix libnetfilter_cthelper.pc.in file
      src: add NFCTH_STATUS and other enhancements
      examples: fix nfct-helper-add example
      fix licensing terms
      bump version to 1.0.0


--/04w6evG8XlLl3ft--
