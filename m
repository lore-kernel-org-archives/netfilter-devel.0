From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] test: add testbench for XML
Date: Thu, 27 Jun 2013 21:34:59 +0200
Message-ID: <20130627193459.GA5425@localhost>
References: <20130627180824.10906.42385.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47534 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3F0TfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:35:09 -0400
Content-Disposition: inline
In-Reply-To: <20130627180824.10906.42385.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 27, 2013 at 08:09:34PM +0200, Arturo Borrero Gonzalez wrote:
> This patch add a testbench for XML parsing, which may be extended to also test JSON.
> 
> To use it:
>  $ cd test/
>  $ make nft-parsing-test
>  $ ./nft-parsing-test xmlfiles/
> 
> This testbench supersedes old .sh test scripts, so they are deleted.

Applied, with changes:

* Removed json skeleton code in the test
* used directory 'tests' instead of 'test'
* colorized output

Thanks
