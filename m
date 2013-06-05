From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: xml: fix using bad temp variable
Date: Wed, 5 Jun 2013 05:05:23 +0200
Message-ID: <20130605030523.GA24257@localhost>
References: <20130529224506.18081.1971.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FEDF2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:05:28 -0400
Content-Disposition: inline
In-Reply-To: <20130529224506.18081.1971.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 30, 2013 at 12:45:06AM +0200, Arturo Borrero wrote:
> This is a bug. It should use 'utmp' instead of 'tmp'.

Applied, thanks.
