From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool PATCH 1/5] src: Fix base chain print out
Date: Fri, 30 Aug 2013 23:58:12 +0200
Message-ID: <20130830215812.GA5905@localhost>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1377678791-7616-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab3H3V6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:58:19 -0400
Content-Disposition: inline
In-Reply-To: <1377678791-7616-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 28, 2013 at 11:33:07AM +0300, Tomasz Bursztyka wrote:
> Relying on chain's hooknum to know whether the chain is a base one or
> not is bogus: having 0 as hooknum is a valid number. Thus setting the
> right flag and handling it is the way to go, as parser does already.

Applied, thanks.
