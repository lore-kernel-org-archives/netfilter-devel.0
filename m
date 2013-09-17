From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfnetlink_queue: shouldn't it be entry->skb?
Date: Tue, 17 Sep 2013 13:09:39 +0200
Message-ID: <20130917110939.GA20500@localhost>
References: <5237EC14.5010908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33954 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab3IQLJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:09:50 -0400
Content-Disposition: inline
In-Reply-To: <5237EC14.5010908@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 17, 2013 at 01:43:48PM +0800, Gao feng wrote:
> skb is the netlink type sk_buff, shouldn't we pass entry->skb to nfqnl_ct_seq_adjust?
> Since I'm blocked by how to send proper netlink message to make nfqnl_ct_parse find
> out ct :( , I haven't confirmed this problem. :(

That's right, I have pushed a patch for this, thanks.
