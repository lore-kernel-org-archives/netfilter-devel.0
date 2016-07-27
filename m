From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/7] add payload set support for sub-byte sizes
Date: Wed, 27 Jul 2016 02:43:09 +0200
Message-ID: <1469580196-2100-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60772 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbcG0BP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds support for setting ipv6 flowlabel and e.g.
ecn/dscp header fields for ipv4 and ipv6 by adding the needed
bitwise ops (and removing them during netlink decoding).

Feedback welcome.

