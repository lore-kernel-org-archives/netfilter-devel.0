From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 0/2] Scalability performance work on iptables/libiptc
Date: Mon, 26 Nov 2007 14:56:22 +0100
Message-ID: <1196085382.3866.56.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Paul C. Diem" <PCDiem@FoxValley.net>,
	Martin Josefsson <gandalf@netfilter.org>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:33946 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXKZN6Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:58:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

There are scalability/performance issues with iptables in libiptc.c,
when parsing/pulling-out the ruleset blob.  As I discussed shortly with
Harald and Martin during the workshop.

These patches performance optimize two scalability issues.

1) Sorting chain during pull-out give worst-case runtime O(Chains^2),
   reduced to O(Chains) only when creating a new chain.

2) Finding jump chains is suboptimal O(Chain*Rules), reduced to O(R)
   and chain offset lookup to O(1).

The idea behind these fixes are based upon patches posted by Paul
C. Diem <PCDiem@FoxValley.net> back in June+Oct 2006.

These performance issues will only be noticed when the rule set is
large enough.  For me, in real life, its actually a real performance
issue. On one production system (Rules=26209 and Chains=6233) it takes
10 seconds to create a new chain by calling "iptables -N test", with
these patches its reduced to 0.145 second.

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
