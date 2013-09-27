From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] nfnetlink_log: use proper net to allocate skb
Date: Fri, 27 Sep 2013 16:26:47 +0200
Message-ID: <20130927142647.GB12260@localhost>
References: <1379935256-18598-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1379935256-18598-2-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46663 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab3I0O0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:26:55 -0400
Content-Disposition: inline
In-Reply-To: <1379935256-18598-2-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 23, 2013 at 07:20:56PM +0800, Gao feng wrote:
> Use proper net struct to allocate skb, otherwise
> netlink mmap will be of no effect.

Also applied, thanks Gao.
