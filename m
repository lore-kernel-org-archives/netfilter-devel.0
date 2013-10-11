From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] netfilter: ipset: Fix configure failure when --with-kmod=no
Date: Fri, 11 Oct 2013 16:41:11 +0200
Message-ID: <1381502472-12217-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:46729 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3JKOm5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:42:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 307D4A018A
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 15:42:56 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ImS9kXV2AK04 for <netfilter-devel@vger.kernel.org>;
	Fri, 11 Oct 2013 15:41:43 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

The following patch fixes a build failure when configuring the sources to build
without kernel modules enabled.

I ran into this issue while writing a Gentoo ebuild to compile ipset 6.20 - it
would be appreciated if there could perhaps be a minor release made to address
this issue.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Oliver Smith (1):
  netfilter: ipset: Fix configure failure when --with-kmod=no

 configure.ac | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.3.2

