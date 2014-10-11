From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] src: cleanup in mxml and jansson regarding
 set_id parsing
Date: Sat, 11 Oct 2014 12:27:29 +0200
Message-ID: <20141011102729.GA11661@salvia>
References: <20141010194344.31948.59069.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alvaroneay@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37995 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaJKK0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:26:12 -0400
Content-Disposition: inline
In-Reply-To: <20141010194344.31948.59069.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 10, 2014 at 09:43:44PM +0200, Arturo Borrero Gonzalez wrote:
> jansson.c: In function 'nft_jansson_expr_parse':
> jansson.c:212:6: warning: pointer targets in passing argument 3 of 'nft_set_lookup_id' differ in signedness [-Wpointer-sign]
> In file included from jansson.c:10:0:
> ./internal.h:95:5: note: expected 'uint32_t *' but argument is of type 'int *'
> jansson.c:195:18: warning: unused variable 'set_cur' [-Wunused-variable]
> mxml.c: In function 'nft_mxml_expr_parse':
> mxml.c:97:6: warning: pointer targets in passing argument 3 of 'nft_set_lookup_id' differ in signedness [-Wpointer-sign]
> In file included from mxml.c:12:0:
> internal.h:95:5: note: expected 'uint32_t *' but argument is of type 'int *'
> mxml.c:68:18: warning: unused variable 'set_cur' [-Wunused-variable]

Oops, thanks Arturo.
