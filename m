From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: do not install ip{,6}tables.h
Date: Tue, 29 Jul 2008 11:50:11 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807291137150.21011@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr> <488F0598.40202@netfilter.org> <488F1C08.1090403@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54223 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYG2PuO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:50:14 -0400
In-Reply-To: <488F1C08.1090403@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-07-29 09:32, Pablo Neira Ayuso wrote:
>>>
>>>     build: do not install ip{,6}tables.h
>>
>> Well, the same thing should apply for xtables.h. The iptables plugin API
>> has not been stable over the time. If we export that header file, we'll
>> have to get stuck to that API.

>The main point
>of the discussion is that neither this header nor any other in iptables
>- apart from libipq, of course - was designed to be exported.

xtables.h was exported *in the first place* to provide
this sort of API to other extensions.

>I just realized that iproute may use this, however, it does not since it
>keeps their own internal copy of the header files. Anyway, we should not
>break the ABI because that would break iproute's ipt - actually, I
>remember that such thing happened long time ago.
>So, apart from your addon thing, I don't see any other client for the
>xtables.h and you can also keep an internal copy of it.

iproute's ipt has been discussed; patchesh ave been submitted by me,
but it was not merged yet.
More projects than just Xtables-addons can use xtables.h --
xt_layer7 already compiles with it, ipt_ACCOUNT is just a blink away.
