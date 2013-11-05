From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: Fix a build issue on header inclusion
 in internal.h
Date: Tue, 5 Nov 2013 10:13:20 +0100
Message-ID: <20131105091320.GA4011@localhost>
References: <1383638619-10735-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEJNZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:13:25 -0500
Content-Disposition: inline
In-Reply-To: <1383638619-10735-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 05, 2013 at 10:03:39AM +0200, Tomasz Bursztyka wrote:
> Fixes:
> In file included from utils.c:11:0:
> ./internal.h:93:17: error: unknown type name 'FILE'
>  int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int
>  (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type,
>  uint32_t flags));

Applied, thanks Tomasz.
