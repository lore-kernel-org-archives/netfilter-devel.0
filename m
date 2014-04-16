From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] build: delete useless characters
Date: Wed, 16 Apr 2014 18:32:59 +0200
Message-ID: <20140416163258.GA30296@macbook.localnet>
References: <20140416161038.1237.5216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49128 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaDPQdD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:33:03 -0400
Content-Disposition: inline
In-Reply-To: <20140416161038.1237.5216.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 16, 2014 at 06:10:38PM +0200, Arturo Borrero Gonzalez wrote:
> There are a lot of '-e' that seem useless in the build system.
> 
> Previous to this patch:
>   [...]
>   -e CC		src/evaluate.c
>   -e CC		src/expression.c
>   -e CC		src/proto.c
>   [...]
> 
> 
> With this patch:
>   [...]
>   CC		src/evaluate.c
>   CC		src/expression.c
>   CC		src/proto.c
>   [...]

I assume you're on debian? The -e is needed to interpret the backslash
sequences like \t. Something is broken about the echo command in debian,
I'd assume its using the shell internal one instead of /bin/echo.

This needs to be fixed differently:

  CC\t\tsrc/main.c
  CC\t\tsrc/cli.c
  CC\t\tsrc/rule.c
  CC\t\tsrc/statement.c
  CC\t\tsrc/datatype.c
  CC\t\tsrc/expression.c
  CC\t\tsrc/evaluate.c
  CC\t\tsrc/proto.c
  CC\t\tsrc/payload.c
  CC\t\tsrc/exthdr.c
  CC\t\tsrc/meta.c
  CC\t\tsrc/ct.c
  CC\t\tsrc/netlink.c
  CC\t\tsrc/netlink_linearize.c
  CC\t\tsrc/netlink_delinearize.c
  CC\t\tsrc/segtree.c
  CC\t\tsrc/rbtree.c
  CC\t\tsrc/gmputil.c
  CC\t\tsrc/utils.c
  CC\t\tsrc/erec.c
  CC\t\tsrc/mnl.c
  CC\t\tsrc/hipac.c
  CC\t\tsrc/parser.c
  CC\t\tsrc/scanner.c

