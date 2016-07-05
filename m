From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: nat: simplify & convert bysrc hash to rhashtable
Date: Tue,  5 Jul 2016 12:07:22 +0200
Message-ID: <1467713244-8555-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56165 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbcGEKHH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 06:07:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As discussed during NFWS in Amsterdam this gets rid of the 'ct' backpointer
in the nat extension structure.

We place nf_conn objects in the bysource table, then convert it to
rhashtable to get parallel insert and automated sizing of the table.

After these patches, we have one additional pointer in nf_conn
(same size as before due to alignment), nat extension area is
reduced to 8 byte instead of 32.

