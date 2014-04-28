From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] common: fix unconditional output of event
 wrapping stuff
Date: Mon, 28 Apr 2014 16:25:35 +0200
Message-ID: <20140428142535.GA28712@localhost>
References: <20140428105837.18312.91126.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59557 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaD1OZj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:25:39 -0400
Content-Disposition: inline
In-Reply-To: <20140428105837.18312.91126.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 28, 2014 at 12:58:38PM +0200, Arturo Borrero Gonzalez wrote:
> We can't unconditionally print out these strings.
> 
> Before this patch, objects being printed will be treated as an 'unkown' event.

Applied, thanks Arturo.
