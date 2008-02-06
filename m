From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER 0/3] Netfilter fixes on top
Date: Wed, 6 Feb 2008 14:56:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51655 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYBFN4n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:56:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The patches iron out the new 2.6.25 interfaces to userspace and fix one 
calculation bug.

Please apply.

 include/linux/netfilter/xt_hashlimit.h |    1 -
 include/linux/netfilter/xt_sctp.h      |   84 ++++++++++--------------
 net/netfilter/xt_hashlimit.c           |    3 -
 net/netfilter/xt_iprange.c             |    2 +-
 4 files changed, 36 insertions(+), 54 deletions(-)

Jan Engelhardt (3):
      [NETFILTER]: xt_sctp: simplify xt_sctp.h
      [NETFILTER]: xt_hashlimit: remove unneeded struct member
      [NETFILTER]: xt_iprange: fix subtraction-based comparison
