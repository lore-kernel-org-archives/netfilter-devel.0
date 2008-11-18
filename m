From: John Haxby <john.haxby@oracle.com>
Subject: Re: Problem compiling
Date: Tue, 18 Nov 2008 19:21:53 +0000
Message-ID: <492315D1.7090508@oracle.com>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com> <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr> <492305ED.8010207@oracle.com> <alpine.LNX.1.10.0811181919160.2316@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811181931480.2316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:25309 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYKRTWG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:22:06 -0500
In-Reply-To: <alpine.LNX.1.10.0811181931480.2316@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Specifically... iptables.h was removed from the install base in
> commit v1.4.1.1-2-g72ed4ff, already and libiptc was previously
> removed in v1.4.2-rc1-5-g415a858.
>
> So once you use(d) v1.4.2 or up, the problem would have never showed
> up in the first place ;-)
>   

Thanks.   That points me in the right direction for persuading ipt_sysrq 
to compile on the various platforms I want it to compile on.

jch
