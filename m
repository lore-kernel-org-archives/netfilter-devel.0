From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/5] New filter module MARK and misc fixes
Date: Fri,  6 Jun 2008 15:13:50 +0200
Message-ID: <1212758035-19538-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43248 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753959AbYFFNME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:12:04 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1K4blT-00059I-BX
	for netfilter-devel@vger.kernel.org; Fri, 06 Jun 2008 15:13:55 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset adds a new filter module MARK which can be used to log a subset
of messages by filtering on ct_mark or oob_mark. It also contains some
fixes: The treatment of plugin returning ULOGD_IRET_STOP was bad and it was 
impossible to use hex notation for integer in the configuration file.

It contains a code cleaning of all interpreter functions which were not using
correct return code.

Patchset statistics:
filter/Makefile.am                        |    5 +-
filter/raw2packet/ulogd_raw2packet_BASE.c |   50 ++++++------
filter/ulogd_filter_IFINDEX.c             |    2 +-
filter/ulogd_filter_IP2BIN.c              |    2 +-
filter/ulogd_filter_IP2STR.c              |    2 +-
filter/ulogd_filter_MAC2STR.c             |    4 +-
filter/ulogd_filter_MARK.c                |  119 +++++++++++++++++++++++++++++
filter/ulogd_filter_PRINTFLOW.c           |    2 +-
filter/ulogd_filter_PRINTPKT.c            |    2 +-
filter/ulogd_filter_PWSNIFF.c             |   12 ++--
output/pcap/ulogd_output_PCAP.c           |    6 +-
output/ulogd_output_IPFIX.c               |    4 +-
output/ulogd_output_LOGEMU.c              |    2 +-
output/ulogd_output_NACCT.c               |    2 +-
output/ulogd_output_OPRINT.c              |    2 +-
output/ulogd_output_SYSLOG.c              |    2 +-
src/conffile.c                            |    3 +-
ulogd.conf.in                             |    9 ++-
18 files changed, 180 insertions(+), 50 deletions(-)

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
