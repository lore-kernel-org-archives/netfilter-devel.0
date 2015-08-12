From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Wed, 12 Aug 2015 19:34:53 +0200
Message-ID: <20150812173453.GA30926@salvia>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbbHLR2p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:28:45 -0400
Content-Disposition: inline
In-Reply-To: <20150720183536.GE11985@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

I found a problem in your change to validate the netlink instructions
from the python infrastructure that we have for nft.

The set elements are not always displayed in the same order depending
on the hash seed, so we get bogus warnings in that case.

I think the fix for the test infrastructure will require something a
bit more complicated that a simple string comparison as we'll need to
interpret the set element part.

Probably it would be good to wrap the netlink instruction generation
code under some option until this is resolved, instead of having it
enabled by default.

Let me know if you come up with any better idea. Thanks!
