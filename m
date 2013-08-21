From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: constify nft_*_parse input data
Date: Wed, 21 Aug 2013 19:07:02 +0200
Message-ID: <20130821170702.GA7947@localhost>
References: <20130821122127.32150.32227.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3HUSj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:39:59 -0400
Content-Disposition: inline
In-Reply-To: <20130821122127.32150.32227.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 21, 2013 at 02:21:28PM +0200, Arturo Borrero Gonzalez wrote:
> Since the input string is not changing, let's make it constant.

I hit these compilation warnings:

table.c: In function 'nft_table_json_parse':
table.c:278:2: warning: passing argument 1 of 'nft_jansson_create_root' discards 'const' qualifier from pointer target type [enabled by default]
In file included from table.c:11:0:
internal.h:51:9: note: expected 'char *' but argument is of type 'const char *'
chain.c: In function 'nft_chain_json_parse':  CC     expr.lo
rule.c: In function 'nft_rule_json_parse':
chain.c:492:2: warning: passing argument 1 of 'nft_jansson_create_root' discards 'const' qualifier from pointer target type [enabled by default]
In file included from chain.c:11:0:
internal.h:51:9: note: expected 'char *' but argument is of type 'const char *'
rule.c:489:2: warning: passing argument 1 of 'nft_jansson_create_root' discards 'const' qualifier from pointer target type [enabled by default]
In file included from rule.c:11:0:
internal.h:51:9: note: expected 'char *' but argument is of type 'const char *'

Please, fix them and resend. Thanks.
