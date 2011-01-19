From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: nf_conntrack: fix lifetime display for disabled connections
Date: Wed, 19 Jan 2011 19:18:33 +0100
Message-ID: <4D372AF9.7020501@netfilter.org>
References: <4D3729AC.1090702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34527 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1ASSSi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:18:38 -0500
In-Reply-To: <4D3729AC.1090702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> commit f5c88f56b35599ab9ff2d3398e0153e4cd4a4c82
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed Jan 19 19:10:49 2011 +0100
> 
>     netfilter: nf_conntrack: fix lifetime display for disabled connections
>     
>     When no tstamp extension exists, ct_delta_time() returns -1, which is
>     then assigned to an u64 and tested for negative values to decide
>     whether to display the lifetime. This obviously doesn't work, use
>     a s64 and merge the two minor functions into one.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

I'm sorry, thanks for fixing up this case Patrick.
