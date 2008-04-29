From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Mon, 28 Apr 2008 23:56:50 -0700 (PDT)
Message-ID: <20080428.235650.193704155.davem@davemloft.net>
References: <4816B983.4030906@snapgear.com>
	<20080428.231414.193695218.davem@davemloft.net>
	<4816C550.6080602@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: philipc@snapgear.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51629
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYD2G4v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:56:51 -0400
In-Reply-To: <4816C550.6080602@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Philip Craig <philipc@snapgear.com>
Date: Tue, 29 Apr 2008 16:50:56 +1000

> David Miller wrote:
> >> eg what does it do for this:
> >> 	struct t {
> >> 		struct s {
> >> 			u16 a;
> >> 			u16 b;
> >> 		} __attribute__(packed);
> >> 	};
> > 
> > 'a' and 'b' cannot be assumed to be aligned in any particular way,
> > and thus byte-at-a-time accesses will be made to them.
> 
> Does it ever do anything besides byte access for words on sparc?
> 
> Here's my results on ARM, which show that including the packed
> struct in another struct allows gcc to assume alignment.
> I'm not saying this results in pretty code though :-)

Sure, the packed doesn't get inherited by the struct the
sub-struct is in.

But it still means the bit marked packed is going to be
accessed using byte-at-a-time loads and stores.

I guess this is immaterial, as it seems the memset() is the
best solution anyways.
