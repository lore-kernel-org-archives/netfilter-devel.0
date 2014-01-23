From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v3] This patch adds the following operation:
Date: Thu, 23 Jan 2014 17:44:02 +0000
Message-ID: <20140123174402.GB4147@macbook.localnet>
References: <20140123094743.17227.18043.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61663 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaAWRoH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:44:07 -0500
Content-Disposition: inline
In-Reply-To: <20140123094743.17227.18043.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 23, 2014 at 10:49:27AM +0100, Arturo Borrero Gonzalez wrote:
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

Applied, thanks Arturo.
