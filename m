From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Tue, 7 Dec 2010 14:23:40 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012071419390.22465@obet.zrqbmnf.qr>
References: <87sjyercks.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> <874oaroznk.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr> <87tyirnhs1.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061457220.29349@obet.zrqbmnf.qr>
 <4CFDCDEA.7000308@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ferenc Wagner <wferi@niif.hu>, netfilter-devel@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38057 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab0LGNXl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:23:41 -0500
In-Reply-To: <4CFDCDEA.7000308@msgid.tls.msk.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-12-07 07:02, Michael Tokarev wrote:

>06.12.2010 16:59, Jan Engelhardt wrote:
>[]
>> If the network is not up, the potential connections to the database
>> immediately terminate with "No route to host".
>
>This is only true if at least the loopback interface is up.

It is also true if it's down - http://picpaste.de/long-CssHoqqX.png
(What should have really been used if `ip r s table all`, because
all routes to a particular destination need to be absent.)
