From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH v2] src: add export operation
Date: Tue, 21 Jan 2014 17:26:37 +0000
Message-ID: <20140121172636.GA19175@macbook.localnet>
References: <20140121170109.31013.94618.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41293 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbaAUR0k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:26:40 -0500
Content-Disposition: inline
In-Reply-To: <20140121170109.31013.94618.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 06:01:54PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds the following operation:
> 
>  :~# nft export <xml|json>
> 
> The XML/JSON output is provided raw by libnftnl, thus without format.
> 
> In case of XML, you can give format with the `xmllint' tool from libxml2-tools:
>  :~# nft list ruleset xml | xmllint --format -
> 
> In case of JSON, you can use `json_pp' from perl standar package:
>  :~# nft list ruleset json | json_pp
> 
> A format field is added in struct cmd, and it will be reused in the import
> operation.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: address comments by Patrick: use CMD_OBJ_RULESET, move some includes, etc.

Looks fine to me. I can apply it if you want, not sure since the import
counterpart will have to wait until we have the necessary kernel changes
in place.

Please let me know.
