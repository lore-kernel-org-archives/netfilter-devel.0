From: Patrick McHardy <kaber@trash.net>
Subject: nftables transaction semantics
Date: Mon, 2 Mar 2015 11:51:41 +0000
Message-ID: <20150302115141.GC6142@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32983 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbCBLvq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 06:51:46 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm looking at the nftables transaction code and wondering about the
semantics of GET operations intermixed with ADD/DEL operations:

AFAIK there are currently some inconsistencies:

- new sets get marked as inactive and invisible to GET until the
  transaction is supported. So

  ADD set
  GET set

  will return ENOENT.

- Rule GET operations OTOH don't care about the activeness of the rule
  at all, so

  DEL rule
  GET rule

  will return the rule even though it is actually deleted.

  ADD rule
  GET rule
  transaction fail

  Will equally return the rule even though it will afterwards not be
  present.

So the general question is how to properly handle this. GET operations
should obviously take activeness into account and not return deleted
objects.

The next question would be how to handle failed transactions. We should
obviously only return new objects if the transaction actually succeeds,
so I guess this means handling GET requests in the commit path.

Any thoughts? Not sure if I missed something important.
