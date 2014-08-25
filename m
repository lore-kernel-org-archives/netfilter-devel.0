From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] src: improve printing of XML/JSON event
 wrapper header/footer
Date: Mon, 25 Aug 2014 16:12:17 +0200
Message-ID: <20140825141217.GB5147@salvia>
References: <20140825130221.23329.86583.stgit@nfdev.cica.es>
 <20140825130227.23329.41536.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42340 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbaHYOLu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:11:50 -0400
Content-Disposition: inline
In-Reply-To: <20140825130227.23329.41536.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 25, 2014 at 03:02:27PM +0200, Arturo Borrero Gonzalez wrote:
> Use the nft_fprintf() helper. The helper handles \0 properly.
> 
> Before this patch, we get trash in the output due to the buffer being printed
> without any \0.

Applied, thanks.

I have replace "improve" by "fix" in the patch title.

