From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v3] ruleset: fix crash if we free sets included
 in the set_list
Date: Tue, 24 Feb 2015 14:47:56 +0100
Message-ID: <20150224134756.GC3589@salvia>
References: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbBXNo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 08:44:27 -0500
Content-Disposition: inline
In-Reply-To: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 24, 2015 at 09:10:32AM +0100, Alvaro Neira Ayuso wrote:
> When we parse a ruleset which has a rule using a set. First step is parse the
> set, set up an id and add it to a set list. Later, we use this set list to find
> the set associated to the rule and we set up the set id to the expression
> (lookup expression) of the rule.
> 
> The problem is if we return this set using the function
> nft_ruleset_parse_file_cb and we free this set. We have a crash when we try to
> iterate in the set list.
> 
> This patch solves it, cloning the set and adding the new set to the set list.

Applied, thanks.
