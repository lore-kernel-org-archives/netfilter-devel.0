From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] src: xml: convert family values to string
Date: Thu, 27 Jun 2013 19:59:13 +0200
Message-ID: <20130627175913.GB25681@localhost>
References: <20130627165615.27002.37788.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35389 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3F0R7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20130627165615.27002.37788.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 27, 2013 at 06:56:38PM +0200, Arturo Borrero Gonzalez wrote:
> This patch translates all family values all around the code to show a string:
>  * ip if AF_INET
>  * ip6 if AF_INET6
>  * bridge if AF_BRIDGE
>  * arp if 0

Applied, thanks.
