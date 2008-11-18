From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling
Date: Tue, 18 Nov 2008 20:30:42 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811182029280.2595@fbirervta.pbzchgretzou.qr>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com> <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr> <492305ED.8010207@oracle.com>
 <alpine.LNX.1.10.0811181919160.2316@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811181931480.2316@fbirervta.pbzchgretzou.qr> <492315D1.7090508@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39766 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYKRTao (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:30:44 -0500
In-Reply-To: <492315D1.7090508@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-18 20:21, John Haxby wrote:
> Jan Engelhardt wrote:
>> Specifically... iptables.h was removed from the install base in
>> commit v1.4.1.1-2-g72ed4ff, already and libiptc was previously
>> removed in v1.4.2-rc1-5-g415a858.
>>
>> So once you use(d) v1.4.2 or up, the problem would have never showed
>> up in the first place ;-)
>
> Thanks.   That points me in the right direction for persuading ipt_sysrq to
> compile on the various platforms I want it to compile on.

If you do not need the authentication bits (the SHA crypto and replay 
timing 'protection'), you can also use xt_SYSRQ in Xtables-addons.
