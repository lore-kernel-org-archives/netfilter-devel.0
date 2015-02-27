From: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Subject: [PATCHv3] ebtables: Add kernel headers needed from v3.16
Date: Fri, 27 Feb 2015 11:54:09 +0000
Message-ID: <1425038050-31511-1-git-send-email-pedro.alvarez@codethink.co.uk>
References: <54EFA21A.5090507@codethink.co.uk>
Cc: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36474 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbB0LyW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Feb 2015 06:54:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTP id BF2DD46099C
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Feb 2015 11:54:20 +0000 (GMT)
In-Reply-To: <54EFA21A.5090507@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes ebtables build with new kernel headers (See commit message)

v3:
 * Don't add filter.h

v2
 * Just add netfilter_bridge headers, types.h and filter.h


Pedro Alvarez (1):
  Add kernel headers needed from v3.16

 include/linux/netfilter_bridge.h              | 27 +++++++++++
 include/linux/netfilter_bridge/ebt_802_3.h    | 63 ++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_among.h    | 64 +++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_arp.h      | 36 +++++++++++++++
 include/linux/netfilter_bridge/ebt_arpreply.h | 10 +++++
 include/linux/netfilter_bridge/ebt_ip.h       | 44 ++++++++++++++++++
 include/linux/netfilter_bridge/ebt_ip6.h      | 50 +++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_limit.h    | 24 ++++++++++
 include/linux/netfilter_bridge/ebt_log.h      | 20 +++++++++
 include/linux/netfilter_bridge/ebt_mark_m.h   | 16 +++++++
 include/linux/netfilter_bridge/ebt_mark_t.h   | 23 ++++++++++
 include/linux/netfilter_bridge/ebt_nat.h      | 13 ++++++
 include/linux/netfilter_bridge/ebt_nflog.h    | 23 ++++++++++
 include/linux/netfilter_bridge/ebt_pkttype.h  | 12 +++++
 include/linux/netfilter_bridge/ebt_redirect.h | 10 +++++
 include/linux/netfilter_bridge/ebt_stp.h      | 46 +++++++++++++++++++
 include/linux/netfilter_bridge/ebt_ulog.h     | 38 ++++++++++++++++
 include/linux/netfilter_bridge/ebt_vlan.h     | 22 +++++++++
 include/linux/types.h                         | 51 +++++++++++++++++++++
 19 files changed, 592 insertions(+)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebt_802_3.h
 create mode 100644 include/linux/netfilter_bridge/ebt_among.h
 create mode 100644 include/linux/netfilter_bridge/ebt_arp.h
 create mode 100644 include/linux/netfilter_bridge/ebt_arpreply.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ip.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ip6.h
 create mode 100644 include/linux/netfilter_bridge/ebt_limit.h
 create mode 100644 include/linux/netfilter_bridge/ebt_log.h
 create mode 100644 include/linux/netfilter_bridge/ebt_mark_m.h
 create mode 100644 include/linux/netfilter_bridge/ebt_mark_t.h
 create mode 100644 include/linux/netfilter_bridge/ebt_nat.h
 create mode 100644 include/linux/netfilter_bridge/ebt_nflog.h
 create mode 100644 include/linux/netfilter_bridge/ebt_pkttype.h
 create mode 100644 include/linux/netfilter_bridge/ebt_redirect.h
 create mode 100644 include/linux/netfilter_bridge/ebt_stp.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ulog.h
 create mode 100644 include/linux/netfilter_bridge/ebt_vlan.h
 create mode 100644 include/linux/types.h

-- 
2.1.4

