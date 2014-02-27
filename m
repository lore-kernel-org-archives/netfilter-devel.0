From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: hash resizing
Date: Thu, 27 Feb 2014 14:56:19 +0000
Message-ID: <1393512980-28780-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
	josh@joshtriplett.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58229 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaB0O4c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:56:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this is a slightly updates patch for nft_hash to use RCU resizing. Since
the current implementation is seriously buggy, this should in any case be
an improvement. Testing also works fine.

Changes this last posting:

- use cookie to avoid second hash walk on remove

Please apply. Thanks!

