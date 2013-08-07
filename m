From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] table: add nft_table_list_del function
Date: Wed, 7 Aug 2013 11:44:06 +0200
Message-ID: <20130807094406.GA830@localhost>
References: <20130801124546.13382.18859.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59921 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab3HGJoK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:44:10 -0400
Content-Disposition: inline
In-Reply-To: <20130801124546.13382.18859.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Thu, Aug 01, 2013 at 02:45:46PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds the function nft_table_list_del(), that allows to delete
> elements from a struct nft_table_list.

Do you need this? Otherwise, you know that I'm reticent to add
new interfaces that we don't need at this moment.

If you indeed need it, please add it to other objects as well. Thanks.
