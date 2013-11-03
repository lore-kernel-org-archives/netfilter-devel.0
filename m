From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/6] test: fix memleak in XML testing
Date: Sun, 3 Nov 2013 22:30:02 +0100
Message-ID: <20131103213002.GB10464@localhost>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
 <20131031123623.32572.16985.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41374 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab3KCVaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20131031123623.32572.16985.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 31, 2013 at 01:36:23PM +0100, Arturo Borrero Gonzalez wrote:
> Ensure the tree is freed when done.

Applied, thanks.
