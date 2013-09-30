From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/3] src: add low-level ruleset API
Date: Mon, 30 Sep 2013 19:46:38 +0200
Message-ID: <20130930174638.GC31379@localhost>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930150602.32124.86409.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43526 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3I3Rqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:46:43 -0400
Content-Disposition: inline
In-Reply-To: <20130930150602.32124.86409.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 05:06:02PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a low level ruleset API for libnftables.

I cannot apply this patch, it depends on 1/3 :-(

I think this work should have come in first place, we've been working
on it for quite some time. The improvements for the test
infrastructure are not so important, that's test infrastructure code
after all.
