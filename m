From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Fri, 30 Nov 2007 00:57:12 +0100 (MET)
Message-ID: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60347 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763516AbXK2X5N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:57:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Herbert,

these patches for 2.6.24 fix a number of netfilter bugs: a refcount leak in a
CONNMARK and CONNSECMARK error path, a network triggerable WARN_ON in the
IPv6 TCPMSS target and an endless loop caused by passing a zero-length pattern
to the string match.

Please apply, thanks.


 lib/textsearch.c               |    8 ++++++--
 net/netfilter/xt_CONNMARK.c    |   10 +++++-----
 net/netfilter/xt_CONNSECMARK.c |   10 +++++-----
 net/netfilter/xt_TCPMSS.c      |    4 +---
 4 files changed, 17 insertions(+), 15 deletions(-)

Jan Engelhardt (1):
      [NETFILTER]: fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

Pablo Neira Ayuso (1):
      [TEXTSEARCH]: Do not allow zero length patterns in the textsearch infrastructure

Patrick McHardy (1):
      [NETFILTER]: xt_TCPMSS: remove network triggerable WARN_ON
