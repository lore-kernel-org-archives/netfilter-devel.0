From: Patrick McHardy <kaber@trash.net>
Subject: nft synproxy integration
Date: Mon, 9 Nov 2015 16:30:15 +0000
Message-ID: <20151109163015.GM8098@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, bjornar.ness@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:49519 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbbKIQaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 11:30:20 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We've talked about how to integrate synproxy in nft and agreed that it would
be preferrable to have a nicer way to use it.

The reason why the use is quite complicated right now is actually not because
of synproxy, but because of the desire to avoid creating conntracks for
spoofed connection requests. I don't see any way to avoid this, but we might
be able to make use a bit easier at some slightly higher cost. This applies
to both iptables and nft.

Basically the idea is:

* don't mark the first SYN untracked and have it create a conntrack as normal
* direct that SYN to synproxy
* mark the connection as proxied, which will avoid setting the ASSURED bit when
  receiving our spoofed reply
* only set assured once we have the connection fully established

This would create a conntrack, but keep it evictable under pressure. So the
cost would be ct set up, but we could tear it down at any point when we're
under pressure. The synproxy target can handle both connections with and
without a conntrack.

Usage would basically be:

nft filter input tcp dport 80 ct state INVALID,SYNPROXY synproxy ...

The ct state rule could actually be created automatically since it is a
dependency.

Iff we evict a connection before it is fully established, the final ACK will
be INVALID as it is now with untracked. This makes use less complex since a
single rule with suffice, but at the cost of potentially unnecessarily creating
conntracks. The method of using notrack would of course still be possible.

Any thoughts about this?
