From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables branch management
Date: Fri, 2 Sep 2011 16:20:13 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57349 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1IBOUR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:20:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hei


I would like to propose a "stable" branch that would be rooted 
in the most recent tag and only receive fixes. Furtheremore, 
the branch is merged time and again into master, so that the 
fix is available in both without cherry-pick. 1.4.12.x releases be made 
from stable, and 1.4.y from master.
How about it?
