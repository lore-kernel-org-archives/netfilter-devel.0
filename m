From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/11] netlink: memory mapped I/O
Date: Wed, 22 Aug 2012 02:29:28 -0700 (PDT)
Message-ID: <20120822.022928.1709843473935977957.davem@davemloft.net>
References: <1345443532-3707-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Florian.Westphal@Sophos.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:51277 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2HVJ33 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:29:29 -0400
In-Reply-To: <1345443532-3707-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 20 Aug 2012 08:18:41 +0200

> The following patches contain an implementation of memory mapped I/O for
> netlink, rebased onto the current net-next tree. The implementation is
> modelled after AF_PACKET memory mapped I/O with a few differences:

Thanks for taking this work so far.  Let me know when you have a version
with all the feedback integrated.
