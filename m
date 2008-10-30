From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/02: netfilter fixes
Date: Thu, 30 Oct 2008 08:31:45 +0100 (MET)
Message-ID: <20081030073143.14487.24299.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53512 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYJ3Hbq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:31:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following two patches contain the GRE conntrack netns fix for an
oops on unload from Alexey and the preparatory patch, introducing
register_pernet_gen_subsys/unregister_pernet_gen_subsys.

Please apply, thanks.


 include/net/net_namespace.h            |    2 ++
 net/core/net_namespace.c               |   32 ++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_gre.c |    4 ++--
 3 files changed, 36 insertions(+), 2 deletions(-)

Alexey Dobriyan (2):
      netns: add register_pernet_gen_subsys/unregister_pernet_gen_subsys
      netfilter: nf_conntrack_proto_gre: switch to register_pernet_gen_subsys()
