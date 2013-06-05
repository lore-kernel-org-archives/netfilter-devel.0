From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: delete unreachable code
Date: Wed, 5 Jun 2013 05:06:41 +0200
Message-ID: <20130605030641.GB24257@localhost>
References: <20130603171520.21980.39483.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FEDGq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:06:46 -0400
Content-Disposition: inline
In-Reply-To: <20130603171520.21980.39483.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 03, 2013 at 07:15:20PM +0200, Arturo Borrero wrote:
> The deleted code is never executed, thus junk. Introduced by me in previous commit.

Applied, thanks.
