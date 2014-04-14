From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] target, match: Fix an invalid read
Date: Mon, 14 Apr 2014 15:09:11 +0200
Message-ID: <20140414130911.GA22518@localhost>
References: <5de83fb1d752c0e4582b4ed41c150bb4bf2f187e.1397467220.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaDNNJQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:09:16 -0400
Content-Disposition: inline
In-Reply-To: <5de83fb1d752c0e4582b4ed41c150bb4bf2f187e.1397467220.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 11:50:37AM +0200, Ana Rey wrote:
> Valgrind reports the following invalid read:
> 
> $ sudo valgrind --leak-check=full ./nft-parsing-test -f ../jsonfiles/35-rule-target.json
> ( and similar result with jsonfiles/29-rule-match.json file)
> 
> ==26018== Invalid read of size 8
> ==26018==    at 0x4E484E3: nft_rule_expr_target_set (target.c:46)

Applied, thanks Ana.
