From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Fri, 4 Jan 2013 10:20:43 +0100
Message-ID: <20130104092042.GB28028@macbook.localnet>
References: <20130102152440.GA3760@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33431 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3ADJUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:20:52 -0500
Content-Disposition: inline
In-Reply-To: <20130102152440.GA3760@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 02, 2013 at 04:24:40PM +0100, Ulrich Weber wrote:
> csum16_add() has a broken carry detection, should be:
> sum += sum < (__force u16)b;
> 
> Instead of fixing csum16_add, remove the custom checksum
> functions and use the generic csum_add/csum_sub ones.

Looks good to me.

Acked-by: Patrick McHardy <kaber@trash.net>
