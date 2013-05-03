From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] src: delete exporting internal flags in
 XML
Date: Fri, 3 May 2013 18:22:21 +0200
Message-ID: <20130503162221.GA5129@localhost>
References: <20130429123607.26114.18073.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab3ECQWb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 May 2013 12:22:31 -0400
Content-Disposition: inline
In-Reply-To: <20130429123607.26114.18073.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 29, 2013 at 02:36:07PM +0200, Arturo Borrero wrote:
> The uint32_t flags attribute is internal, so no need to
> export/import in XML.

Applied, thanks Arturo.
