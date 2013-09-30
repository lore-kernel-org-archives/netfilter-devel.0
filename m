From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] table: json: fix json style
Date: Mon, 30 Sep 2013 19:43:08 +0200
Message-ID: <20130930174308.GB31379@localhost>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930150557.32124.88117.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43011 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab3I3RnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:43:15 -0400
Content-Disposition: inline
In-Reply-To: <20130930150557.32124.88117.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 05:05:57PM +0200, Arturo Borrero Gonzalez wrote:
> Be consistent in JSON style.

I prefer if you rewiew the entire output and you perform all this
consistency fixes in one patch.

The description should what policy you have following to fix the
style.
