From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] chain: xml: optional attributes
Date: Wed, 4 Sep 2013 15:04:34 +0200
Message-ID: <20130904130434.GA4866@localhost>
References: <20130901233230.3018.51446.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36633 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934700Ab3IDNEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:04:39 -0400
Content-Disposition: inline
In-Reply-To: <20130901233230.3018.51446.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 02, 2013 at 01:32:31AM +0200, Arturo Borrero Gonzalez wrote:
> This patch makes optional print/parse of some attributes
> of chain objects in XML.
> 
> In order to pass nft-parsing-test, some XML nodes are reordered.

Ok, let's put this in the tree, but I want a follow up patch to add a
flag to the XML helper parser function. That flag should indicate if
an element is optional or not.
