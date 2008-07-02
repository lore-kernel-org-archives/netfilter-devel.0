From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: Patches solving the same issue!?
Date: Wed, 02 Jul 2008 22:57:31 +0200
Message-ID: <1215032251.9467.11.camel@localhost.localdomain>
References: <> <1215021635-28691-1-git-send-email-jacob@internet24.de>
	 <1215021635-28691-2-git-send-email-jacob@internet24.de>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jesper Dangaard Brouer <jdb@comx.dk>
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:49541 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYGBU5d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:57:33 -0400
In-Reply-To: <1215021635-28691-2-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I can see from the list that Thomas Jacob <jacob@internet24.de>, and I
have just posted patches solving the same issue.

I promised Patrick that I would work on this issue, and I did.

Its running on our production servers, and I planned to release the
patch today as it has proven stable on production.  I guess Thomas was
just slightly faster than me ;-)

It was actually already released in the CPAN module IPTables::libiptc
(ver.0.08 released 2008-06-16).


We both use binary search, but with two slightly different approaches.

- My patch uses the existing data structure, and the existing
  algorithm for binary searching.

- Thomas builds a new data structure and implements a new binary
  search algorithm.

I must give Thomas that this binary search algo (taken from wikipedia)
is much more compact than the existing one.

Guess I cannot judge what patch is the best, as I'm biased...

