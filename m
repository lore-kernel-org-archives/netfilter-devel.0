From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Tue, 24 Feb 2009 15:09:52 +0100
Message-ID: <49A3FFB0.4050609@trash.net>
References: <20090220162831.1d0bf3d4@extreme> <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0902210347001.28533@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33160 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZBXOJz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:09:55 -0500
In-Reply-To: <alpine.LSU.2.00.0902210347001.28533@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-02-21 02:25, Jan Engelhardt wrote:
>> On Saturday 2009-02-21 01:28, Stephen Hemminger wrote:
>>
>>> Fix build failure of iptables utilities on debian/ubuntu, maybe other distros.
>>> The values INT_MIN and INT_MAX are used by many filters and these
>>> are defined in limits.h
>> No this is not right IMO, limits.h should be included for the same 
>> reason you would not do that to kernel's .h files.
>> Instead, limits.h should go in the .c files.
> 
> I wonder what debian has different in its Glibc files that
> limits.h is not included like it is for everybody else.

It works fine for me on Debian.

> Anyway, of course it should be included where due.
> Gawd, that led me to have clean some unnecessary includes
> up beforehand, but oh well.
> 
> Could you try the "limits" branch of git://dev.medozas.de/iptables
> if it compiles for you?

Unless Stephen has time to test this, I'll apply his patch. This
doesn't seem worth loosing time over.
