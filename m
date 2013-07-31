From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH] xtables: Do not dump before command
 parsing has been finished
Date: Wed, 31 Jul 2013 19:12:32 +0200
Message-ID: <20130731171232.GA5248@localhost>
References: <1375273132-10169-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53147 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab3GaRMv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:12:51 -0400
Content-Disposition: inline
In-Reply-To: <1375273132-10169-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 31, 2013 at 03:18:52PM +0300, Tomasz Bursztyka wrote:
> On xtables-save.c, -d will not output right away but after the full
> command line hase been parsed.

Applied, thanks Tomasz.
