From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 1/1]: nf_conntrack_expect: fix error path unwind in
 nf_conntrack_expect_init()
Date: Thu, 29 May 2008 03:21:01 -0700 (PDT)
Message-ID: <20080529.032101.66578823.davem@davemloft.net>
References: <483B9566.3030105@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYE2KVG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 06:21:06 -0400
In-Reply-To: <483B9566.3030105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 27 May 2008 07:00:22 +0200

> Attached is a fix from Alexey for incorrect error handling
> in nf_conntrack_expect. I'll also queue it up for -stable.

Applied and pushed out to net-2.6, thanks Patrick.
