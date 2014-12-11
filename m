From: Patrick McHardy <kaber@trash.net>
Subject: nftables "random-fully" option
Date: Thu, 11 Dec 2014 22:04:41 +0000
Message-ID: <20141211220440.GB23366@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56396 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbaLKWEq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:04:46 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just noticed that NAT "random-fully" option.

Guys, can we *please* not use the names of defines for keywords if
their name is obviously chosen to have a common prefix, not to be
a user facing option? We don't aim to follow the iptables model of
naming options after kernel internal names, we want something that
is easy and descriptive for the user.

To have random and random-fully is confusing enough, we don't need
to make it worse by using backwards named options. "fully-random"
would at least be a proper english term.

I'll rename it, luckily we didn't have a release so far.

Sorry for getting a bit upset about this, but messing this up means
having compat crap and this one was really obviously a bad choice.
