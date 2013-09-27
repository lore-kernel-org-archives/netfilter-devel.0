From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] =?utf-8?B?eHRfVENQTVNT77ya?= =?utf-8?Q?Get?= reserve
 mtu only when specifing option clamp-mss-to-pmtu
Date: Fri, 27 Sep 2013 16:20:35 +0200
Message-ID: <20130927142035.GA10784@localhost>
References: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab3I0OUn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:20:43 -0400
Content-Disposition: inline
In-Reply-To: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 26, 2013 at 03:00:30PM +0800, Gao feng wrote:
> Don't get reserve mtu when user sepcifies the mss through
> set-mss.

I see, some refactoring to save some cycles and prepare net namespace.

Applied, thanks.
