From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack: fix error path unwind in nf_conntrack_expect_init()
Date: Thu, 22 May 2008 17:18:32 +0200
Message-ID: <48358EC8.609@trash.net>
References: <200805221914.28472.adobriyan@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, devel@openvz.org
To: Alexey Dobriyan <adobriyan@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYEVPSg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 11:18:36 -0400
In-Reply-To: <200805221914.28472.adobriyan@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
> ---
> 
>  net/netfilter/nf_conntrack_expect.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks Alexey. I'll also push this to -stable.
