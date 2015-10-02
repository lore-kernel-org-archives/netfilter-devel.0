From: Guillaume Nault <g.nault@alphalink.fr>
Subject: [PATCH libmnl 0/2] Introduce mnl_socket_open2()
Date: Fri, 2 Oct 2015 22:12:30 +0200
Message-ID: <cover.1443815157.git.g.nault@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:59752 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751016AbbJBUMf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 16:12:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 259782B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:34 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id WITC6dfsTfev for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 90A892B5218C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:33 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pRNGlQayMiaX for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:33 +0200 (CEST)
Received: from dev-10-pornic.admin.alphalink.fr (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 6A5F22B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:33 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mnl_socket_open2() extends mnl_socket_open() with user provided flags, to
be used in the socket() call.

Patch #1 implements the new function while patch #2 updates the
examples by applying the SOCK_CLOEXEC flag on netlink sockets. Though
it's a safe default, this flag isn't necessary for the simple programs
under examples/. So feel free to drop patch #2 if considered of too
little value.

Guillaume Nault (2):
  socket: introduce mnl_socket_open2()
  examples: use mnl_socket_open2()

 examples/genl/genl-family-get.c        |  4 ++--
 examples/genl/genl-group-events.c      |  4 ++--
 examples/kobject/kobject-event.c       |  4 ++--
 examples/netfilter/nf-log.c            |  4 ++--
 examples/netfilter/nf-queue.c          |  4 ++--
 examples/netfilter/nfct-create-batch.c |  4 ++--
 examples/netfilter/nfct-daemon.c       |  4 ++--
 examples/netfilter/nfct-dump.c         |  4 ++--
 examples/netfilter/nfct-event.c        |  4 ++--
 examples/rtnl/rtnl-addr-dump.c         |  4 ++--
 examples/rtnl/rtnl-link-dump.c         |  4 ++--
 examples/rtnl/rtnl-link-dump2.c        |  4 ++--
 examples/rtnl/rtnl-link-dump3.c        |  4 ++--
 examples/rtnl/rtnl-link-event.c        |  4 ++--
 examples/rtnl/rtnl-link-set.c          |  4 ++--
 examples/rtnl/rtnl-route-add.c         |  4 ++--
 examples/rtnl/rtnl-route-dump.c        |  4 ++--
 examples/rtnl/rtnl-route-event.c       |  4 ++--
 include/libmnl/libmnl.h                |  3 ++-
 src/libmnl.map                         |  1 +
 src/socket.c                           | 41 ++++++++++++++++++++++++++--------
 21 files changed, 71 insertions(+), 46 deletions(-)

-- 
2.6.0

