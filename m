From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] rule: fix chain details align indentations
Date: Thu, 19 Mar 2015 14:36:18 +0100
Message-ID: <20150319133618.GA6305@salvia>
References: <20150319123759.28211.63107.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60916 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbbCSNcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2015 09:32:31 -0400
Content-Disposition: inline
In-Reply-To: <20150319123759.28211.63107.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 19, 2015 at 01:37:59PM +0100, Arturo Borrero Gonzalez wrote:
> f.i:
> 	 type filter hook output priority 0; policy accept;
> 	ip daddr @test counter packets 14 bytes 1176

Applied, thanks. Sorry about that Patrick.
