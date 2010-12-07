From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Tue, 07 Dec 2010 09:02:18 +0300
Message-ID: <4CFDCDEA.7000308@msgid.tls.msk.ru>
References: <87sjyercks.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> <874oaroznk.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr> <87tyirnhs1.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061457220.29349@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ferenc Wagner <wferi@niif.hu>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:51419 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0LGGCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:02:21 -0500
In-Reply-To: <alpine.LNX.2.01.1012061457220.29349@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

06.12.2010 16:59, Jan Engelhardt wrote:
[]
> If the network is not up, the potential connections to the database
> immediately terminate with "No route to host".

This is only true if at least the loopback interface is up.
If no interface is up-n-running, the connection times out,
slowly.

It is for this reason I usually put firewall rules in
post-up of loopback interface.

/mjt
