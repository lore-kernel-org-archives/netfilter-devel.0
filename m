From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] netfilter: nf_tables: dynamic set updates
Date: Wed, 8 Apr 2015 18:57:48 +0200
Message-ID: <20150408165748.GA7798@salvia>
References: <1428237668-31789-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbbDHQxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:53:42 -0400
Content-Disposition: inline
In-Reply-To: <1428237668-31789-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 05, 2015 at 02:41:04PM +0200, Patrick McHardy wrote:
> The following patches contain a small bug fix for set selection with
> timeouts, as well as support for dynamic set updates.
> 
> A new "dynset" expression type is added to dynamically add or update
> set elements. The name is not my first choice, however due to clashes
> with the regular set attributes simply "set" wasn't possible.
> Userspace exposes this in a nicer fashion.
> 
> As preparation, set size accounting is changed to use an atomic_t
> for the number of elements to avoid races, additionally set bindings
> are changed to not assume every binding is related to a lookup or map
> operation.

Series applied, thanks Patrick.
