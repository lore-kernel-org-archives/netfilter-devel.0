From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 4/5] nft: export functions reusability
Date: Tue, 30 Jul 2013 11:06:51 +0200
Message-ID: <20130730090651.GA31610@localhost>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
 <1374836719-27596-4-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab3G3JG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:06:58 -0400
Content-Disposition: inline
In-Reply-To: <1374836719-27596-4-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 26, 2013 at 01:05:18PM +0200, Giuseppe Longo wrote:
> This permit to reuse some functions in other tool (like arptables)

Please, add this patch to the arptables bootstrap patch, as we start
needing it there.

Thanks.
