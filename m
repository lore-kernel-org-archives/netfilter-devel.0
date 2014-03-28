From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nftables: Fix list of sets by family
Date: Fri, 28 Mar 2014 10:25:56 +0000
Message-ID: <20140328102555.GB20105@macbook.localnet>
References: <dfe65abd0921773564be9ebfe55b55233380bd40.1395993386.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54140 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaC1KZ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:25:59 -0400
Content-Disposition: inline
In-Reply-To: <dfe65abd0921773564be9ebfe55b55233380bd40.1395993386.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 08:57:54AM +0100, Ana Rey wrote:
> Fix the result of command line 'nft list sets FAMILY'. It shows the
> following error message:
> 
> "Error: syntax error, unexpected end of file, expecting string"
> 
> Use set_print function to show the list of set by family (ip, ip6, arp,
> bridge).
> 
> The set_print function is used in the following command line:
> * sudo nft list table FAMILY table_name
> * sudo nft list set FAMILY table_name set_name
> * sudo nft list sets FAMILY
> 
> In 'nft list table FAMILY table_name' and 'nft list set FAMILY
> table_name set_name' command line is necessary a extra indent that is
> not necessary in 'nft list sets FAMILY'.
> 
> Thus, It fixes this indent problem in the set_print function and now, it is
> possible show right this information:

These are two unrelated changes. Regarding the indentation, Arturro has
a patch that will also fix this in a more general way. Please seperate
the grammar fix and submit this patch, we'll fix the indentation with
Arturro's monitor feature.

Thanks!
