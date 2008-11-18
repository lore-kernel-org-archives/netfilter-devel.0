From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling
Date: Tue, 18 Nov 2008 19:27:00 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181919160.2316@fbirervta.pbzchgretzou.qr>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com> <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr> <492305ED.8010207@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52075 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYKRS1C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:27:02 -0500
In-Reply-To: <492305ED.8010207@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-18 19:14, John Haxby wrote:
> Jan Engelhardt wrote:
>>
>>> /usr/include/iptables.h:5:29: error: libiptc/libiptc.h: No such file or
>>> directory
>>
>> [Try] Blame the Fedora packager for that.
>> libiptc.h is installed with the raw iptables tarball since 1.4.0+git61.
>
> I'd love to, but:[...]
> Clearly I'm doing something wrong.   Could you enlighten me?

There must have been a dimensional rift somewhere and I must have mixed 
something up. It is libxtc.h which is installed since then, because 
xtables.h depended on it somehow. Upon reanalyzing, I see that there is 
now room for patches to correct the current state. Thanks for pointing 
out!

In short, including iptables.h is not appropriate anymore; for
all the important definitions have moved to xtables.h.
