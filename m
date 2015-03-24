From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next 0/2] xt_cgroups fix
Date: Tue, 24 Mar 2015 16:30:27 +0100
Message-ID: <cover.1427209409.git.daniel@iogearbox.net>
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44010 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbbCXPad (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 11:30:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

here's a possible fix for xt_cgroups that was previously reported
by Daniel Mack.

The first patch refactors common helpers, which is later on being
used by the actual fix. Please see individual patches for more
details.

I have based the changes on nf-next as they're rather big, they
are, however, on top of Eric's a94070000388 ("netfilter: xt_socket:
prepare for TCP_NEW_SYN_RECV support") from net-next to avoid ugly
merge conflicts in xt_socket.

If you nevertheless think it's more suited for nf, or I should
ignore the above conflicting commit, I'd be happy to rebase.

Thanks a lot!

Daniel Borkmann (2):
  netfilter: x_tables: refactor lookup helpers from xt_socket
  netfilter: x_tables: fix NF_INET_LOCAL_IN sk lookups

 net/netfilter/Kconfig        |   5 +
 net/netfilter/xt_cgroup.c    |  86 ++++++++++---
 net/netfilter/xt_sk_helper.h | 282 +++++++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_socket.c    | 293 +++----------------------------------------
 4 files changed, 373 insertions(+), 293 deletions(-)
 create mode 100644 net/netfilter/xt_sk_helper.h

-- 
1.9.3

