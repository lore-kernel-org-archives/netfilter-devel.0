From: Patrick McHardy <kaber@trash.net>
Subject: Re: security impact of creating rulesets with iptables (cmd)
Date: Mon, 10 Aug 2009 08:58:18 +0200
Message-ID: <4A7FC50A.80608@trash.net>
References: <4A7F431E.70706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56116 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZHJG6V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:58:21 -0400
In-Reply-To: <4A7F431E.70706@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> Hi,
> 
> I read Jan's "Towards the perfect ruleset" paper [1]
> 
> [1] http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf
> 
> and I would have a question about the mentioned security risk when
> creating hole rulesets with the iptables command (chapter 3).
> 
> I understand why it is a bad idea to create n rules by using multiple
> times iptables -A... (instead of iptables-restore) because it
> "downloads" the entire table n-times and sets the entire table n-times
> (performing n*2 operations) while passing n^2 rules between kernel and
> userspace.
> 
> The second and more interesting point is that this would also introduce
> a timeframe where packets could slip through while these exchanges
> between kernel and userspace are happening. Why does setting the policy
> to DROP not solve this problem?

This is not correct, the replacement is atomic.

