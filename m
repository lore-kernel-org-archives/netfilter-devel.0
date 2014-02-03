From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables] rebase next-3.14
Date: Mon, 3 Feb 2014 13:56:11 +0100
Message-ID: <20140203125611.GA13245@localhost>
References: <CAOkSjBhkhWXiazqonNd+eN=+Mb473xH_WZCtaycB=w9YEO61oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39037 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaBCM4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:23 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhkhWXiazqonNd+eN=+Mb473xH_WZCtaycB=w9YEO61oA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 03, 2014 at 01:20:04PM +0100, Arturo Borrero Gonzalez wrote:
> Hi there!
> 
> Would you consider rebasing libnftnl/nftables next-3.14?
> 
> Some important changes happened in the master branch that are needed
> in next-3.14.
> 
> It's hard to build the next-3.14 branch, because libnftnl deploys
> include files in 'include/libnftables' and nftables expects
> 'include/libnftnl'.
> 
> The libnftnl rebase is going to be painful, let me know if I can help.

No problem, I'll resolve that rebase.
