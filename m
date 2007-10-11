From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Thu, 11 Oct 2007 18:44:03 +0200 (MEST)
Message-ID: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXJKQoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:44:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following are two netfilter fixes, adding missing IPv6 module aliases
to a few matches and targets and fixing TCP conntrack connection
reopening. I'll also push the conntrack patch to -stable once it
hits upstream.

Please apply. thanks.


 net/netfilter/nf_conntrack_proto_tcp.c |   35 ++++++++++++-------------------
 net/netfilter/xt_CLASSIFY.c            |    1 +
 net/netfilter/xt_CONNMARK.c            |    1 +
 net/netfilter/xt_NOTRACK.c             |    1 +
 net/netfilter/xt_connbytes.c           |    1 +
 net/netfilter/xt_connmark.c            |    1 +
 net/netfilter/xt_dccp.c                |    1 +
 net/netfilter/xt_sctp.c                |    1 +
 net/netfilter/xt_tcpmss.c              |    1 +
 9 files changed, 22 insertions(+), 21 deletions(-)

Jan Engelhardt (1):
      [NETFILTER]: x_tables: add missing ip6t_modulename aliases

Jozsef Kadlecsik (1):
      [NETFILTER]: nf_conntrack_tcp: fix connection reopening
