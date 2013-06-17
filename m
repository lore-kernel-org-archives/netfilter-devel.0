From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] expr: bitwise: xml_parse: fix casting
Date: Mon, 17 Jun 2013 21:20:02 +0200
Message-ID: <20130617192002.GA13504@localhost>
References: <20130615003613.27171.26876.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49264 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FQTUI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:20:08 -0400
Content-Disposition: inline
In-Reply-To: <20130615003613.27171.26876.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 15, 2013 at 02:36:13AM +0200, Arturo Borrero wrote:
> Not calling e->data when doing the casting causes memory corruption: segfault.
> 
> This was introduced at: 51370f0eedb1c8167ab2c340d2a53f0d9f02509c (src: add support for XML parsing)

Please, next time use the short commit ID that you can get via
git log --oneline.

Applied, thanks.
