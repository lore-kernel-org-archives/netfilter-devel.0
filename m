From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCHv2 0/4] support for mini-gmp / embedded friendliness
Date: Wed, 7 Jan 2015 13:22:18 +0100
Message-ID: <20150107122218.GA15735@salvia>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38323 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbbAGMTc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:19:32 -0500
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

I think you mentioned to me already but

 configure: error: --with-mini-gmp MUST be used with --disable-debug

any reason to enforce this?
