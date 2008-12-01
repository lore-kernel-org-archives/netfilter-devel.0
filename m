From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/18] Code cleaning, SCTP support, NFLOG logic fix
Date: Mon,  1 Dec 2008 22:35:58 +0100
Message-ID: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39288 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751566AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset is made of four parts.

First part is Pablo's work that I have completed. It cleans up
the current key assignation by introducing a new set of functions:
 * add ukey_* function for key assignation

Second part fixes a logic problem in NFLOG input plugin. System logging
(for instance invalid conntrack message) are done on group 0 queue for
all protocols. Thus a protocol dependant NFLOG plugin is stupid.
Furthermore, the nfnetlink message contains the protocol information. This
set of patch suppresses the addressfamily variable and modify NFLOG to 
only bind as system logging if group is 0:
 * Modify usage of nflog_bind_pf function.
 * Get rid of addressfamily variable in NFLOG input plugin
 * Document group 0 usage and suppress address_family

Third part adds support for SCTP in ulogd2. It contains a basic packet
parser and a support in all OUTPUT plugin:
 * Add SCTP support to BASE plugin.
 * SCTP support for PRINTPKT.
 * Add SCTP support to MySQL and PGSQL output.

Last part is code cleaning. It fixes some memory leak fixes and cleaning
of ulogd exit code.F or example,  fini function were defined for each module
but were never called:
 * Treat nice function return.
 * Fix stop function of NFCT plugin.
 * Don't free pluginstance when leaving
 * Fix minor memory leak in NFLOG plugin.
 * Call pluginstance stop function when exiting
 * Add SIGINT to list of terminal signal.
 * Unload plugins when quitting.
 * Introduce config_stop() function
 * Free stacks when exiting.
 * Fix memory leak in destructor_nfct().
 * Add valgrind compilation option.

This patch is build upon Pierre's last patchset.

Patchset statistics:
 doc/mysql-ulogd2.sql                       |   43 ++++-
 doc/pgsql-ulogd2.sql                       |   41 ++++-
 filter/raw2packet/ulogd_raw2packet_BASE.c  |  270 +++++++++++++--------------
 filter/raw2packet/ulogd_raw2packet_LOCAL.c |    7 +-
 filter/ulogd_filter_HWHDR.c                |   76 ++++----
 filter/ulogd_filter_IFINDEX.c              |   30 ++--
 filter/ulogd_filter_IP2BIN.c               |    9 +-
 filter/ulogd_filter_IP2STR.c               |   15 +-
 filter/ulogd_filter_MARK.c                 |    4 +-
 filter/ulogd_filter_PRINTFLOW.c            |    3 +-
 filter/ulogd_filter_PRINTPKT.c             |    3 +-
 filter/ulogd_filter_PWSNIFF.c              |   27 ++--
 include/ulogd/conffile.h                   |    3 +
 include/ulogd/printpkt.h                   |    2 +
 include/ulogd/ulogd.h                      |   68 +++++++-
 input/flow/ulogd_inpflow_NFCT.c            |  171 +++++++-----------
 input/packet/ulogd_inppkt_NFLOG.c          |  186 +++++++++-----------
 input/packet/ulogd_inppkt_ULOG.c           |   46 ++----
 output/pcap/ulogd_output_PCAP.c            |   11 +-
 output/ulogd_output_NACCT.c                |   34 ++--
 src/conffile.c                             |    4 +
 src/hash.c                                 |    6 +-
 src/ulogd.c                                |   76 ++++++++-
 ulogd.conf.in                              |   37 ++--
 util/printflow.c                           |   52 +++---
 util/printpkt.c                            |  163 +++++++++--------
 26 files changed, 768 insertions(+), 619 deletions(-)

BR,
--
Eric Leblond <eric@inl.fr>
