From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCHv2 0/4] support for mini-gmp / embedded friendliness
Date: Wed, 7 Jan 2015 14:04:49 +0100
Message-ID: <20150107130449.GA17331@salvia>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49875 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbbAGNCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:02:35 -0500
Content-Disposition: inline
In-Reply-To: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 06, 2015 at 11:40:21PM +0100, Steven Barth wrote:
> mini-gmp is a minimal subset of libgmp maintained by the same people
> While libgmp compiles to >400KB, adding mini-gmp only results in a
> ~30KB size increase of nft without the need to link to gmplib.
> This increase usability on embedded platforms optimizing for size
> and having no other use for libgmp.
> 
> This patchset:
> * Adds mini-gmp from gmplib 6.0 and adds a configure switch
>   --with-mini-gmp to enable it
> * Replaces the use of unsupported functions (gmp_printf, gmp_sscanf)
>   with suitable replacements
> * Fixes some minor issues related to the change
> 
> Steven Barth (4):
>   parser: rename VERSION token to HDRVERSION
>   datatype: use mpz_set_str instead of gmp_sscanf
>   erec: use stdio vasprintf instead of gmp_vasprintf
>   build: add --with-mini-gmp switch to use mini-gmp instead of libgmp

Applied from 1 to 3 so you don't need to resend these 3 initial
patches.  Thanks.
