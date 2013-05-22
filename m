From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [nftables PATCH] rule: display rule handle as comment
Date: Wed, 22 May 2013 15:53:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1305221512110.26402@ask.diku.dk>
References: <1369091340-29211-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Jesper Brouer <brouer@redhat.com>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:52013 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab3EVOMz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 10:12:55 -0400
In-Reply-To: <1369091340-29211-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tue, 21 May 2013, Eric Leblond wrote:

> Knowing the rule handle is necessary to be able to delete a single
> rule. It was not displayed till now in the output and it was thus
> impossible to remove a single rule.

The current iptables system supports deleting a specific rule by simply 
specifying iptables -D [...] instead of equivilant iptables -A [...]

Would it be possible to keep this semantics in nftables?

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
