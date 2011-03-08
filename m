From: Thomas Graf <tgraf@infradead.org>
Subject: XT_CONTINUE/EBT_CONTINUE for universal modules
Date: Tue, 8 Mar 2011 07:08:15 -0500
Message-ID: <20110308120815.GA28673@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1CHMIS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:08:18 -0500
Received: from canuck.infradead.org ([2001:4978:20e::1])
	by bombadil.infradead.org with esmtps (Exim 4.72 #1 (Red Hat Linux))
	id 1Pwvi5-0001E0-Br
	for netfilter-devel@vger.kernel.org; Tue, 08 Mar 2011 12:08:17 +0000
Received: from tgr by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat Linux))
	id 1Pwvi3-0001rK-Ek
	for netfilter-devel@vger.kernel.org; Tue, 08 Mar 2011 12:08:15 +0000
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

xt_AUDIT.c currently returns XT_CONTINUE. The module is universal and would
be useable from ebtables if it wasn't for ebtables to expect EBT_CONTINUE.

Is the only way around this cloning xt_AUDIT.c to ebt_audit.c? I've seen
some patches from Jan converting ebtables to use xtables infrastucture
but they haven't been merged.
