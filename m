From: pablo@netfilter.org
Subject: [PATCH 0/3] ulogd2 supports nfacct infrastructure
Date: Wed, 22 Feb 2012 13:33:30 +0100
Message-ID: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50042 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2BVMdt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:33:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

The upcoming kernel will contain the nfacct infrastructure:

http://lwn.net/Articles/473998/

This patchset contains the support for ulogd2. It also contains the
GPRINT output plugin, that is a generic output in comma-separated
key-value format.

I pushed the patches to git.netfilter.org, if you find any issue,
please send me follow-up patches and I'll apply them.

Thanks!

Pablo Neira Ayuso (3):
  output: add GPRINT plugin
  input: add nfacct plugin
  src: add example use of GPRINT to ulogd.conf.in configuration file

 configure.ac                             |    4 +
 include/Makefile.am                      |    2 +-
 include/linux/Makefile.am                |    2 +
 include/linux/netfilter/Makefile.am      |    2 +
 include/linux/netfilter/nfnetlink_acct.h |   36 ++++
 input/Makefile.am                        |    2 +-
 input/sum/Makefile.am                    |    8 +
 input/sum/ulogd_inpflow_NFACCT.c         |  265 +++++++++++++++++++++++++++++
 output/Makefile.am                       |    5 +-
 output/ulogd_output_GPRINT.c             |  270 ++++++++++++++++++++++++++++++
 ulogd.conf.in                            |   21 ++-
 11 files changed, 611 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/Makefile.am
 create mode 100644 include/linux/netfilter/Makefile.am
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 input/sum/Makefile.am
 create mode 100644 input/sum/ulogd_inpflow_NFACCT.c
 create mode 100644 output/ulogd_output_GPRINT.c

-- 
1.7.7.3

