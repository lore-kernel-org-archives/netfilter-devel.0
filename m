From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next] netfilter: nf_tables: limit maximum table name
 length to 32 bytes
Date: Thu, 5 Mar 2015 14:05:32 +0000
Message-ID: <20150305140532.GH29092@acer.localdomain>
References: <1425564336-7265-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60742 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbbCEOFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 09:05:36 -0500
Content-Disposition: inline
In-Reply-To: <1425564336-7265-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.03, Pablo Neira Ayuso wrote:
> Set the same as we use for chain names, it should be enough.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Patrick: I'm planning to add per-table information after the name field, this
> will make it easier and this stays consistent to what we have in chains and
> sets (and other new object we'll add). I wouldn't expect people using larger
> names than this limit.

What kind of information are we talking about?
