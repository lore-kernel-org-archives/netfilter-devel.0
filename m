From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] build: add --without-libgmp switch to disable use of
 shared libgmp
Date: Tue, 6 Jan 2015 22:25:21 +0100
Message-ID: <20150106212521.GA5981@salvia>
References: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
 <1419787065-26146-6-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58176 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbbAFVWf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:22:35 -0500
Content-Disposition: inline
In-Reply-To: <1419787065-26146-6-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 28, 2014 at 06:17:45PM +0100, Steven Barth wrote:
> This disables linking the >400 KB big libgmp and replace it with
> the builtin mini-gmp which only increases size by ~30KB.

This mini-gmp is useful for embedded environments.

Could you please merge patch 4/5 and 5/5?

For the option name, I'd suggest --with-mini-gmp.

Could you also update the INSTALL file to slightly describe this new
compile-time option?

Thanks.
