From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 0/8] textsearch: case insensitive pattern matching for netfilter
Date: Tue, 24 Jun 2008 01:27:56 +0200
Message-ID: <20080623232756.GH20815@postel.suug.ch>
References: <b25c3fa70806210054o74a46068ifa3b396662080265@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>
To: Joonwoo Park <joonwpark81@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:32842 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbYFWX1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:27:35 -0400
Content-Disposition: inline
In-Reply-To: <b25c3fa70806210054o74a46068ifa3b396662080265@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Joonwoo Park <joonwpark81@gmail.com> 2008-06-21 00:54
> This patchset aim at supporting case insensitive text search for netfilter
> string extension.
> It contains fixing of Boyer-Moore algorithm and Knuth-Morris-Pratt algorithm.
> Also this includes bug fixing of Boyer-Moore algorithm.

All patches look good, except that a general flags field in ts_config
would make features like this easier to add going forward.

It should be noted that this may slow down the algorithms noticeable for
very large strings such as skb data buffers.
