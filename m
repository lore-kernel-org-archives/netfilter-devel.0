From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/14] Misc improvements and bugfixes
Date: Sun, 23 Mar 2008 17:25:08 +0100
Message-ID: <1206289522679-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55039 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752058AbYCWQZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:24 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JdT0c-0002Bj-Fv
	for netfilter-devel@vger.kernel.org; Sun, 23 Mar 2008 17:25:22 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset contains some code cleaning and two structural changes.

The first four patches are code cleaning:
 * Fix SQL reconnection algorithm.
 * Suppress ip_as_string configuration variable.
 * Fix type of raw.mac_len key in NFLOG.
 * Fix type of raw.mac_len key in ULOG.

The next set is more interesting as it introduces handling of MAC address
via a dedicated module named MAC2STR. Source hardware address is now stored
in a dedicated table of the MySQL and pgSQL databases.

Patches which implement this modification are:
 * New MAC2STR plugin for hwmac address conversion.
 * MAC address handling in MySQL output plugin.
 * MAC address handling in PgSQL output plugin.

The next set of patches try to solve a classical netfilter logging problem. As
logging is not a verdict, it is not possible to know in userspace if a packet
has been accepted or dropped. A frequent workaround is to use the prefix of the
ULOG or NFLOG target to indicate the decision taken on the packet.

The idea behind this patchset is to dedicate a group (and a plugin instance in
ulogd2) to accepted packets and an other instance to dropped packets. To 
differentiate the instances a new option, state, has been added to NFLOG and
ULOG plugins. Default value of the option is 0 which is NF_DROP value.

The value of the option is sent to the output module as "raw.state" key. This
value is stored in a dedicated table of the PgSQL and MySQL output modules.

This modification is implemented in the following patches:
 * Add state option to NFLOG input plugin.
 * Add state support to MySQL schema.
 * Add state option to ULOG input plugin.
 * Add state support to PGSQL output module.

The remaining patches are :
 * Add hook output to ULOG input module.
 * Update default configuration to fit last changes.
 * Fix computation of length of mac address.

Patchset statistics :
 doc/mysql-ulogd2.sql              |   78 +++++++++++++++-----------
 doc/pgsql-ulogd2.sql              |   59 +++++++++++++++++---
 filter/Makefile.am                |    6 ++-
 filter/ulogd_filter_MAC2STR.c     |  111 +++++++++++++++++++++++++++++++++++++
 include/ulogd/db.h                |   13 ++---
 input/packet/ulogd_inppkt_NFLOG.c |   26 +++++++-
 input/packet/ulogd_inppkt_ULOG.c  |   33 ++++++++++-
 ulogd.conf.in                     |   10 +++-
 util/db.c                         |   20 ++----
 util/printpkt.c                   |    2 +-
 10 files changed, 286 insertions(+), 72 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
