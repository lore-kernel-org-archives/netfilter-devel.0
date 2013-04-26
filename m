From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 0/4] libnetfilter_queue: gso handling support
Date: Fri, 26 Apr 2013 10:33:27 +0200
Message-ID: <1366965211-23412-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48572 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413Ab3DZIbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:31:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1UVe3u-0005qA-V0
	for netfilter-devel@vger.kernel.org; Fri, 26 Apr 2013 10:31:23 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this is V2 of the gso paches for libnetfilter_queue.

Changes since V1:
- refresh nfnetlink_queue.h with nf-next copy instead of removing it
- don't install internal.h on "make install"
- avoid magic number in example program

Thanks,
Florian

