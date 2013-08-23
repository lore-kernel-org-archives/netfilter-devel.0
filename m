From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] [RFC] Add hash:net,net ipset for storage of v4/v6 CIDR pairs.
Date: Fri, 23 Aug 2013 06:15:02 +0200
Message-ID: <1377231303-6926-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:49648 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3HWEZP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:25:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id D57DA9F859
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 05:18:50 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id yzod363YX1Vy for <netfilter-devel@vger.kernel.org>;
	Fri, 23 Aug 2013 05:17:53 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm sending the following patch for feedback - it's something I created out
of a need to restrict access to various subnets pairs in a form more convenient
than a huge ugly iptables chain.

There's a wee bit of code duplication for the CIDR add/del but I felt
that copying the functions to handle a second CIDR was less invasive
than reworking it and having to change code for the existing sets, but
I'm open to ideas if anyone feels it's not suitable.
