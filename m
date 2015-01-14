From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate hooks in NAT
 expressions
Date: Wed, 14 Jan 2015 17:17:31 +0000
Message-ID: <20150114171730.GF5710@acer.localdomain>
References: <1421254861-18698-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com,
	linkerpro@mail.ru
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbbANRRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:17:36 -0500
Content-Disposition: inline
In-Reply-To: <1421254861-18698-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01, Pablo Neira Ayuso wrote:
> The user can crash the kernel if it configures the NAT chain in the
> wrong hook, so validate that the expression is used from the right
> hook when loading the rule.
> 
> This patch introduces nft_chain_validate_hooks() which is based on
> existing code in the bridge version of the reject expression.

But this will still allow use in non base chains that are called
from incorrect chains, right?
