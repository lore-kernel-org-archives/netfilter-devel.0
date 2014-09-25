From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] man: fix hyphen used as minus sign
Date: Thu, 25 Sep 2014 19:25:18 +0200
Message-ID: <20140925172518.GA14697@salvia>
References: <20140925094510.28102.78262.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, formorer@debian.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34888 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbaIYRYO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:24:14 -0400
Content-Disposition: inline
In-Reply-To: <20140925094510.28102.78262.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 25, 2014 at 11:45:11AM +0200, Arturo Borrero Gonzalez wrote:
> Report from Debian's lintian:
> 
>  This manual page seems to contain a hyphen where a minus sign was
>  intended. By default, "-" chars are interpreted as hyphens (U+2010) by
>  groff, not as minus signs (U+002D). Since options to programs use minus
>  signs (U+002D), this means for example in UTF-8 locales that you cannot
>  cut and paste options, nor search for them easily.
>  [...]

Applied, thanks.
