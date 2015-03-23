From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl] src: restore static array with expression
 operations
Date: Mon, 23 Mar 2015 11:44:11 +0000
Message-ID: <20150323114411.GH603@acer.localdomain>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ska-devel@skarnet.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61066 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbCWLoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 07:44:16 -0400
Content-Disposition: inline
In-Reply-To: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.03, Pablo Neira Ayuso wrote:
> We cannot use __attribute__((constructor)) to register the supported
> expressions in runtime when the library is statically linked. This lead
> us to some explicit libnftnl_init() function that needs to be called
> from the main() function of the client program.

Just wondering, why not? They should still be invoked, right?

> This patch reverts 4dd0772 ("expr: use __attribute__((constructor)) to
> register expression").
> 
> Reported-by: Laurent Bercot <ska-devel@skarnet.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
