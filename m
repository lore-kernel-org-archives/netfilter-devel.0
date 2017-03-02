From: Phil Sutter <phil@nwl.cc>
Subject: nft: ah expression doesn't work for IPv6
Date: Thu, 2 Mar 2017 20:56:52 +0100
Message-ID: <20170302195651.GX6099@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55355 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750972AbdCBUVi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 15:21:38 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

There is currently an open issue with nft in that ah expression doesn't
work for IPv6 since it creates a payload expression which doesn't find
the AH IPv6 extension header.

There has been a discussion about this problem off-list in which two
alternative "solutions" were named, both involve checking the context
to find out whether one is trying to match an IPv4 or IPv6 packet and
then create either payload or exthdr expression. Though this solution is
not optimal, as in (at least) inet table the address family is not given
per se.

I had the idea of creating a "real" solution to the problem which
consists of a payload/exthdr hybrid in kernel space searching for the
given header in different locations depending on the family of the
actual package being handled. Ideally this should reuse as much code as
possible, so maybe "just" create both expressions in user space and in
kernel space only branch between the two.

This is merely a rough idea and I probably miss some obstacles which
have to be overcome in order to make this work. What are your opinions
on that? Do you think something like that could work, or do you have a
better idea to fix this problem?

Thanks, Phil
