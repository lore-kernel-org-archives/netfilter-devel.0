From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 07/08: nf_nat_sip: c= is optional for session
Date: Mon, 21 Jul 2008 10:06:26 -0700 (PDT)
Message-ID: <20080721.100626.123801648.davem@davemloft.net>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
	<20080721161732.28572.1919.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58558
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbYGURG0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:06:26 -0400
In-Reply-To: <20080721161732.28572.1919.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 18:17:32 +0200 (MEST)

> netfilter: nf_nat_sip: c= is optional for session
> 
> According to RFC2327, the connection information is optional
> in the session description since it can be specified in the
> media description instead.
> 
> My provider does exactly that and does not provide any connection
> information in the session description.  As a result the new
> kernel drops all invite responses.
> 
> This patch makes it optional as documented.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Tsk tsk, please stop breaking people's phones ;-)

Applied.
