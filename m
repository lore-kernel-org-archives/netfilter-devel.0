From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 07/30] Renice to -1 on startup
Date: Fri, 01 Feb 2008 10:12:02 +0100
Message-ID: <87hcgtf3bx.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190127.273612103@kruemel.intranet.astaro.de>
	<47A2965A.6090504@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:53067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYBAJMQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:12:16 -0500
In-Reply-To: <47A2965A.6090504@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:47:38 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Also interesting, do you really observe a real improvement? I'll try
> this with conntrackd tomorrow in my testbed.

Yes, there is a real improvement by that.  Especially on systems
whith many contending processes this is a real improvement.

 /holger
