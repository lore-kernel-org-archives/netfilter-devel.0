From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 05/30] Add signalling subsystem
Date: Fri, 01 Feb 2008 11:11:44 +0100
Message-ID: <87lk65f0kf.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190127.013311819@kruemel.intranet.astaro.de>
	<47A295FA.2040709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:64301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYBAKLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:11:47 -0500
In-Reply-To: <47A295FA.2040709@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:46:02 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

>> +	i = select(maxfd+1, &readset, &writeset, &exceptset, &tv);
>
> Hm, why do we poll now every 1 second event even if there's nothing to do?

I just noticed that patch

 [ULOGD RFC 05/30] Add signalling subsystem

already does what you request.  So, in retrospect 1) I'll check my code
first before commenting and 2) you definitely should check those patches
in reverse order :).

 /holger

 
