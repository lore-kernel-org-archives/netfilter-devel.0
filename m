From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling
Date: Tue, 18 Nov 2008 19:33:19 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181931480.2316@fbirervta.pbzchgretzou.qr>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com> <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr> <492305ED.8010207@oracle.com>
 <alpine.LNX.1.10.0811181919160.2316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56709 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKRSdU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:33:20 -0500
In-Reply-To: <alpine.LNX.1.10.0811181919160.2316@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-18 19:27, Jan Engelhardt wrote:
>On Tuesday 2008-11-18 19:14, John Haxby wrote:
>> Jan Engelhardt wrote:
>>>
>>>> /usr/include/iptables.h:5:29: error: libiptc/libiptc.h: No such file or
>>>> directory
>>>
>>> [Try] Blame the Fedora packager for that.
>>> libiptc.h is installed with the raw iptables tarball since 1.4.0+git61.
>>
>> I'd love to, but:[...]
>> Clearly I'm doing something wrong.   Could you enlighten me?
>
>In short, including iptables.h is not appropriate anymore; for
>all the important definitions have moved to xtables.h.

Specifically... iptables.h was removed from the install base in
commit v1.4.1.1-2-g72ed4ff, already and libiptc was previously
removed in v1.4.2-rc1-5-g415a858.

So once you use(d) v1.4.2 or up, the problem would have never showed
up in the first place ;-)
