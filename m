From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 04/08: xt_time: fix time's time_mt()'s use of
 do_div()
Date: Mon, 21 Jul 2008 10:05:49 -0700 (PDT)
Message-ID: <20080721.100549.115358190.davem@davemloft.net>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
	<20080721161728.28572.17464.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58549
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYGURFt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:05:49 -0400
In-Reply-To: <20080721161728.28572.17464.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 18:17:28 +0200 (MEST)

> netfilter: xt_time: fix time's time_mt()'s use of do_div()
> 
> Fix netfilter xt_time's time_mt()'s use of do_div() on an s64 by using
> div_s64() instead.
> 
> This was introduced by patch ee4411a1b1e0b679c99686629b5eab5a072ce49f.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, but I had to add the commit header line text to that
base SHA ID reference.
