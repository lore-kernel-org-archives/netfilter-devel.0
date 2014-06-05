From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 3/5] expr: reject: Do not print unset values in
 xml
Date: Thu, 5 Jun 2014 15:19:49 +0200
Message-ID: <20140605131949.GF20181@localhost>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
 <1401881891-4990-4-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFENUC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:20:02 -0400
Content-Disposition: inline
In-Reply-To: <1401881891-4990-4-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 04, 2014 at 01:38:09PM +0200, Ana Rey wrote:
> It changes the parse and the snprint functions to omit unset values.
> 
> If we used this rule:
> nft add rule ip test output reject
> 
> It gets this xml file:
> [...]
> <expr type="reject">
> 	<type>0</type>
> 	<code>0</code>
> </expr>
> </rule></nftables>
> 
> Now, That rule creates this xml file without null values:
> 
> [...]
> <expr type="reject">
> </expr>
> </rule></nftables>

Applied, thanks.
