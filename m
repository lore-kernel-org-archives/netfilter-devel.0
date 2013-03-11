From: Jan Engelhardt <jengelh@inai.de>
Subject: conntrack-tools: dying and unconfirmed list not accessible
Date: Mon, 11 Mar 2013 13:45:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303111344120.25847@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:53243 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3CKMpp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:45:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


In kernel 3.7.10 and a recent conntrack-tools, there seems to be a 
problem with dumping the dying and confirm list.

# conntrack -L dying
conntrack v1.4.1 (conntrack-tools): Operation failed: invalid parameters
# conntrack -L unconfirmed
conntrack v1.4.1 (conntrack-tools): Operation failed: invalid parameters

Is it perhaps that this is 3.8.x material?

The two new tables should also get a description in conntrack.8.


thanks,
Jan
