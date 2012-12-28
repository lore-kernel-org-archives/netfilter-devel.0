From: Eric Leblond <eric@regit.org>
Subject: [Ulogd PATCH 0/4] Implement filter for NFCT
Date: Fri, 28 Dec 2012 18:29:57 +0100
Message-ID: <1356715802-11572-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57962 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1RaS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:30:18 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1TodlA-0006vA-13
	for netfilter-devel@vger.kernel.org; Fri, 28 Dec 2012 18:30:16 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset implements filtering capability in NFCT input plugin. For
now this is only possible when NFCT is used in event mode as the
libnetfilter_conntrack library does not support filtering of dump.

It adds a set of variable t the configuration of a NFCT capture in
ulogd.conf:

# source ip of connection must belong to these networks
accept_src_filter=192.168.1.0/24,1:2::/64 
# destination ip of connection must belong to these networks
accept_dst_filter=192.168.1.0/24 
# layer 4 proto of connections
accept_proto_filter=tcp,sctp

Patchset statistics:
 include/ulogd/addr.h            |   18 +++
 input/flow/ulogd_inpflow_NFCT.c |  274 ++++++++++++++++++++++++++++++++-
 src/Makefile.am                 |    2 +-
 src/addr.c                      |  113 ++++++++++++++
 ulogd.conf.in                   |    5 +
 5 files changed, 408 insertions(+), 4 deletions(-)

BR,
--
Eric Leblond <eric@regit.org>
