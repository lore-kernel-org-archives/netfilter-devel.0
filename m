From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: missing free() in function delete_entry()
Date: Mon, 12 Mar 2012 13:13:11 +0100
Message-ID: <20120312121311.GB31595@1984>
References: <20120308152041.7a789c4f@frequentis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, franz.flasch@frequentis.com
To: Christian Engelmayer <christian.engelmayer@frequentis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49216 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab2CLMNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:13:18 -0400
Content-Disposition: inline
In-Reply-To: <20120308152041.7a789c4f@frequentis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 08, 2012 at 03:20:41PM +0100, Christian Engelmayer wrote:
> From: Franz Flasch <franz.flasch@frequentis.com>
> 
> Fixed a memory leak in the dry run path of function delete_entry().

Applied, thanks.

For your notice: I have put these in the master branch to skip the
overhead of maintaining -stable for the little amount of changes we
have had this time.

Since linux 3.3 is approaching, expect a new iptables release soon.
