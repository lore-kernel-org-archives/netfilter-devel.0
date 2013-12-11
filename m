From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH -next 0/3] seq_printf/puts/putc: Start to convert to
 return void
Date: Wed, 11 Dec 2013 00:20:40 -0500 (EST)
Message-ID: <20131211.002040.1061939246483044835.davem@davemloft.net>
References: <cover.1386738050.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: viro@zeniv.linux.org.uk, keescook@chromium.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	b.a.t.m.a.n@lists.open-mesh.org
To: joe@perches.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3LKFUm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:20:42 -0500
In-Reply-To: <cover.1386738050.git.joe@perches.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Tue, 10 Dec 2013 21:12:41 -0800

> Many uses of the return value of seq_printf/seq_puts/seq_putc are
> incorrect.  Many assume that the return value is the number of
> chars emitted into a buffer like printf/puts/putc.
> 
> It would be better to make the return value of these functions void
> to avoid these misuses.
> 
> Start to do so.
> Convert seq_overflow to a public function from a static function.
> 
> Remove the return uses of seq_printf/seq_puts/seq_putc from net.
> Add a seq_overflow function call instead.

I'm fine with this going in whatever tree is appropriate for
the seq_overflow un-static change:

Acked-by: David S. Miller <davem@davemloft.net>
