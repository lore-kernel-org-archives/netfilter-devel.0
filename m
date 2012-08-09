From: kaber@trash.net
Subject: [PATCH 0/7] extensions: add IPv6 NAT support
Date: Thu,  9 Aug 2012 22:11:06 +0200
Message-ID: <1344543073-11660-1-git-send-email-kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2HIUXf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:23:35 -0400
Received: from gw.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 6C56FB2C5E
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Aug 2012 22:11:15 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain userspace support for IPv6 NAT and
stateless prefix translation. The NAT extensions are based on
their IPv4 counterparts.

