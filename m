From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH v2 0/6] nft events reporting
Date: Thu, 27 Feb 2014 14:09:39 +0000
Message-ID: <20140227140939.GC18385@macbook.localnet>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57868 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaB0OJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:09:43 -0500
Content-Disposition: inline
In-Reply-To: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 05:09:44PM +0100, Arturo Borrero Gonzalez wrote:
> This series implements basic event reporting in the nftables CLI tool.
> 
> The first patches are some neccesary code factorization changes.
> The last patch is the event reporting itself.
> 
> Its quite simple, the syntax is:
>  % nft monitor [added|deleted] [tables|chains|sets|rules] [xml|json]
> 
> I've discarted using 'new|delete' keywords because 'new' collides with
> the 'state new'ct option. 

I have to strong preference, only tending to think that new/delete ic a bit
nicer. If you want to keep them, you can do handle this similar how to we
deal with f.i. "ip protocol tcp". If "new" is occuring somewhere outside
of the monitor rule, you simply convert it to a symbol expression.

> About this last format:
> 
> Rules are hard to print exactly as the user typed because sets.
> The approach followed in the patch is:
>  * keep a userspace cache of tables/anonymous sets.
>  * since there are no event notifications for set_elements, query kernel
>  for set_elements in the event callback.
>  * since there are no event notification for deleted anon-sets, and sets names
>  are reusable, scan each deleted rule to know which sets delete from the cache.
>  * no need to do any caching if we are not monitoring new rule
>  events in the nft default format.

We could add notifications for set elements and anonymous set deletions
if that makes things easier. Is my assumption correct that you only print
the set members for anonymous sets and for non-anonmyous sets simply print
... @set?
