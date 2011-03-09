From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] x_tables: misuse of try_then_request_module
Date: Wed, 09 Mar 2011 14:23:54 +0100
Message-ID: <4D777F6A.2020108@trash.net>
References: <20110308172318.4992a3a6@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1CINX6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:23:58 -0500
In-Reply-To: <20110308172318.4992a3a6@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.03.2011 02:23, schrieb Stephen Hemminger:
> Since xt_find_match() returns ERR_PTR(xx) on error not NULL,
> the macro try_then_request_module won't work correctly here.
> The macro expects its first argument will be zero if condition
> fails. But ERR_PTR(-ENOENT) is not zero.
> 
> The correct solution is to propagate the error value
> back.
> 
> Found by inspection, and compile tested only.

Thanks Stephen. It actually works fine since we don't return
-ENOENT but 0 if nothing was found. If a non-matching revision
was found we return -EPROTOTYPE, but that case can only happen
if the module was already loaded.

Anyways, this seems quite fragile, so I've applied your patch.
