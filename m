From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 5/5] expr: reject: Do not print unset values in
 json
Date: Thu, 5 Jun 2014 15:20:27 +0200
Message-ID: <20140605132027.GH20181@localhost>
References: <1401881891-4990-1-git-send-email-anarey@gmail.com>
 <1401881891-4990-6-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42516 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaFENUc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:20:32 -0400
Content-Disposition: inline
In-Reply-To: <1401881891-4990-6-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 04, 2014 at 01:38:11PM +0200, Ana Rey wrote:
> It changes the parse and the snprint functions to omit unset values.
> 
> If It uses this rule:
> nft add rule ip test output input
> 
> It gets this json file:
> [...] "expr":[{"type":"reject","type":0,"code":0}]}
> 
> Now, That rule creates this json file without null values:
> [...] "expr":[{"type":"reject"}]}

Applied, thanks.
