From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/8] chain: Break the line properly when
 printing out the chain
Date: Tue, 11 Feb 2014 11:58:43 +0100
Message-ID: <20140211105843.GA4299@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaBKK6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:58:52 -0500
Content-Disposition: inline
In-Reply-To: <1392115608-6733-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 12:46:41PM +0200, Tomasz Bursztyka wrote:
> As when a rule is printed etc... It fixes a bug in iptables when
> printing out the chain in debug mode.

All the example in libnftnl rely on that missing \n, including nft.
Better fix this in iptables-compat?
