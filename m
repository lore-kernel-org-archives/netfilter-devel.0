From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 00/18] netfilter: IPv6 NAT
Date: Fri, 23 Dec 2011 14:08:58 +0100
Message-ID: <20111223130858.GA10150@1984>
References: <1322153850-10533-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	ulrich.weber@sophos.com
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab1LWNJG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:09:06 -0500
Content-Disposition: inline
In-Reply-To: <1322153850-10533-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Thu, Nov 24, 2011 at 05:57:11PM +0100, kaber@trash.net wrote:
> The following patches contain the updated IPv6 NAT patchset forward ported
> to 3.2-rc3.

I've applied patches from 1 to 7. They are independent of the
IPv6 NAT support so they are safe to be applied.

Please, rebase your tree once they have hit davem's tree. Make sure
you rebase your tree before final submission of the IPv6 NAT support.

Thanks!
