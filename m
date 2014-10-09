From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] Netfilter fixes for net-next
Date: Thu,  9 Oct 2014 20:27:39 +0200
Message-ID: <1412879261-25045-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35834 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaJIS0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:26:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

This batch contains two fixes for what you have in your net-next,
they are:

1) Remove nf_send_reset6() from header file. This function now resides
   in the nf_reject_ipv6 module. Reported by Eric Dumazet.

2) Fix wrong NFT_REJECT_ICMPX_MAX definition and adjust code to fix
   errors reported by Dan Carpenter's static analysis tools.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 4e62ccd901062c532673f4fda16c484de2c3c8fc:

  Merge branch 'mlx4-next' (2014-10-06 01:04:21 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

for you to fetch changes up to f0d1f04f0a2f662b6b617e24d115fddcf6ef8723:

  netfilter: fix wrong arithmetics regarding NFT_REJECT_ICMPX_MAX (2014-10-07 20:16:31 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: kill nf_send_reset6() from include/net/netfilter/ipv6/nf_reject.h
      netfilter: fix wrong arithmetics regarding NFT_REJECT_ICMPX_MAX

 include/net/netfilter/ipv6/nf_reject.h   |  157 +-----------------------------
 include/uapi/linux/netfilter/nf_tables.h |    2 +-
 net/netfilter/nft_reject.c               |   10 +-
 3 files changed, 7 insertions(+), 162 deletions(-)
