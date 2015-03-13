From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-ct 0/2] add mark event filter
Date: Fri, 13 Mar 2015 14:13:28 +0100
Message-ID: <20150313131328.GA1125@salvia>
References: <20150312221826.GA20782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52765 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbCMNJj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2015 09:09:39 -0400
Content-Disposition: inline
In-Reply-To: <20150312221826.GA20782@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 13, 2015 at 07:18:26AM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hi,
> 
> This patchset adds mark filter for event listener and its test.
> Would you review?

Looks fine.

It would be good if someone can send follow up patches to:

1) Replace hardcoded '127' values by constants.

2) Assert on too many address/mark/etc instead of silently ignoring.
   The existing behaviour doesn't look good to me as the user will not
   know that it has reach the limit. Unfortunately this function was not
   designed at that time to return an error instead, so we cannot change
   that :-(
