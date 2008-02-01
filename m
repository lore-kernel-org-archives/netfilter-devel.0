From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 22/30] Add set_sockbuf_len()
Date: Fri, 01 Feb 2008 09:20:21 +0100
Message-ID: <871w7xay0q.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190129.323941901@kruemel.intranet.astaro.de>
	<47A2970D.2010208@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:51594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYBAIUX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:20:23 -0500
In-Reply-To: <47A2970D.2010208@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:50:37 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> AFAIK, there's a similar function in libnfnetlink which uses
> SO_RCVBUF_FORCE instead.

Thanks for the info.  libnl also implements a similar kind of
function.  At the time I completely switch that I'll of course
use that one.

 /holger
