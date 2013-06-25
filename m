From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] nft: mem leak in nft_rule_list_cb
Date: Tue, 25 Jun 2013 12:00:26 +0200
Message-ID: <20130625100026.GB3729@localhost>
References: <20130625074606.4665.80766.stgit@localhost>
 <20130625074617.4665.91288.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab3FYKAb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:00:31 -0400
Content-Disposition: inline
In-Reply-To: <20130625074617.4665.91288.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 25, 2013 at 09:46:17AM +0200, Giuseppe Longo wrote:
> Memory leak in function nft_rule_list_cb fixed.

Applied, thanks Giuseppe.
