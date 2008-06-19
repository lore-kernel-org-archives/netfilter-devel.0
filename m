From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/6] Fix difference between ULOG and NFLOG
Date: Thu, 19 Jun 2008 14:23:01 +0200
Message-ID: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60842 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbYFSMXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset contains modification of ulogd2 and kernel relative to
a problem to hardware address logging.
HW address logging is different between ULOG and NFLOG:
 * NFLOG sends MAC address in userspace (dev_parse_header content)
 * ULOG sends complete link header (skb_mac_header content)

The kernel patch modifies NFLOG to have it log the whole
hardware header like ULOG.

Ulogd2 patches contains some code cleaning and a rework of MAC2STR plugin
which implements the support of actual NFLOG and ULOG logging.

Ulogd2 patchset statistics:
 doc/mysql-ulogd2.sql              |   32 ++++++-----
 doc/pgsql-ulogd2.sql              |   13 +++-
 filter/ulogd_filter_MAC2STR.c     |  117 +++++++++++++++++++++++++++++++------
 input/flow/ulogd_inpflow_NFCT.c   |   38 ++++++------
 input/packet/ulogd_inppkt_NFLOG.c |   87 ++++++++++++++-------------
 input/packet/ulogd_inppkt_ULOG.c  |   70 +++++++++++-----------
 ulogd.conf.in                     |    9 +++
 7 files changed, 234 insertions(+), 132 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
