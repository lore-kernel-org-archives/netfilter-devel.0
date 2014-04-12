From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] expression: Fix inconsistent output in set
Date: Sat, 12 Apr 2014 11:49:24 +0200
Message-ID: <20140412094924.GA2682@macbook.localnet>
References: <1daccfe0798bd032f1770b0ae7888a88db46f3f6.1397204678.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41986 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaDLJt2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:49:28 -0400
Content-Disposition: inline
In-Reply-To: <1daccfe0798bd032f1770b0ae7888a88db46f3f6.1397204678.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 11, 2014 at 10:26:46AM +0200, Ana Rey wrote:
> Add a whitespace between the last element in a set and the close braces.
> 
> Old output set:
> 
> 	set set-test {
> 		type ipv4_address
> 		elements = { 192.168.1.44, 192.168.2.4}
> 	}
> 
> New output set:
> 	set set-test {
> 		type ipv4_address
> 		elements = { 192.168.1.44, 192.168.2.4 }
> 	}
> 

That's actually deliberate. A space is always added before a set member, but never
after.
