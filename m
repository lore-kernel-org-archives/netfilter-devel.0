From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] xt_TCPMSS: lookup route in proper net namesapce
Date: Fri, 27 Sep 2013 16:20:48 +0200
Message-ID: <20130927142048.GB10784@localhost>
References: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1380178831-20360-2-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45736 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab3I0OUw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:20:52 -0400
Content-Disposition: inline
In-Reply-To: <1380178831-20360-2-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 26, 2013 at 03:00:31PM +0800, Gao feng wrote:
> Otherwise the pmtu will be incorrect.

Applied, thanks.
