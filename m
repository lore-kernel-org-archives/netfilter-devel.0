From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 20:17:42 +0000
Message-ID: <20140112201742.GC13545@macbook.localnet>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49718 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALURq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:17:46 -0500
Content-Disposition: inline
In-Reply-To: <20140112194132.7369.3907.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 08:41:33PM +0100, Arturo Borrero Gonzalez wrote:
> Almost all shell uses the '>' character as a key for redirecting
> stdout/stderr to a file.
> So, using it in the syntax means that the administrator is forced to scape the
> character, or look for other workaround.
> 
> With this patch, '=>' is replaced with '=:', thus avoiding such situation.

I'm not opposed to this, but I like (despite the shell problematic) the =>
syntax better, so I'd suggest to just add an alternative syntax.

As further simplification, why not simply use ':'?
