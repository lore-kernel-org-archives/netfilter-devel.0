From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 10:25:48 +0000
Message-ID: <20140205102547.GA20930@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55399 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBEKZx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:25:53 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just noticed commit cc70d069 (netfilter: REJECT: separate reusable code).
That doesn't look like a good idea to me at all.

First of all, it introduces static non-inline functions into a header file,
which is obviously wrong. But more importantly, it adds a symbol dependency
of the reject module on IPv6. We've tried hard to get rid of all these in
x_tables, lets please not re-add them in nftables.

I think we should instead use AF-specific modules for things like that.
We share basically no code except the boiler plate. I'd suggest to add
an AF-specific expression type lookup mechanism that takes precedence
over generic types.

Any other opinions? I wouldn't mind taking care of this myself.
