From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD 04/15] Add IFI list
Date: Sat, 02 Feb 2008 22:50:35 +0100
Message-ID: <87zluj81uc.fsf@kruemel.eitzenberger.org>
References: <20080202204826.267107164@astaro.com>
	<20080202205107.726859754@astaro.com> <47A4E258.2060907@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:54136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYBBVui (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:50:38 -0500
In-Reply-To: <47A4E258.2060907@netfilter.org> (Pablo Neira Ayuso's message
 of "Sat, 02 Feb 2008 22:36:24 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> AFAICS, this file implements something similar to the ifname2index API
> which lives in libnfnetlink. Why don't you that instead? See the
> utils/iftest.c file under libnfnetlink for an example.

The version of libnfnetlink I used initially did not have that, nor
would I ever expect for libnfnetlink to provide that functionality.

So I would leave it as-is in order to be able to build ulogd against
older librarires.
