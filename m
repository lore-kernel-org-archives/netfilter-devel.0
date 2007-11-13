From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 13 Nov 2007 11:55:40 +0100 (MET)
Message-ID: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41889 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbXKMKzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:55:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

these three patches fix a nf_nat memset error, leading to misbehaviour
when unloading and reloading the NAT module, a regression from the
bridge netfilter deferred hook removal causing double invocation of the
POSTROUTING hook for packets forwarded between two bridge devices and
consolidate the nf_sockopt code. I'll push the memset and bridge fixes
to -stable once they hit Linus' tree.

Please apply, thanks.


 net/bridge/br_netfilter.c        |    3 +
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 net/netfilter/nf_sockopt.c       |  106 ++++++++++++++++----------------------
 3 files changed, 48 insertions(+), 63 deletions(-)

Li Zefan (1):
      [NETFILTER]: nf_nat: fix memset error

Patrick McHardy (1):
      [NETFILTER]: bridge: fix double POSTROUTING hook invocation

Pavel Emelyanov (1):
      [NETFILTER]: Consolidate nf_sockopt and compat_nf_sockopt
