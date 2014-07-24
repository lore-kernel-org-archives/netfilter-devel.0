From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] set: add support for set mechanism selection
Date: Thu, 24 Jul 2014 13:02:21 +0200
Message-ID: <20140724110221.GA15239@salvia>
References: <20140714084126.4434.20059.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbaGXLCR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:02:17 -0400
Content-Disposition: inline
In-Reply-To: <20140714084126.4434.20059.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 14, 2014 at 10:41:26AM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds support to select the set mechanism.
> The kernel support was added in commit:
>  c50b960 netfilter: nf_tables: implement proper set selection

I have moved the policy out of the desc area so we have a 1:1 mapping
with what we have in the kernel.

I also fixed a compilation warning in XML code.

Applied, thanks Arturo.
