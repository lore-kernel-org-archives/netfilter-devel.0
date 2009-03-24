From: Bart Trojanowski <bart@jukie.net>
Subject: Re: nftables: build issues
Date: Tue, 24 Mar 2009 15:35:40 -0400
Message-ID: <20090324193540.GD2551@jukie.net>
References: <20090324185711.GB2551@jukie.net> <49C92E2B.3030906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tau.jukie.net ([216.239.93.128]:53625 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761594AbZCXTng (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:43:36 -0400
Content-Disposition: inline
In-Reply-To: <49C92E2B.3030906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just wanted to follow up...

* Patrick McHardy <kaber@trash.net> [090324 15:02]:
> a crash. For now I'd recommend to get an older version of bison to
> compile nftables. 1.2.3.dfsg-4 from etch works fine for me.

This did the trick.  I downgraded to bison 1:2.3.dfsg-5 (from Lenny)
and I can now run 'nft --help' ... yey!

Thanks.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
