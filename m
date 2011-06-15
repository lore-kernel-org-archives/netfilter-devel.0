From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/2] conntrack: permit updating only a part of the ctmark
Date: Wed, 15 Jun 2011 14:13:38 +0200
Message-ID: <1308140020-13487-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36349 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab1FOMLw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:11:52 -0400
Received: id: fw by Chamillionaire.breakpoint.cc authenticated by fw with local
	(easymta 1.00 BETA 1)
	id 1QWowp-0006Yb-2T
	for netfilter-devel@vger.kernel.org; Wed, 15 Jun 2011 14:11:51 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

here are two patches for conntrack(8).

I want to alter the upper 8 bits of the conntrack mark while keeping
the rest intact.  At the moment it is only possible to specifiy
an absolute value, so i've extended --mark to optionally handle
a mask argument.  Its possible to either filter by mark (e.g.
list conntracks with a particular mark bit set) or to update
parts of the mark.

The 2nd patch is not absolutely needed, but it speeds up operation
when only a couple of conntracks are affected by the modification.

Thanks,
Florian
