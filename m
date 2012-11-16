From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:nf_tables-experiments PATCH] nf_tables: Fix up build
 issue on IPv6 NAT support
Date: Fri, 16 Nov 2012 10:56:01 +0100
Message-ID: <20121116095601.GA25746@1984>
References: <1353051779-21341-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2KPJ4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:56:09 -0500
Content-Disposition: inline
In-Reply-To: <1353051779-21341-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 16, 2012 at 09:42:59AM +0200, Tomasz Bursztyka wrote:
> A left-over from IPv4 NAT which was not detected at first since
> CONFIG_NETFILTER_DEBUG was not enabled when compiling.

Applied, thanks for your quick reply Tomasz.

Note that I've renamed nf_tables-experiments branch to nf_tables8, so
the former does not exist anymore.
