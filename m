From: Patrick McHardy <kaber@trash.net>
Subject: Re: SYNPROXY module with bridge
Date: Sun, 5 Apr 2015 15:04:51 +0200
Message-ID: <20150405130450.GF23433@acer.localdomain>
References: <551F008F.6050200@4vendeta.com>
 <20150405114729.GC23433@acer.localdomain>
 <55212FFA.9050204@4vendeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	fw@strlen.de, marc+nf@mbsi.ca, gandalf@netfilter.org,
	yasuyuki@netfilter.org
To: Todor Todorov <root@4vendeta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57930 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbDENE4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 09:04:56 -0400
Content-Disposition: inline
In-Reply-To: <55212FFA.9050204@4vendeta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[changed CC to netfilter-devel]

On 05.04, Todor Todorov wrote:
> Hello,
> 
> I was check and as you said REJECT target also doesn't work in Bridge.

It does work on bridges, this is why I asked you to have a look at it.

> Where is the problem - in "br.c" or it must add a check in "ipt_synproxy.c"
> for is the packet coming from bridged interface?
> I find this patch for reject in bridge but doesn't work - http://markmail.org/message/zkd57gfh7htcbyvc#query:+page:1+mid:spwhgpx2jl6iholn+state:results
> 
> Any help would be useful to me...

The REJECT target basically does what is necessary for SYNPROXY as well.
Instead of routing newly generated packets, their outgoing ports must
be determined based on the original packet, additionally you need to
add a link layer header to them.
