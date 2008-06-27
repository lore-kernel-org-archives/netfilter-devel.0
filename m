From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/6] rework mac address related issues
Date: Sat, 28 Jun 2008 01:02:54 +0200
Message-ID: <1214607780-31389-1-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56479 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764357AbYF0W5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:49 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This is a rewrite of my previous patchset following your suggestion to modify
input plugins instead of adding options the filter plugin.

The patches:
 "Specify that NFLOG only return mac saddr."
 "Output mac.saddr and mac.daddr in ULOG plugin."
modify the INPUT plugins to have them use raw.mac.saddr and raw.mac.daddr
fields. NFLOG code is trivial but ULOG patch is more difficult because ULOG
manually parses the hardware header to extract source and destination
addresses. This has raise the necessity to have an option to specify the length
of an hardware address in this plugin. The option is set by default to 6 which
is the default for almost all sort of interfaces.

Parsing in ULOG is completed by the patch:
 "Parse oob protocol in ULOG when possible."
It make ULOG parse the end of the hardware header to extrac the protocol.

The patch "Adapt MAC2STR to NFLOG and ULOG input key change." is a simple
adaptation of MAC2STR plugin to the new keys.

Last two patches:
 "Add destination mac_addr to database."
 "Sync PRINTPKT with mac modification."
sync output plugins with these modifications.

Patchset statistics:
 doc/mysql-ulogd2.sql              |   32 ++++++++++-------
 doc/pgsql-ulogd2.sql              |   17 +++++++--
 filter/ulogd_filter_MAC2STR.c     |   69 +++++++++++++++++++++++++-----------
 include/ulogd/printpkt.h          |    3 +-
 input/packet/ulogd_inppkt_NFLOG.c |   10 +++---
 input/packet/ulogd_inppkt_ULOG.c  |   48 +++++++++++++++++++------
 util/printpkt.c                   |   26 +++++++++++---
 7 files changed, 143 insertions(+), 62 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
