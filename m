From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v2 3/3] netfilter: nf_tables: add new
 expression nft_redir
Date: Thu, 16 Oct 2014 14:00:56 +0200
Message-ID: <20141016120056.GB3346@salvia>
References: <20141016102224.4715.64585.stgit@nfdev.cica.es>
 <20141016102403.4715.34436.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39014 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPL7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:59:37 -0400
Content-Disposition: inline
In-Reply-To: <20141016102403.4715.34436.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:25:08PM +0200, Arturo Borrero Gonzalez wrote:
> This new expression provides NAT in the redirect flavour, which is to
> redirect packets to local machine.

Please, apply this:

http://patchwork.ozlabs.org/patch/399263/

before your patches, and add the missing code to validate that the
redirect can be only used from the nat chain type.

Thanks.
