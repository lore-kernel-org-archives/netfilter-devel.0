From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libmnl: fix valgrind warnings about padding
Date: Thu, 19 Apr 2012 00:56:33 +0200
Message-ID: <20120418225633.GA12354@1984>
References: <20120418113327.3d26501b@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44094 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab2DRW4h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:56:37 -0400
Content-Disposition: inline
In-Reply-To: <20120418113327.3d26501b@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 18, 2012 at 11:33:27AM -0700, Stephen Hemminger wrote:
> When using  mnl_nlmsg_put_extra_header() it pads out the addtional
> header but only zeros the original size not the padded value. Which
> cause valgrind to complain about sendto() with unitialized byte.

Applied, thanks Stephen.
