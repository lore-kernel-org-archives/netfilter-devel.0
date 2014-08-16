From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 3/5 v3] src: fix byteorder conversions in constant
 values
Date: Sat, 16 Aug 2014 15:45:45 +0100
Message-ID: <20140816144544.GD9697@acer.localdomain>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
 <1407168011-6424-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64421 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHPOpt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:45:49 -0400
Content-Disposition: inline
In-Reply-To: <1407168011-6424-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:00:09PM +0200, Alvaro Neira Ayuso wrote:
> Currently the byteorder conversion happens in many places: the parser,
> the evaluation and the code generation steps. This a problem because
> the constant expression is converted several times into big endian
> byteorder at different steps.
> 
> With this patch, we don't change byteorder in the code generation
> step anymore because we assume that all expressions are in the
> appropriate byteorder after the parsing and the evaluation steps.
> This patch solves rules like:
> 
> nft add rule bridge filter input ether type ip
> 
> With this rule we create a expression like:
> 
> [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000800 ]
> 
> With this patch, we have a expresion with the correct conversion:
> 
> [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
> 
> This is also a problem in the delinearize step because the expression
> are already converted to the correct byteorder and we change it again.

There conversions are actually only done in the evaluation phase. It usually
only invokes setting the value to the correct byteorder. During netlink
linearization, we don't convert byteorder, we export data in the correct
byteorder.

This patch seems to complicate things more than it simplifies them.

> Also this patch, add a new datatype integer_big_endian for fixing some case
> that we have use integer_type with a invalid byteorder when we must associate
> a big endian byteorder. This solution is based in a previously patch of Yuxuan
> Shui.

That is actually a valid problem. However I don't like the solution of adding
a new generic type that encodes the byteorder and additionally breaks the
assumption that type identifiers are unique.

The proper solutions seems to me to simply initialize to the correct byteorder
in the HDR* macros. I'll work on doing that.
