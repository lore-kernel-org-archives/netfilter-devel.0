From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: do not install ip{,6}tables.h
Date: Tue, 29 Jul 2008 19:06:25 +0200
Message-ID: <488F4E11.8020106@netfilter.org>
References: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr> <488F0598.40202@netfilter.org> <488F1C08.1090403@netfilter.org> <alpine.LNX.1.10.0807291137150.21011@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51349 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662AbYG2RGh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:06:37 -0400
In-Reply-To: <alpine.LNX.1.10.0807291137150.21011@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-07-29 09:32, Pablo Neira Ayuso wrote:
>> I just realized that iproute may use this, however, it does not since it
>> keeps their own internal copy of the header files. Anyway, we should not
>> break the ABI because that would break iproute's ipt - actually, I
>> remember that such thing happened long time ago.
>> So, apart from your addon thing, I don't see any other client for the
>> xtables.h and you can also keep an internal copy of it.
> 
> iproute's ipt has been discussed; patchesh ave been submitted by me,
> but it was not merged yet.
> More projects than just Xtables-addons can use xtables.h --
> xt_layer7 already compiles with it, ipt_ACCOUNT is just a blink away.

xtables.h also requires libiptc/libxtc.h which is, AFAIK, a header of
the internal iptables' library - not initially intended for external use.

Well, after all, it's ugly but it's not that bad as it only allows
people use the extension plugin API. I have committed your patch.

BTW, do we support C++ extensions for iptables? Hm, really?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
