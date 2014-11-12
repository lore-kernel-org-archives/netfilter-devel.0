From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] autotools conversion: added autotools support for
 the 'doc' subdir.
Date: Wed, 12 Nov 2014 22:00:50 +0100
Message-ID: <20141112210050.GA11319@salvia>
References: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
 <1415810466-9410-3-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58927 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLU7C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:59:02 -0500
Content-Disposition: inline
In-Reply-To: <1415810466-9410-3-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 12, 2014 at 05:41:05PM +0100, Giorgio Dal Molin wrote:
> 'nft' documentation is originally contained in the XML file 'doc/nft.xml'.
> Processing this file with the proper tools we can obtain a PDF document,
>  'nft.pdf', and a unix man page, 'nft.8'.
> 
> To produce the PDF we need the tool 'dblatex' (current release pypi.python.org/pypi/dblatex/0.3.5).
> 
> To produce the man page we use the tool 'docbook2man'; it is part of the
> package 'docbook2X' (docbook2x.sourceforge.net). On some linux distributions
> the tool can have slightly different names as 'docbook2x-man' or
> 'db2x_docbook2man' so we search for all three names and use the first
> one found and issue the command:
> 
> # ${DB2MAN} --xinclude $<

Applied to the autotools branch. Thanks.
