From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 05/30] Add signalling subsystem
Date: Fri, 01 Feb 2008 09:18:12 +0100
Message-ID: <8763x9ay4b.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190127.013311819@kruemel.intranet.astaro.de>
	<47A295FA.2040709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:58253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYBAISW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:18:22 -0500
In-Reply-To: <47A295FA.2040709@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:46:02 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Hm, why do we poll now every 1 second event even if there's nothing to do?

AFAIRK I initially planned to use that for timers.  But yes, this is
worth to be removed later on.  Thanks.

  /holger

