From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] header: use sysconf() instead of getpagesize()
Date: Mon, 2 Mar 2015 12:06:00 +0100
Message-ID: <20150302110600.GA5220@salvia>
References: <20150226130837.GA3655@salvia>
 <1424957883-12444-1-git-send-email-markus.teich@stusta.mhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Markus Teich <markus.teich@stusta.mhn.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40382 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbCBLCY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 06:02:24 -0500
Content-Disposition: inline
In-Reply-To: <1424957883-12444-1-git-send-email-markus.teich@stusta.mhn.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 26, 2015 at 02:38:03PM +0100, Markus Teich wrote:
> The sysconf(_SC_PAGESIZE) call is more portable since it does not need
> _BSD_SOURCE defined.

Applied, thanks.
