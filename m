From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v2 0/2] xt_cgroups fix
Date: Thu, 26 Mar 2015 20:14:46 +0100
Message-ID: <cover.1427394874.git.daniel@iogearbox.net>
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:58338 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbbCZTOv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 15:14:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

here's a possible fix for xt_cgroups that was previously reported
by Daniel Mack.

I respinned the set based on your previous feedback wrt tw sockets.

The first patch refactors common helpers, which is later on being
used by the actual fix. Please see individual patches for details.

I have rebased it against nf-next as in the previous version.

Thanks a lot!

v1->v2:
  - patch1 as is
  - patch2 checks for full socket

Daniel Borkmann (2):
  netfilter: x_tables: refactor lookup helpers from xt_socket
  netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN sk lookups

 net/netfilter/Kconfig        |   5 +
 net/netfilter/xt_cgroup.c    |  92 +++++++++++---
 net/netfilter/xt_sk_helper.h | 282 +++++++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_socket.c    | 293 +++----------------------------------------
 4 files changed, 379 insertions(+), 293 deletions(-)
 create mode 100644 net/netfilter/xt_sk_helper.h

-- 
1.9.3

