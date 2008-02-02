From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 04/15] Add IFI list
Date: Sat, 02 Feb 2008 23:56:25 +0100
Message-ID: <47A4F519.4020203@netfilter.org>
References: <20080202204826.267107164@astaro.com>	<20080202205107.726859754@astaro.com> <47A4E258.2060907@netfilter.org> <87zluj81uc.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54374 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755797AbYBBW4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:56:39 -0500
In-Reply-To: <87zluj81uc.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>> AFAICS, this file implements something similar to the ifname2index API
>> which lives in libnfnetlink. Why don't you that instead? See the
>> utils/iftest.c file under libnfnetlink for an example.
> 
> The version of libnfnetlink I used initially did not have that, nor
> would I ever expect for libnfnetlink to provide that functionality.

libnfnetlink provides that since July 2007 because other libraries, such
as libnetfilter_queue need such feature. There was a discussion way back
and I decided to it there.

> So I would leave it as-is in order to be able to build ulogd against
> older librarires.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
