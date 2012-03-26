From: Florian Westphal <fw@strlen.de>
Subject: RFC: bridge netfilter vlan device name resolution
Date: Mon, 26 Mar 2012 22:21:24 +0200
Message-ID: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59471 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756372Ab2CZUVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:21:25 -0400
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1SCGPs-0004YK-P5
	for netfilter-devel@vger.kernel.org; Mon, 26 Mar 2012 22:21:24 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using a bridge with a management vlan on top (e.g. br0.1), you
cannot use iptables to match the input vlan device, because the vlan
device isn't resolved yet, i.e.  "-i br0" matches, while "-i br0.1"
does not, unless "net.bridge.bridge-nf-filter-vlan-tagged" (or
"net.bridge.bridge-nf-call-iptables") is turned off.

This happens because bridge netfilter runs before
vlan device lookup, so skb->dev is set to the bridge; not
the vlan device on top of the bridge.

I'd like to use iptables -t nat ... -j REDIRECT only for one particular vlan.

Two possible solutions come to mind:

- #1, add the vlan tag to nf_bridge info for use with physdev match:
  "... -m physdev --vlan-id 42 ..."
- #2, change bridge netfilter so that it passes in the vlan instead of
  the bridge as input device.

Any other ideas on how to handle this?

RFC patch that implements #2 follows.

Thanks,
Florian
