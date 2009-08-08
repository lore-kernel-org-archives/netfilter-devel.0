From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fwd: ipset bug
Date: Sat, 8 Aug 2009 11:04:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908081104230.29435@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44767 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbZHHJEj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:04:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Maybe you can do something with this:

When an ipset is created it is appended to the list of ipsets.
On ipset -S the list is saved in that same order.

Setlists are dependant on previously declared ipsets so appended
sets of any type are not included even if they exist.

Ipsets should be stored and saved in the order of their dependencies,
not the order of their declarations.
Currently only manual editing the saved file will restore order.

Marty B.

-- 
An artist who is forced to work a specific schedule, is no longer
an artist; he is just hired help. Inspiration cannot be purchased.

