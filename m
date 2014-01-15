From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/2] nftables: removal of secmark and shortened meta expressions
Date: Wed, 15 Jan 2014 11:16:23 +0000
Message-ID: <1389784585-17603-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43721 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaAOLQc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:16:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches remove the secmark from the ct and meta expressions since
userspace should use the secctx and change the nftables grammar to accept
a subset of meta expressions without the meta keyword for a more natural
look.

Unless there are objections, I'll push those patches to master shortly.
