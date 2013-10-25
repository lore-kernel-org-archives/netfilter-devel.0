From: Jiri Benc <jbenc@redhat.com>
Subject: Re: [BUG] libnftables: NULL pointer dereference in
 nft_expr_ops_lookup
Date: Fri, 25 Oct 2013 17:46:51 +0200
Message-ID: <20131025174651.49d97445@griffin>
References: <20131025152735.65d354bd@griffin>
	<20131025150436.GA7536@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3JYPq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:46:57 -0400
In-Reply-To: <20131025150436.GA7536@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 25 Oct 2013 17:04:36 +0200, Pablo Neira Ayuso wrote:
> reject support was never finished. Please, find enclosed patches for
> libnftables and nft.

That was fast, thanks! Seems to work.

Tested-by: Jiri Benc <jbenc@redhat.com>

> ICMP code support is still missing, perhaps you want to investigate
> how to add it to nft. It should be a small follow up patch.

Yes, that would be useful. I may look into that but no promises as of
when. Feel free to beat me.

 Jiri

-- 
Jiri Benc
