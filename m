From: Thomas Graf <tgraf@infradead.org>
Subject: [PATCH] netfilter: install netfilter/xt_socket.h
Date: Thu, 9 Dec 2010 08:00:12 -0500
Message-ID: <20101209130012.GC7638@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:40239 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0LINAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:00:17 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

<linux/netfilter/xt_socket.h> is required by userspace.

Signed-off-by: Thomas Graf <tgraf@infradead.org>

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 9d40eff..d6d86e4 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -55,6 +55,7 @@ header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_recent.h
 header-y += xt_sctp.h
+header-y += xt_socket.h
 header-y += xt_state.h
 header-y += xt_statistic.h
 header-y += xt_string.h
