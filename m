From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: use ':' instead of '=>' in dictionaries
Date: Thu, 16 Jan 2014 19:25:36 +0000
Message-ID: <20140116192536.GA18619@macbook.localnet>
References: <1389893842-17821-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58597 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAPTZj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:25:39 -0500
Content-Disposition: inline
In-Reply-To: <1389893842-17821-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 06:37:22PM +0100, Pablo Neira Ayuso wrote:
> Replace => by : to make it easier for most shell users, as
> > implies a redirection, let's avoid possible confusion that
> may result if you forget to escape it.
> 
> This works fine if you don't forget to add space between the
> key and the value. If you forget to add the space, depending
> on the case, the scanner may recognize it correctly or process
> it as a string.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Tested here with many combinations, works fine if you don't
> forget the spaces. If you do, the result in unspecified since
> depending on the combination it may accept it or spot a
> parsing error.

Looks good. Please push to master so we can avoid conflicts with
my patch to make set flags parsable.

