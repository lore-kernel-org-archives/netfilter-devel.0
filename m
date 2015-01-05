From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft-sync PATCH 1/3] build: rename configure.in to configure.ac
Date: Mon, 5 Jan 2015 12:23:54 +0100
Message-ID: <20150105112354.GA13289@salvia>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55412 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbbAELVS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:21:18 -0500
Content-Disposition: inline
In-Reply-To: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 26, 2014 at 01:51:22PM +0100, Arturo Borrero Gonzalez wrote:
> % autoreconf -fi
> aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
> [...]
> aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
> automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'
> [...]
> automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'

Applied, thanks.

Please next time use format-patch -M80%, it detects renames and the
patch is way smaller and easier to review.
