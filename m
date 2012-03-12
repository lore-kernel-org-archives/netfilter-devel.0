From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: missing free() in function cache_add_entry()
Date: Mon, 12 Mar 2012 13:09:17 +0100
Message-ID: <20120312120917.GA31595@1984>
References: <20120308152037.639adf51@frequentis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, franz.flasch@frequentis.com
To: Christian Engelmayer <christian.engelmayer@frequentis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47690 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2CLMJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:09:24 -0400
Content-Disposition: inline
In-Reply-To: <20120308152037.639adf51@frequentis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 08, 2012 at 03:20:37PM +0100, Christian Engelmayer wrote:
> From: Franz Flasch <franz.flasch@frequentis.com>
> 
> Fixed a memory leak in the error path of function cache_add_entry().

Applied, thanks.
