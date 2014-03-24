From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Mon, 24 Mar 2014 15:57:38 +0100
Message-ID: <20140324145738.GB32472@localhost>
References: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50561 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaCXO5q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:57:46 -0400
Content-Disposition: inline
In-Reply-To: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 21, 2014 at 06:39:00PM +0100, Giuseppe Longo wrote:
> checks if the name of set is larger than 16 chars
> before to add it.
> If so, the set is not added and an error message is printed.
> 
> I didn't figure out why, but another error message is printed, see below:
> 
> nft add set ip test thenameofthissetistoolooong { type ipv4_address\; }
> <cmdline>:1:17-43: Error: set name is too long (> 16)
> add set ip test thenameofthissetistoolooong { type ipv4_address; }
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> <cmdline>:1:66-66: Error: syntax error, unexpected '}'
> add set ip test thenameofthissetistoolooong { type ipv4_address; }

I sent you a patch, I think it's better if we fix this from
kernel-space.
