From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH v2 0/2] conntrack: Support flushing connections with given mark
Date: Wed, 24 Dec 2014 09:57:09 +0100
Message-ID: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaLXI5T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:57:19 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so10957618wgh.31
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Dec 2014 00:57:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for selective flushing of conntrack mappings. By adding
CTA_MARK and CTA_MARK_MASK to a delete-message, the mark is checked before a
connection is deleted while flushing.

One use-case for this feature is on multihomed systems using policy routing
(based on marks). If say for example the next-hop's internet connection goes
down, it is desirable to be able to "reset" all connections using that
interface. However, since the device might be communicating with other devices
on the local network, it is not desitable to set the interface as down.

An iptables-rules can then be used to match not NEW connections without a mark.
generating for example a TCP RST.

v1->v2:
* Fix typo in commit.
* Reduce ifdef pollution by moving filter check to a separate function, used in
  both dump and flush path.
* Consolidate code for setting up flush in a separate function, remove use of
  nf_conntrack_flush_report.

Kristian Evensen (2):
  conntrack: Flush connections with a given mark
  conntrack: Remove nf_ct_conntrack_flush_report

 include/net/netfilter/nf_conntrack.h |  2 --
 net/netfilter/nf_conntrack_core.c    |  6 ----
 net/netfilter/nf_conntrack_netlink.c | 57 ++++++++++++++++++++++++++++--------
 3 files changed, 45 insertions(+), 20 deletions(-)

-- 
2.1.0

