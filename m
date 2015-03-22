From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/2] rhashtable: provide len to obj_hashfn
Date: Sun, 22 Mar 2015 10:39:51 +0000
Message-ID: <20150322103951.GA1185@casper.infradead.org>
References: <1426952290-18962-1-git-send-email-kaber@trash.net>
 <1426952290-18962-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49919 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbCVKjz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Mar 2015 06:39:55 -0400
Content-Disposition: inline
In-Reply-To: <1426952290-18962-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/21/15 at 03:38pm, Patrick McHardy wrote:
> nftables sets will be converted to use so called setextensions, moving
> the key to a non-fixed position. To hash it, the obj_hashfn must be used,
> however it so far doesn't receive the length parameter.
> 
> Pass the key length to obj_hashfn() and convert existing users.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Acked-by: Thomas Graf <tgraf@suug.ch>
