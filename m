From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nft: scanner: fixed problem with ipv6 address
Date: Wed, 15 Jan 2014 07:43:22 +0000
Message-ID: <20140115074321.GA19984@macbook.localnet>
References: <1389727556-9568-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41738 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaAOHn0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:43:26 -0500
Content-Disposition: inline
In-Reply-To: <1389727556-9568-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 08:25:56PM +0100, Ana Rey wrote:
> There is a problem with the follow ipv6 address combination:
> 
> nft add rule ip6 t_ip61 filter-input ip6 saddr ::1234:1234:1234:1234:1234:1234:1234
> 
> 1234::1234:1234:1234:1234:1234:1234
> 1234:1234::1234:1234:1234:1234:1234
> 1234:1234:1234::1234:1234:1234:1234
> 1234:1234:1234:1234::1234:1234:1234
> 1234:1234:1234:1234:1234::1234:1234
> ::1234:1234:1234:1234:1234:1234
> 1234::1234:1234:1234:1234:1234
> 1234:1234::1234:1234:1234:1234
> 1234:1234:1234::1234:1234:1234
> 1234:1234:1234:1234::1234:1234
> ::1234:1234:1234:1234:1234
> 1234::1234:1234:1234:1234
> 1234:1234::1234:1234:1234
> 1234:1234:1234::1234:1234
> ::1234:1234:1234:1234
> 1234::1234:1234:1234
> 1234:1234::1234:1234
> ::1234:1234:1234
> 1234::1234:1234
> 
> The problem was in the scanner (src/scanner.l). Several brackets were missed
> and the result was an incorrect interpretation.
> 
> Fix it by adding some brackets in a regular expression in src/scanner.l
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>

Applied, thanks.
