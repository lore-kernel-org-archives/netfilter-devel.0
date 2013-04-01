From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ip[6]tables: show --protocol instead of --proto in usage
Date: Mon, 1 Apr 2013 13:18:40 +0200
Message-ID: <20130401111840.GA4062@localhost>
References: <5149C42E.4040900@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41614 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab3DALSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:18:53 -0400
Content-Disposition: inline
In-Reply-To: <5149C42E.4040900@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 20, 2013 at 03:14:06PM +0100, Mart Frauenlob wrote:
> Good day!
> 
> As the man page shows --protocol not --proto, also do so in the
> usage text displayed by ip[6]tables -h.
> 
> Attached patch does the change.

Applied, thanks.
