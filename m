From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/6] add support for conntrack counters
Date: Fri,  8 Jan 2016 10:42:45 +0100
Message-ID: <1452246171-13943-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47934 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbcAHJua (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds support for tests like

ct original packets > 10
ct reply packets > 10
ct packets > 10

The latter returns the counter for both original and reply (i.e. sum).

Needs the two kernel patches:
nftables: ct: add byte/packet counter support
nftables: byteorder: provide le/be 64 bit conversion helper

That were posted earlier.  Let me know if you spot issues.

Thanks.

