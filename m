From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/5] rule: fix snprintf return value
Date: Wed, 5 Jun 2013 05:09:14 +0200
Message-ID: <20130605030914.GC24257@localhost>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
 <20130603204452.27713.79515.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59178 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3FEDJS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:09:18 -0400
Content-Disposition: inline
In-Reply-To: <20130603204452.27713.79515.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 03, 2013 at 10:44:52PM +0200, Arturo Borrero wrote:
> This cause some chained snprintf to fail.

Applied, thanks.
