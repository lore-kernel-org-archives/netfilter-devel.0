From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libmnl] portability of getpagesize() in libmnl.h
Date: Thu, 26 Feb 2015 14:08:37 +0100
Message-ID: <20150226130837.GA3655@salvia>
References: <20150224204550.GZ3453@trolle>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Markus Teich <teichm@fs.tum.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbbBZNFN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 08:05:13 -0500
Content-Disposition: inline
In-Reply-To: <20150224204550.GZ3453@trolle>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 24, 2015 at 09:45:50PM +0100, Markus Teich wrote:
> Heyho,
> 
> the getpagesize() call in line
> 
> #define MNL_SOCKET_BUFFER_SIZE (getpagesize() < 8192L ? getpagesize() : 8192L)
> 
> of libmnl.h seems to be less portable than sysconf(_SC_PAGESIZE) as suggested by
> the getpagesize man page. getpagesize() needs e.g. _BSD_SOURCE while sysconf()
> does not.
> 
> Would you consider fixing this or should I write a patch?

Go send a patch that I can apply via 'git am'. Thanks.
