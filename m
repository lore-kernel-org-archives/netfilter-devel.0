From: Patrick McHardy <kaber@trash.net>
Subject: Re: [libnftnl PATCH] set: add helper to get the first set_elem
Date: Tue, 15 Apr 2014 10:04:32 +0200
Message-ID: <20140415080432.GA15759@macbook.localnet>
References: <20140415075842.18544.32525.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35458 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaDOIEg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:04:36 -0400
Content-Disposition: inline
In-Reply-To: <20140415075842.18544.32525.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 09:58:42AM +0200, Arturo Borrero Gonzalez wrote:
> Add a helper that returns a pointer to the first set_elem in a given set.
> 
> This function is useful in situations where you know the set only have one
> element (ie, event reporting from the kernel).

That doesn't seem right to me. As I said in my review of the notification
patch, userspace *must* be prepared for multiple elements being reported
at once since it is very likely that we will change the kernel side in
the future for efficiency reasons.
