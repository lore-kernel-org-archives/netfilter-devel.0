From: kaber@trash.net
Subject: [PATCH 0/6] extensions: IPv6 NAT extensions
Date: Wed, 23 Nov 2011 17:12:24 +0100
Message-ID: <1322064750-26744-1-git-send-email-kaber@trash.net>
Cc: kaber@trash.net, ulrich.weber@sophos.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55465 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1KWQMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:12:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain the IPv6 NAT extensions for my IPv6
NAT patchset posted on Monday. Nothing particulary interesting about
the patches ...


Patrick McHardy (6):
      extensions: convert NAT target to use nf_nat.h
      extensions: add IPv6 MASQUERADE extension
      extensions: add IPv6 SNAT extension
      extensions: add IPv6 DNAT target
      extensions: add IPv6 REDIRECT extension
      extensions: add IPv6 NETMAP extension

 extensions/libip6t_DNAT.c                          |  245 ++++++++++++++++++++
 extensions/libip6t_MASQUERADE.c                    |  150 ++++++++++++
 extensions/libip6t_NETMAP.c                        |   93 ++++++++
 extensions/libip6t_REDIRECT.c                      |  151 ++++++++++++
 extensions/libip6t_SNAT.c                          |  245 ++++++++++++++++++++
 extensions/libipt_DNAT.c                           |   36 ++--
 extensions/libipt_MASQUERADE.c                     |   32 ++--
 extensions/libipt_NETMAP.c                         |   18 +-
 extensions/libipt_REDIRECT.c                       |   34 ++--
 extensions/libipt_SAME.c                           |   18 +-
 extensions/libipt_SNAT.c                           |   36 ++--
 .../linux/netfilter/nf_conntrack_tuple_common.h    |   27 +++
 include/linux/netfilter/nf_nat.h                   |   33 +++
 include/linux/netfilter_ipv4/ipt_SAME.h            |    2 +-
 include/net/netfilter/nf_conntrack_tuple.h         |  114 ---------
 include/net/netfilter/nf_nat.h                     |   55 -----
 16 files changed, 1032 insertions(+), 257 deletions(-)

