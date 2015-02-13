From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] rule: don't release the tree parameter in
 the function nft_jansson_parse_rule
Date: Fri, 13 Feb 2015 16:56:55 +0100
Message-ID: <20150213155655.GA6280@salvia>
References: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42340 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbbBMPxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2015 10:53:40 -0500
Content-Disposition: inline
In-Reply-To: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 11, 2015 at 10:12:21PM +0100, Alvaro Neira Ayuso wrote:
> Already, we release the tree that we receive from the parameter in
> nft_jansson_parse_rule. With this patch, we're going to release the tree where
> we create it. Therefore, we will have a code more traceable and readable.

Applied.
