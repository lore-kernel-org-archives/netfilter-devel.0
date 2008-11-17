From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling
Date: Mon, 17 Nov 2008 23:45:57 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35414 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYKQWp6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:45:58 -0500
In-Reply-To: <4921F222.7020809@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-17 23:37, John Haxby wrote:
>>   
>> > Now, the easiest way to "fix" this is it to make sure that
>> > libiptc/libiptc.h is
>> > installed into /usr/include
>>
>> What iptables version?
>>   
> Fedora says iptables-1.4.1.1-2.fc9.x86_64 -- the few patches on top of 1.4.1
> don't do anything for this problem.

Blame the Fedora packager for that.
libiptc.h is installed with the raw iptables tarball since 1.4.0+git61.
